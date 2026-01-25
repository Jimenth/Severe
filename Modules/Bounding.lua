local AABB = {}

local function CalculateCorners(Part)
    local Size = Part.Size
    local Position = Part.Position
    local Look = Part.LookVector
    local Right = Part.RightVector
    local Up = Part.UpVector
    local Corners = {}

    for X = -0.5, 0.5, 1 do
        for Y = -0.5, 0.5, 1 do
            for Z = -0.5, 0.5, 1 do
                local OffsetX = X * Size.X
                local OffsetY = Y * Size.Y
                local OffsetZ = Z * Size.Z

                local WorldX = Position.X + Right.X * OffsetX + Up.X * OffsetY + Look.X * OffsetZ
                local WorldY = Position.Y + Right.Y * OffsetX + Up.Y * OffsetY + Look.Y * OffsetZ
                local WorldZ = Position.Z + Right.Z * OffsetX + Up.Z * OffsetY + Look.Z * OffsetZ

                table.insert(Corners, vector.create(WorldX, WorldY, WorldZ))
            end
        end
    end

    return Corners
end

function AABB.GetBoundingBox(Parts)
    local MinX, MinY = math.huge, math.huge
    local MaxX, MaxY = -math.huge, -math.huge
    local OnScreen = false

    for _, Part in Parts do
        for _, Corner in CalculateCorners(Part) do
            local ScreenPos, Visible = workspace.CurrentCamera:WorldToScreenPoint(Corner)
            if Visible then
                OnScreen = true
                MinX = math.min(MinX, ScreenPos.X)
                MinY = math.min(MinY, ScreenPos.Y)
                MaxX = math.max(MaxX, ScreenPos.X)
                MaxY = math.max(MaxY, ScreenPos.Y)
            end
        end
    end

    if not OnScreen then return nil end
    
    return {
        Position = vector.create(MinX, MinY),
        Size = vector.create(MaxX - MinX, MaxY - MinY)
    }
end

AABB.getboundingbox = AABB.GetBoundingBox
AABB.getboundingBox = AABB.GetBoundingBox

return AABB
