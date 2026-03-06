--!optimize 2
local Camera = workspace.CurrentCamera

local IntersectionCuts = {}
local BlockingPolygons = {}
local ScreenPolygons   = {}
local OutlineSegments  = {}

local EDGE_TOLERANCE = 0.1

local function CrossProduct2D(Origin, A, B)
    return (A.X - Origin.X) * (B.Y - Origin.Y) - (A.Y - Origin.Y) * (B.X - Origin.X)
end

local function SortPointsXY(A, B)
    return A.X < B.X or (A.X == B.X and A.Y < B.Y)
end

local function ComputeConvexHull(Points)
    local Count = #Points
    if Count < 3 then return Points end

    table.sort(Points, SortPointsXY)

    local Lower      = {}
    local Upper      = {}
    local LowerCount = 0
    local UpperCount = 0

    for Index = 1, Count do
        local P = Points[Index]
        while LowerCount >= 2 and CrossProduct2D(Lower[LowerCount - 1], Lower[LowerCount], P) <= 0 do
            Lower[LowerCount] = nil
            LowerCount -= 1
        end
        LowerCount += 1
        Lower[LowerCount] = P
    end

    for Index = Count, 1, -1 do
        local P = Points[Index]
        while UpperCount >= 2 and CrossProduct2D(Upper[UpperCount - 1], Upper[UpperCount], P) <= 0 do
            Upper[UpperCount] = nil
            UpperCount -= 1
        end
        UpperCount += 1
        Upper[UpperCount] = P
    end

    local Hull      = {}
    local HullCount = 0

    for Index = 1, LowerCount - 1 do
        HullCount += 1
        Hull[HullCount] = Lower[Index]
    end
    for Index = 1, UpperCount - 1 do
        HullCount += 1
        Hull[HullCount] = Upper[Index]
    end

    if HullCount > 0 then
        Hull[HullCount + 1] = Hull[1]
    end

    return Hull
end

local function PointInPolygon(PX, PY, Polygon, BBox)
    if PX < BBox.MinX or PX > BBox.MaxX or PY < BBox.MinY or PY > BBox.MaxY then
        return false
    end

    local Inside  = false
    local PrevIdx = #Polygon

    for CurrIdx = 1, #Polygon do
        local Curr = Polygon[CurrIdx]
        local Prev = Polygon[PrevIdx]

        if (Curr.Y > PY) ~= (Prev.Y > PY) and
           PX < (Prev.X - Curr.X) * (PY - Curr.Y) / (Prev.Y - Curr.Y) + Curr.X then
            Inside = not Inside
        end

        PrevIdx = CurrIdx
    end

    return Inside
end

local function LineSegmentIntersection(P1X, P1Y, P2X, P2Y, P3X, P3Y, P4X, P4Y)
    local Denom = (P4Y - P3Y) * (P2X - P1X) - (P4X - P3X) * (P2Y - P1Y)
    if math.abs(Denom) < 1e-5 then return nil end

    local T = ((P4X - P3X) * (P1Y - P3Y) - (P4Y - P3Y) * (P1X - P3X)) / Denom
    local U = ((P2X - P1X) * (P1Y - P3Y) - (P2Y - P1Y) * (P1X - P3X)) / Denom

    if T >= 0 and T <= 1 and U >= 0 and U <= 1 then
        return T
    end
end

local function ProjectPartToScreen(Part)
    local Position    = Part.Position
    local RightVector = Part.RightVector
    local UpVector    = Part.UpVector
    local LookVector  = Part.LookVector

    local PX, PY, PZ = Position.X, Position.Y, Position.Z

    local Size = Part.Size
    local HX   = Size.X * 0.5
    local HY   = Size.Y * 0.5
    local HZ   = Size.Z * 0.5

    local Viewport = Camera.ViewportSize
    local MaxX     = Viewport.X
    local MaxY     = Viewport.Y

    local ScreenPoints = {}
    local PointCount   = 0

    local SignX = HX
    for _ = 1, 2 do
        local SignY = HY
        for _ = 1, 2 do
            local SignZ = HZ
            for _ = 1, 2 do
                local WX = PX + RightVector.X * SignX + UpVector.X * SignY + LookVector.X * SignZ
                local WY = PY + RightVector.Y * SignX + UpVector.Y * SignY + LookVector.Y * SignZ
                local WZ = PZ + RightVector.Z * SignX + UpVector.Z * SignY + LookVector.Z * SignZ

                local Screen  = Camera:WorldToScreenPoint(vector.create(WX, WY, WZ))
                local SX, SY  = Screen.X, Screen.Y

                if SX > -100 and SX < MaxX + 100 and SY > -100 and SY < MaxY + 100 then
                    PointCount += 1
                    ScreenPoints[PointCount] = vector.create(SX, SY)
                end

                SignZ = -SignZ
            end
            SignY = -SignY
        end
        SignX = -SignX
    end

    return ScreenPoints
end

local function IsOuterEdge(EdgeStart, EdgeEnd, PolygonIndex, AllPolygons)
    local SX, SY = EdgeStart.X, EdgeStart.Y
    local EX, EY = EdgeEnd.X, EdgeEnd.Y

    for OtherIndex = 1, #AllPolygons do
        if OtherIndex == PolygonIndex then continue end

        local Verts = AllPolygons[OtherIndex].Vertices

        for VI = 1, #Verts - 1 do
            local V1 = Verts[VI]
            local V2 = Verts[VI + 1]

            local SameDir    = math.abs(V1.X - SX) < EDGE_TOLERANCE and math.abs(V1.Y - SY) < EDGE_TOLERANCE
                           and math.abs(V2.X - EX) < EDGE_TOLERANCE and math.abs(V2.Y - EY) < EDGE_TOLERANCE
            local ReverseDir = math.abs(V1.X - EX) < EDGE_TOLERANCE and math.abs(V1.Y - EY) < EDGE_TOLERANCE
                           and math.abs(V2.X - SX) < EDGE_TOLERANCE and math.abs(V2.Y - SY) < EDGE_TOLERANCE

            if SameDir or ReverseDir then return false end
        end
    end

    return true
end

local function GetNormalVector(P1, P2)
    local Dx  = P2.X - P1.X
    local Dy  = P2.Y - P1.Y
    local Len = math.sqrt(Dx * Dx + Dy * Dy)
    if Len < 0.001 then return vector.create(0, 0) end
    return vector.create(-Dy / Len, Dx / Len)
end

local function GetPartsFromTarget(Target)
    local Parts = {}
    local Count = 0

    local function Accept(Part)
        if Part:IsA("BasePart")
            and Part.Transparency < 1
            and Part.Name:match("%a") then
            Count += 1
            Parts[Count] = Part
        end
    end

    if typeof(Target) == "Instance" then
        if Target:IsA("Model") then
            for _, Child in ipairs(Target:GetChildren()) do
                Accept(Child)
            end
        else
            Accept(Target)
        end
    elseif type(Target) == "table" then
        for _, Part in ipairs(Target) do
            if typeof(Part) == "Instance" then
                Accept(Part)
            end
        end
    end

    return Parts
end

local function Highlight(Color, Target, Options)
    Options = Options or {}

    local ShowOutline      = Options.Outline ~= false
    local OutlineColor     = Options.OutlineColor or Color3.fromRGB(0, 0, 0)
    local OutlineThickness = Options.OutlineThickness or 1

    local ShowInline      = Options.Inline or false
    local InlineColor     = Options.InlineColor or OutlineColor
    local InlineThickness = Options.InlineThickness or OutlineThickness

    local ShowFill    = Options.Fill or false
    local FillColor   = Options.FillColor or Color
    local FillOpacity = Options.FillOpacity or 1

    local MainThickness = Options.MainThickness or 1

    -- Clear segment buffer
    for Index = 1, #OutlineSegments do
        OutlineSegments[Index] = nil
    end
    local SegmentCount = 0

    local ValidParts = GetPartsFromTarget(Target)
    local PartCount  = #ValidParts
    if PartCount == 0 then return end

    -- Project each part into a screen-space convex polygon
    local PolygonCount = 0

    for Index = 1, PartCount do
        local ScreenPoints = ProjectPartToScreen(ValidParts[Index])

        if #ScreenPoints >= 3 then
            local Hull = ComputeConvexHull(ScreenPoints)

            local MinX, MinY =  1e5,  1e5
            local MaxX, MaxY = -1e5, -1e5

            for _, V in ipairs(Hull) do
                if V.X < MinX then MinX = V.X end
                if V.X > MaxX then MaxX = V.X end
                if V.Y < MinY then MinY = V.Y end
                if V.Y > MaxY then MaxY = V.Y end
            end

            PolygonCount += 1
            ScreenPolygons[PolygonCount] = {
                Vertices = Hull,
                BBox     = {MinX = MinX, MinY = MinY, MaxX = MaxX, MaxY = MaxY},
            }
        end
    end

    for Index = PolygonCount + 1, #ScreenPolygons do
        ScreenPolygons[Index] = nil
    end

    if PolygonCount == 0 then return end

    -- Fill pass
    if ShowFill then
        for Index = 1, PolygonCount do
            local Verts  = ScreenPolygons[Index].Vertices
            local VCount = #Verts
            if VCount >= 3 then
                for VI = 2, VCount - 2 do
                    DrawingImmediate.FilledTriangle(Verts[1], Verts[VI], Verts[VI + 1], FillColor, FillOpacity)
                end
            end
        end
    end

    -- Outline pass — collect visible outer edge segments, skipping shared interior edges
    for PolygonIndex = 1, PolygonCount do
        local Polygon   = ScreenPolygons[PolygonIndex]
        local Verts     = Polygon.Vertices
        local BBox      = Polygon.BBox
        local VertCount = #Verts

        -- Gather overlapping polygons as potential blockers
        local BlockerCount = 0
        for OtherIndex = 1, PolygonCount do
            if OtherIndex == PolygonIndex then continue end
            local OtherBBox = ScreenPolygons[OtherIndex].BBox
            if not (BBox.MinX > OtherBBox.MaxX or BBox.MaxX < OtherBBox.MinX or
                    BBox.MinY > OtherBBox.MaxY or BBox.MaxY < OtherBBox.MinY) then
                BlockerCount += 1
                BlockingPolygons[BlockerCount] = ScreenPolygons[OtherIndex]
            end
        end

        for VI = 1, VertCount - 1 do
            local VStart = Verts[VI]
            local VEnd   = Verts[VI + 1]

            if not IsOuterEdge(VStart, VEnd, PolygonIndex, ScreenPolygons) then continue end

            local SX, SY = VStart.X, VStart.Y
            local EX, EY = VEnd.X,   VEnd.Y

            local EdgeMinX = math.min(SX, EX)
            local EdgeMaxX = math.max(SX, EX)
            local EdgeMinY = math.min(SY, EY)
            local EdgeMaxY = math.max(SY, EY)

            -- Seed cut list with edge endpoints
            local CutCount      = 2
            IntersectionCuts[1] = 0
            IntersectionCuts[2] = 1
            for Index = 3, #IntersectionCuts do
                IntersectionCuts[Index] = nil
            end

            -- Find all intersection T values against blocker edges
            for BI = 1, BlockerCount do
                local Blocker     = BlockingPolygons[BI]
                local BlockerBBox = Blocker.BBox

                if EdgeMinX > BlockerBBox.MaxX or EdgeMaxX < BlockerBBox.MinX or
                   EdgeMinY > BlockerBBox.MaxY or EdgeMaxY < BlockerBBox.MinY then
                    continue
                end

                local BlockerVerts = Blocker.Vertices
                for BVI = 1, #BlockerVerts - 1 do
                    local T = LineSegmentIntersection(
                        SX, SY, EX, EY,
                        BlockerVerts[BVI].X, BlockerVerts[BVI].Y,
                        BlockerVerts[BVI + 1].X, BlockerVerts[BVI + 1].Y
                    )
                    if T then
                        CutCount += 1
                        IntersectionCuts[CutCount] = T
                    end
                end
            end

            table.sort(IntersectionCuts)

            -- Walk sub-segments, emit those not occluded by a blocker
            local PrevCut = IntersectionCuts[1]
            for CI = 2, CutCount do
                local CurrCut = IntersectionCuts[CI]

                if CurrCut > PrevCut + 0.001 then
                    local MidT = (PrevCut + CurrCut) * 0.5
                    local MidX = SX + (EX - SX) * MidT
                    local MidY = SY + (EY - SY) * MidT

                    local Occluded = false
                    for BI = 1, BlockerCount do
                        if PointInPolygon(MidX, MidY, BlockingPolygons[BI].Vertices, BlockingPolygons[BI].BBox) then
                            Occluded = true
                            break
                        end
                    end

                    if not Occluded then
                        SegmentCount += 1
                        OutlineSegments[SegmentCount] = {
                            Start = vector.create(SX + (EX - SX) * PrevCut, SY + (EY - SY) * PrevCut),
                            End   = vector.create(SX + (EX - SX) * CurrCut, SY + (EY - SY) * CurrCut),
                        }
                    end
                end

                PrevCut = CurrCut
            end
        end
    end

    -- Draw pass
    for Index = 1, SegmentCount do
        local Seg    = OutlineSegments[Index]
        local Normal = GetNormalVector(Seg.Start, Seg.End)

        if ShowOutline then
            DrawingImmediate.Line(
                vector.create(Seg.Start.X + Normal.X * OutlineThickness, Seg.Start.Y + Normal.Y * OutlineThickness),
                vector.create(Seg.End.X   + Normal.X * OutlineThickness, Seg.End.Y   + Normal.Y * OutlineThickness),
                OutlineColor, 1, 1, OutlineThickness
            )
        end

        if ShowInline then
            DrawingImmediate.Line(
                vector.create(Seg.Start.X - Normal.X * InlineThickness, Seg.Start.Y - Normal.Y * InlineThickness),
                vector.create(Seg.End.X   - Normal.X * InlineThickness, Seg.End.Y   - Normal.Y * InlineThickness),
                InlineColor, 1, 1, InlineThickness
            )
        end

        DrawingImmediate.Line(Seg.Start, Seg.End, Color, 1, 1, MainThickness)
    end
end

return {
    Highlight = Highlight
}
