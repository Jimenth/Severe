--!optimize 2
local Camera = workspace.CurrentCamera

local IntersectionCuts = {}
local BlockingPolygons = {}
local ScreenPolygons = {}
local OutlineSegments = {}

local function CrossProduct2D(Origin, PointA, PointB) 
    return (PointA.X - Origin.X) * (PointB.Y - Origin.Y) - (PointA.Y - Origin.Y) * (PointB.X - Origin.X) 
end

local function SortPointsXY(A, B) 
    return A.X < B.X or (A.X == B.X and A.Y < B.Y) 
end

local function ComputeConvexHull(Points)
    if #Points < 3 then return Points end
    table.sort(Points, SortPointsXY)
    
    local LowerHull = {}
    local UpperHull = {}
    local LowerCount = 0
    local UpperCount = 0
    
    for I = 1, #Points do
        local CurrentPoint = Points[I]
        while LowerCount >= 2 and 
              CrossProduct2D(LowerHull[LowerCount - 1], LowerHull[LowerCount], CurrentPoint) <= 0 do
            LowerHull[LowerCount] = nil
            LowerCount -= 1
        end
        LowerCount += 1
        LowerHull[LowerCount] = CurrentPoint
    end
    
    for I = #Points, 1, -1 do
        local CurrentPoint = Points[I]
        while UpperCount >= 2 and 
              CrossProduct2D(UpperHull[UpperCount - 1], UpperHull[UpperCount], CurrentPoint) <= 0 do
            UpperHull[UpperCount] = nil
            UpperCount -= 1
        end
        UpperCount += 1
        UpperHull[UpperCount] = CurrentPoint
    end
    
    local Hull = {}
    local HullCount = 0
    for I = 1, LowerCount - 1 do 
        HullCount += 1
        Hull[HullCount] = LowerHull[I]
    end
    for I = 1, UpperCount - 1 do 
        HullCount += 1
        Hull[HullCount] = UpperHull[I]
    end
    
    if HullCount > 0 then 
        Hull[HullCount + 1] = Hull[1] 
    end
    
    return Hull
end

local function PointInPolygon(PointX, PointY, Polygon, BoundingBox)
    if PointX < BoundingBox.MinX or PointX > BoundingBox.MaxX or 
       PointY < BoundingBox.MinY or PointY > BoundingBox.MaxY then 
        return false 
    end
    
    local IsInside = false
    local PreviousVertexIndex = #Polygon
    
    for CurrentVertexIndex = 1, #Polygon do
        local CurrentVertex = Polygon[CurrentVertexIndex]
        local PreviousVertex = Polygon[PreviousVertexIndex]
        
        if ((CurrentVertex.Y > PointY) ~= (PreviousVertex.Y > PointY)) and 
           (PointX < (PreviousVertex.X - CurrentVertex.X) * (PointY - CurrentVertex.Y) / 
                     (PreviousVertex.Y - CurrentVertex.Y) + CurrentVertex.X) then
            IsInside = not IsInside
        end
        PreviousVertexIndex = CurrentVertexIndex
    end
    
    return IsInside
end

local function LineSegmentIntersection(P1X, P1Y, P2X, P2Y, P3X, P3Y, P4X, P4Y)
    local Denominator = (P4Y - P3Y) * (P2X - P1X) - (P4X - P3X) * (P2Y - P1Y)
    if math.abs(Denominator) < 1e-5 then return nil end
    
    local TNumerator = ((P4X - P3X) * (P1Y - P3Y) - (P4Y - P3Y) * (P1X - P3X))
    local UNumerator = ((P2X - P1X) * (P1Y - P3Y) - (P2Y - P1Y) * (P1X - P3X))
    
    local T = TNumerator / Denominator
    local U = UNumerator / Denominator
    
    if T >= 0 and T <= 1 and U >= 0 and U <= 1 then 
        return T 
    end
    return nil
end

local function ProjectPartToScreen(Part)
    local Position = Part.Position
    local RightVector = Part.RightVector
    local UpVector = Part.UpVector
    local LookVector = Part.LookVector
    
    local PX, PY, PZ = Position.X, Position.Y, Position.Z
    
    local Size = Part.Size
    local HalfX = Size.X * 0.5
    local HalfY = Size.Y * 0.5
    local HalfZ = Size.Z * 0.5
    
    local Corners = {
        vector.create(HalfX, HalfY, HalfZ),
        vector.create(HalfX, HalfY, -HalfZ),
        vector.create(HalfX, -HalfY, HalfZ),
        vector.create(HalfX, -HalfY, -HalfZ),
        vector.create(-HalfX, HalfY, HalfZ),
        vector.create(-HalfX, HalfY, -HalfZ),
        vector.create(-HalfX, -HalfY, HalfZ),
        vector.create(-HalfX, -HalfY, -HalfZ)
    }
    
    local ScreenPoints = {}
    local ViewportSize = Camera.ViewportSize
    local MaxX = ViewportSize.X
    local MaxY = ViewportSize.Y
    
    for CornerIndex = 1, 8 do
        local LocalCorner = Corners[CornerIndex]
        
        local WorldX = PX + RightVector.X * LocalCorner.X + UpVector.X * LocalCorner.Y + LookVector.X * LocalCorner.Z
        local WorldY = PY + RightVector.Y * LocalCorner.X + UpVector.Y * LocalCorner.Y + LookVector.Y * LocalCorner.Z
        local WorldZ = PZ + RightVector.Z * LocalCorner.X + UpVector.Z * LocalCorner.Y + LookVector.Z * LocalCorner.Z
        
        local WorldPosition = vector.create(WorldX, WorldY, WorldZ)
        local ScreenPosition, IsVisible = Camera:WorldToScreenPoint(WorldPosition)
        
        local ScreenX = ScreenPosition.X
        local ScreenY = ScreenPosition.Y
        
        if ScreenX > -100 and ScreenX < MaxX + 100 and ScreenY > -100 and ScreenY < MaxY + 100 then
            table.insert(ScreenPoints, vector.create(ScreenX, ScreenY))
        end
    end
    
    return ScreenPoints
end

local function IsOuterEdge(EdgeStart, EdgeEnd, PolygonIndex, AllPolygons)
    local Tolerance = 0.1
    
    for OtherIndex = 1, #AllPolygons do
        if OtherIndex ~= PolygonIndex then
            local OtherVertices = AllPolygons[OtherIndex].Vertices
            
            for VI = 1, #OtherVertices - 1 do
                local V1 = OtherVertices[VI]
                local V3 = OtherVertices[VI + 1]
                
                local SameDirection = (math.abs(V1.X - EdgeStart.X) < Tolerance and math.abs(V1.Y - EdgeStart.Y) < Tolerance and math.abs(V3.X - EdgeEnd.X) < Tolerance and math.abs(V3.Y - EdgeEnd.Y) < Tolerance)
                local ReverseDirection = (math.abs(V1.X - EdgeEnd.X) < Tolerance and math.abs(V1.Y - EdgeEnd.Y) < Tolerance and math.abs(V3.X - EdgeStart.X) < Tolerance and math.abs(V3.Y - EdgeStart.Y) < Tolerance)
                
                if SameDirection or ReverseDirection then return false end
            end
        end
    end
    
    return true
end

local function GetNormalVector(P1, P2)
    local Dx = P2.X - P1.X
    local Dy = P2.Y - P1.Y
    local Length = math.sqrt(Dx * Dx + Dy * Dy)
    if Length < 0.001 then return vector.create(0, 0) end
    return vector.create(-Dy / Length, Dx / Length)
end

local function GetPartsFromTarget(Target)
    local Parts = {}
    
    if typeof(Target) == "Instance" then
        if Target.ClassName == "Model" then
            for _, Child in ipairs(Target:GetChildren()) do
                if (Child.ClassName == "Part" or Child.ClassName == "MeshPart") and Child.Transparency < 1 then
                    table.insert(Parts, Child)
                end
            end
        elseif Target.ClassName == "Part" or Target.ClassName == "MeshPart" then
            if Target.Transparency < 1 then
                table.insert(Parts, Target)
            end
        end
    elseif type(Target) == "table" then
        for _, Part in ipairs(Target) do
            if typeof(Part) == "Instance" and (Part.ClassName == "Part" or Part.ClassName == "MeshPart") and Part.Transparency < 1 then
                table.insert(Parts, Part)
            end
        end
    end
    
    return Parts
end

local function Highlight(Color, Target, Options)
    Options = Options or {}
    
    local ShowOutline = Options.Outline ~= false
    local OutlineColor = Options.OutlineColor or Color3.fromRGB(0, 0, 0)
    local OutlineThickness = Options.OutlineThickness or 1
    
    local ShowInline = Options.Inline or false
    local InlineColor = Options.InlineColor or OutlineColor
    local InlineThickness = Options.InlineThickness or OutlineThickness
    
    local ShowFill = Options.Fill or false
    local FillColor = Options.FillColor or Color
    local FillOpacity = Options.FillOpacity or 1
    
    local MainThickness = Options.MainThickness or 1
    
    for I = 1, #OutlineSegments do
        OutlineSegments[I] = nil
    end
    local SegmentCount = 0
    
    local ValidParts = GetPartsFromTarget(Target)
    local PartCount = #ValidParts
    
    if PartCount == 0 then return end
    
    local PolygonCount = 0
    
    for PartIndex = 1, PartCount do
        local Part = ValidParts[PartIndex]
        local ScreenPoints = ProjectPartToScreen(Part)
        
        if ScreenPoints and #ScreenPoints >= 3 then
            local Hull = ComputeConvexHull(ScreenPoints)
            
            local MinX, MinY = 100000, 100000
            local MaxX, MaxY = -100000, -100000
            
            for VertexIndex = 1, #Hull do
                local Vertex = Hull[VertexIndex]
                if Vertex.X < MinX then MinX = Vertex.X end
                if Vertex.X > MaxX then MaxX = Vertex.X end
                if Vertex.Y < MinY then MinY = Vertex.Y end
                if Vertex.Y > MaxY then MaxY = Vertex.Y end
            end
            
            PolygonCount += 1
            ScreenPolygons[PolygonCount] = {
                Vertices = Hull,
                BBox = { MinX = MinX, MinY = MinY, MaxX = MaxX, MaxY = MaxY },
                Part = Part
            }
        end
    end
    
    for ClearIndex = PolygonCount + 1, #ScreenPolygons do 
        ScreenPolygons[ClearIndex] = nil 
    end
    
    if PolygonCount == 0 then return end
    
    if ShowFill then
        for PolygonIndex = 1, PolygonCount do
            local Vertices = ScreenPolygons[PolygonIndex].Vertices
            if #Vertices >= 3 then
                for I = 2, #Vertices - 2 do
                    DrawingImmediate.FilledTriangle(
                        Vertices[1], Vertices[I], Vertices[I + 1],
                        FillColor, FillOpacity
                    )
                end
            end
        end
    end
    
    for PolygonIndex = 1, PolygonCount do
        local CurrentPolygon = ScreenPolygons[PolygonIndex]
        local CurrentVertices = CurrentPolygon.Vertices
        local CurrentBBox = CurrentPolygon.BBox
        local VertexCount = #CurrentVertices
        
        local BlockerCount = 0
        for OtherIndex = 1, PolygonCount do
            if PolygonIndex ~= OtherIndex then
                local OtherBBox = ScreenPolygons[OtherIndex].BBox
                if not (CurrentBBox.MinX > OtherBBox.MaxX or CurrentBBox.MaxX < OtherBBox.MinX or 
                       CurrentBBox.MinY > OtherBBox.MaxY or CurrentBBox.MaxY < OtherBBox.MinY) then
                    BlockerCount += 1
                    BlockingPolygons[BlockerCount] = ScreenPolygons[OtherIndex]
                end
            end
        end
        
        for VertexIndex = 1, VertexCount - 1 do
            local VertexStart = CurrentVertices[VertexIndex]
            local VertexEnd = CurrentVertices[VertexIndex + 1]
            
            if IsOuterEdge(VertexStart, VertexEnd, PolygonIndex, ScreenPolygons) then
                local StartX, StartY = VertexStart.X, VertexStart.Y
                local EndX, EndY = VertexEnd.X, VertexEnd.Y
                
                local EdgeMinX = math.min(StartX, EndX)
                local EdgeMaxX = math.max(StartX, EndX)
                local EdgeMinY = math.min(StartY, EndY)
                local EdgeMaxY = math.max(StartY, EndY)
                
                local CutCount = 2
                IntersectionCuts[1] = 0
                IntersectionCuts[2] = 1
                for ClearIndex = 3, #IntersectionCuts do 
                    IntersectionCuts[ClearIndex] = nil 
                end
                
                for BlockerIndex = 1, BlockerCount do
                    local Blocker = BlockingPolygons[BlockerIndex]
                    local BlockerBBox = Blocker.BBox
                    
                    if not (EdgeMinX > BlockerBBox.MaxX or EdgeMaxX < BlockerBBox.MinX or 
                           EdgeMinY > BlockerBBox.MaxY or EdgeMaxY < BlockerBBox.MinY) then
                        
                        local BlockerVertices = Blocker.Vertices
                        for BlockerEdgeIndex = 1, #BlockerVertices - 1 do
                            local BlockerStart = BlockerVertices[BlockerEdgeIndex]
                            local BlockerEnd = BlockerVertices[BlockerEdgeIndex + 1]
                            
                            local IntersectionT = LineSegmentIntersection(
                                StartX, StartY, EndX, EndY,
                                BlockerStart.X, BlockerStart.Y, BlockerEnd.X, BlockerEnd.Y
                            )
                            
                            if IntersectionT then
                                CutCount += 1
                                IntersectionCuts[CutCount] = IntersectionT
                            end
                        end
                    end
                end
                
                table.sort(IntersectionCuts)
                
                local PreviousCut = IntersectionCuts[1]
                for CutIndex = 2, CutCount do
                    local CurrentCut = IntersectionCuts[CutIndex]
                    
                    if CurrentCut > PreviousCut + 0.001 then
                        local MidpointT = (PreviousCut + CurrentCut) * 0.5
                        local MidpointX = StartX + (EndX - StartX) * MidpointT
                        local MidpointY = StartY + (EndY - StartY) * MidpointT
                        
                        local IsOccluded = false
                        for BlockerIndex = 1, BlockerCount do
                            if PointInPolygon(MidpointX, MidpointY, BlockingPolygons[BlockerIndex].Vertices,
                                            BlockingPolygons[BlockerIndex].BBox) then
                                IsOccluded = true
                                break
                            end
                        end
                        
                        if not IsOccluded then
                            local SegStart = vector.create(StartX + (EndX - StartX) * PreviousCut, StartY + (EndY - StartY) * PreviousCut)
                            local SegEnd = vector.create(StartX + (EndX - StartX) * CurrentCut, StartY + (EndY - StartY) * CurrentCut)
                            
                            SegmentCount += 1
                            OutlineSegments[SegmentCount] = { Start = SegStart, End = SegEnd }
                        end
                        
                        PreviousCut = CurrentCut
                    end
                end
            end
        end
    end
    
    for I = 1, SegmentCount do
        local Segment = OutlineSegments[I]
        local Normal = GetNormalVector(Segment.Start, Segment.End)
        
        if ShowOutline then
            local OuterStart = vector.create(
                Segment.Start.X + Normal.X * OutlineThickness,
                Segment.Start.Y + Normal.Y * OutlineThickness
            )
            local OuterEnd = vector.create(
                Segment.End.X + Normal.X * OutlineThickness,
                Segment.End.Y + Normal.Y * OutlineThickness
            )
            DrawingImmediate.Line(OuterStart, OuterEnd, OutlineColor, 1, 1, OutlineThickness)
        end
        
        if ShowInline then
            local InnerStart = vector.create(
                Segment.Start.X - Normal.X * InlineThickness,
                Segment.Start.Y - Normal.Y * InlineThickness
            )
            local InnerEnd = vector.create(
                Segment.End.X - Normal.X * InlineThickness,
                Segment.End.Y - Normal.Y * InlineThickness
            )
            DrawingImmediate.Line(InnerStart, InnerEnd, InlineColor, 1, 1, InlineThickness)
        end
        
        DrawingImmediate.Line(
            Segment.Start, Segment.End, Color, 1, 1, MainThickness
        )
    end
end

return {
    Highlight = Highlight
}
