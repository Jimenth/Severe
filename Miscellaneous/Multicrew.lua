--!optimize 2
local Settings = _G.Settings

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Vehicles = Workspace:FindFirstChild("SpawnedVehicles")
local Placed = Workspace:FindFirstChild("PlacedBuildings")

local Stored = {
    Vehicles = {},
    Drones = {}
}

local Convex = {
    Scratch = {
        Points = {},
        Hull = {},
        Poly = {}
    },

    Static = {
        HWMPoints = 0,
        HWMHull = 0,
        HWMPoly = 0
    }
}

local function TruncateBuffer(Buffer, NewSize, HighWaterMark)
    for Index = NewSize + 1, HighWaterMark do
        Buffer[Index] = nil
    end
    return math.max(NewSize, HighWaterMark)
end

local function CrossDimension(OriginX, OriginY, PointAX, PointAY, PointBX, PointBY)
    return (PointAX - OriginX) * (PointBY - OriginY) - (PointAY - OriginY) * (PointBX - OriginX)
end

local function CalculateConvexHull(Points, PointCount, Outer)
    if PointCount == 0 then return 0 end
    if PointCount == 1 then Outer[1] = Points[1]; return 1 end
    if PointCount == 2 then Outer[1] = Points[1]; Outer[2] = Points[2]; return 2 end

    table.sort(Points, function(PointA, PointB)
        return PointA.X < PointB.X or (PointA.X == PointB.X and PointA.Y < PointB.Y)
    end)

    local Size = 0

    for Index = 1, PointCount do
        local Point = Points[Index]
        while Size >= 2 and CrossDimension(Outer[Size - 1].X, Outer[Size - 1].Y, Outer[Size].X, Outer[Size].Y, Point.X, Point.Y) <= 0 do
            Size = Size - 1
        end
        Size = Size + 1
        Outer[Size] = Point
    end

    local LowerHullSize = Size
    for Index = PointCount - 1, 1, -1 do
        local Point = Points[Index]
        while Size > LowerHullSize and CrossDimension(Outer[Size - 1].X, Outer[Size - 1].Y, Outer[Size].X, Outer[Size].Y, Point.X, Point.Y) <= 0 do
            Size = Size - 1
        end
        Size = Size + 1
        Outer[Size] = Point
    end

    return Size - 1
end

local function ProjectPartCorners(Part, WriteOffset)
    local PositionX = Part.Position.X
    local PositionY = Part.Position.Y
    local PositionZ = Part.Position.Z

    local HalfSizeX = Part.Size.X * 0.5
    local HalfSizeY = Part.Size.Y * 0.5
    local HalfSizeZ = Part.Size.Z * 0.5

    local RightVector = Part.RightVector
    local UpVector = Part.UpVector
    local LookVector = Part.LookVector

    local RightX = RightVector.X * HalfSizeX
    local RightY = RightVector.Y * HalfSizeX
    local RightZ = RightVector.Z * HalfSizeX

    local UpX = UpVector.X * HalfSizeY
    local UpY = UpVector.Y * HalfSizeY
    local UpZ = UpVector.Z * HalfSizeY

    local LookX = LookVector.X * HalfSizeZ
    local LookY = LookVector.Y * HalfSizeZ
    local LookZ = LookVector.Z * HalfSizeZ

    local SignR = 1
    for _ = 1, 2 do
        local SignU = 1
        for _ = 1, 2 do
            local SignL = 1
            for _ = 1, 2 do
                local WorldPoint = Vector3.new(
                    PositionX + SignR * RightX + SignU * UpX + SignL * LookX,
                    PositionY + SignR * RightY + SignU * UpY + SignL * LookY,
                    PositionZ + SignR * RightZ + SignU * UpZ + SignL * LookZ
                )

                local ScreenPoint, OnScreen = Camera:WorldToScreenPoint(WorldPoint)
                if OnScreen then
                    WriteOffset = WriteOffset + 1
                    local Slot = Convex.Scratch.Points[WriteOffset]
                    if Slot then
                        Slot.X = ScreenPoint.X
                        Slot.Y = ScreenPoint.Y
                    else
                        Convex.Scratch.Points[WriteOffset] = {X = ScreenPoint.X, Y = ScreenPoint.Y}
                    end
                end

                SignL = -1
            end
            SignU = -1
        end
        SignR = -1
    end

    return WriteOffset
end

local function DrawPolygon(Hull, Size, Color, Opacity)
    if Size < 3 then return end

    local Pivot = Vector2.new(Hull[1].X, Hull[1].Y)
    for Index = 2, Size - 1 do
        DrawingImmediate.FilledTriangle(Pivot, Vector2.new(Hull[Index].X, Hull[Index].Y), Vector2.new(Hull[Index + 1].X, Hull[Index + 1].Y), Color, Opacity)
    end
end

local function DrawOutline(Hull, Size, Color, Opacity, Thickness)
    if Size < 2 then return end

    for Index = 1, Size do
        local Entry = Hull[Index]
        Convex.Scratch.Poly[Index] = Vector2.new(Entry.X, Entry.Y)
    end

    Convex.Scratch.Poly[Size + 1] = Vector2.new(Hull[1].X, Hull[1].Y)
    Convex.Scratch.Poly[Size + 2] = nil

    if Size + 1 < Convex.Static.HWMPoly then
        for Index = Size + 2, Convex.Static.HWMPoly do
            Convex.Scratch.Poly[Index] = nil
        end
    end

    Convex.Static.HWMPoly = math.max(Convex.Static.HWMPoly, Size + 1)

    DrawingImmediate.Polyline(Convex.Scratch.Poly, Color, Opacity, Thickness)
end

local function NotNumerical(Name)
    return Name:match("%a") ~= nil
end

local function GetPlayerTeam(Name)
    if typeof(Name) ~= "string" then return nil end

    local Player = Players:FindFirstChild(Name)
    if not Player then return nil end

    local Team = Player.Team
    if Team and Team.Parent then
        return Team.Name
    end

    return "Unknown Team"
end

local function GetVehicleTeam(Vehicle)
    if not Vehicle then return nil end

    local OwnerName = Vehicle:GetAttribute("Requester")
    if typeof(OwnerName) ~= "string" then return nil end
    
    return GetPlayerTeam(OwnerName)
end

local function VehicleCache()
    if not Vehicles then return end

    local Current = {}

    for _, Vehicle in ipairs(Vehicles:GetChildren()) do
        if Vehicle.Name == "DONOT" or Vehicle.ClassName ~= "Model" or not Vehicle.PrimaryPart then
            continue
        end

        local Address = Vehicle
        Current[Address] = true

        if not Stored.Vehicles[Address] then
            local DamageModules = Vehicle:FindFirstChild("DamageModules")

            Stored.Vehicles[Address] = {Vehicle = Vehicle, PrimaryPart = Vehicle.PrimaryPart, Groups = nil}

            task.delay(1, function()
                local Data = Stored.Vehicles[Address]
                if not Data or Data.Groups then return end
                if not (DamageModules and DamageModules.Parent) then return end

                local Groups = {}

                for _, Module in ipairs(DamageModules:GetChildren()) do
                    if not (Module:IsA("Model") or Module:IsA("Folder")) then continue end

                    local ModuleName = Module.Name:lower()

                    if ModuleName == "engine" then
                        local EnginePart = Module:FindFirstChild("Engine")
                        if EnginePart then Groups[#Groups + 1] = {Type = "Engine", Parts = {EnginePart}} end

                    elseif ModuleName:find("ammo") or ModuleName:find("atgm") then
                        local Parts = {}
                        for _, Child in ipairs(Module:GetChildren()) do
                            if Child:IsA("BasePart") and NotNumerical(Child.Name) and not Child.Name:find("cube") then
                                Parts[#Parts + 1] = Child
                            end
                        end
                        if #Parts > 0 then
                            Groups[#Groups + 1] = {Type = "Ammo", Parts = Parts}
                        end
                    end
                end

                Data.Groups = Groups
            end)
        end
    end

    for Address in pairs(Stored.Vehicles) do
        if not Current[Address] then
            Stored.Vehicles[Address] = nil
        end
    end
end

local function DroneCache()
    if not Placed then print("Placed is nil") return end

    local Current = {}

    for _, Drone in ipairs(Placed:GetChildren()) do
        if Drone:IsA("Model") and Drone.Name:lower():find("drone") then
            Current[Drone] = true

            if not Stored.Drones[Drone] then
                local DroneModel = Drone:FindFirstChild("Drone")
                if not DroneModel then continue end

                local DronePart = DroneModel and DroneModel:IsA("Model") and DroneModel:FindFirstChild("Drone") 
                if not DronePart then continue end

                local OwnerTag = Drone:FindFirstChild("OwnershipTag")
                if not OwnerTag then continue end

                if DronePart and DronePart:IsA("BasePart") then
                    Stored.Drones[Drone] = {
                        Model = Drone,
                        Part = DronePart,
                        OwnerTag = OwnerTag
                    }
                end
            end
        end
    end

    for Instance in pairs(Stored.Drones) do
        if not Current[Instance] then
            Stored.Drones[Instance] = nil
        end
    end
end

local function Render()
    if not LocalPlayer then return end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if Settings.Vehicles.Enabled then
        for _, Data in pairs(Stored.Vehicles) do
            local Vehicle = Data.Vehicle
            local PrimaryPart = Data.PrimaryPart

            if not (Vehicle and Vehicle.Parent and PrimaryPart and PrimaryPart.Parent) then continue end

            if is_team_check_active() then
                local Team = GetVehicleTeam(Vehicle)
                if LocalPlayer.Team and LocalPlayer.Team.Parent and Team == LocalPlayer.Team.Name then
                    continue
                end
            end

            local Screen, OnScreen = Camera:WorldToScreenPoint(PrimaryPart.Position)

            if OnScreen then
                if not (Settings.Vehicles.Occupied.Require and Vehicle:GetAttribute("Occupied") ~= "true") then
                    local Text = ""

                    if Settings.Vehicles.Text.Name then
                        Text = Vehicle.Name
                    end

                    if Settings.Vehicles.Text.Distance and HumanoidRootPart then
                        local Distance     = vector.magnitude(HumanoidRootPart.Position - PrimaryPart.Position)
                        local DistanceText = string.format("[%.0f]", Distance / 2.78125)
                        Text = Text ~= "" and (Text .. " " .. DistanceText) or DistanceText
                    end

                    if Text ~= "" then
                        local TextColor = Vehicle:GetAttribute("Occupied") == "true" and Settings.Vehicles.Occupied.Color or Color3.fromRGB(255, 255, 255)
                        DrawingImmediate.OutlinedText(Screen, 12, TextColor, 1, Text, true, "Proxyma_Condensed")
                    end
                end
            end

            local Groups = Data.Groups
            if not (Settings.Vehicles.Modules.Enabled and Groups) then continue end

            for _, Group in ipairs(Groups) do
                local GroupType = Group.Type

                local Enabled = (GroupType == "Engine" and Settings.Vehicles.Modules.Engine[1]) or (GroupType == "Ammo"   and Settings.Vehicles.Modules.Ammo[1])
                if not Enabled then continue end

                local Color = GroupType == "Engine" and Settings.Vehicles.Modules.Engine[2] or  Settings.Vehicles.Modules.Ammo[2]

                local PointCount = 0
                for _, Part in ipairs(Group.Parts) do
                    if Part and Part.Parent then
                        PointCount = ProjectPartCorners(Part, PointCount)
                    end
                end

                if PointCount == 0 then continue end
                Convex.Static.HWMPoints = TruncateBuffer(Convex.Scratch.Points, PointCount, Convex.Static.HWMPoints)

                local Size = CalculateConvexHull(Convex.Scratch.Points, PointCount, Convex.Scratch.Hull)
                if Size == 0 then continue end

                Convex.Static.HWMHull = TruncateBuffer(Convex.Scratch.Hull, Size, Convex.Static.HWMHull)

                DrawPolygon(Convex.Scratch.Hull, Size, Color, 0.3)
                DrawOutline(Convex.Scratch.Hull, Size, Color, 1, 1)
            end
        end
    end

    if Settings.Drones.Enabled then
        for _, Data in pairs(Stored.Drones) do
            local Part = Data.Part
            if not Part or not Part.Parent then continue end

            if is_team_check_active() then
                local Team
                if Data.OwnerTag and Data.OwnerTag.Parent and Data.OwnerTag:IsA("StringValue") then
                    Team = GetPlayerTeam(Data.OwnerTag.Value)
                end
                if LocalPlayer.Team and LocalPlayer.Team.Parent and Team == LocalPlayer.Team.Name then
                    continue
                end
            end

            local Screen, OnScreen = Camera:WorldToScreenPoint(Part.Position)
            if not OnScreen then continue end

            local DroneText = "Drone"
            if HumanoidRootPart then
                local Distance = vector.magnitude(HumanoidRootPart.Position - Part.Position) / 2.78125
                DroneText = string.format("Drone [%.0f]", Distance)
            end

            DrawingImmediate.OutlinedText(Screen, 12, Settings.Drones.Color, 1, DroneText, true, "Proxyma_Condensed")
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        VehicleCache()
        DroneCache()
    end
end)

RunService.Render:Connect(Render)
