local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/Severe/refs/heads/main/Modules/Bounding.lua"))()

local Roles = {
    Knife = {"Murderer", Color3.fromRGB(255, 0, 0)},
    Gun = {"Sheriff", Color3.fromRGB(0, 0, 255)}
}

local Cache = {
    Map = nil,
    Gun = nil
}

local function GetMap()
    for _, Map in ipairs(Workspace:GetChildren()) do
        if Map.ClassName == "Model" and Map:HasTag("CurrentMap") then
            return Map
        end
    end
    return nil
end

local function GetGun()
    local Map = Cache.Map
    if not Map then return nil end

    for _, Gun in ipairs(Map:GetChildren()) do
        if Gun.ClassName == "Part" and Gun.Name == "GunDrop" then
            return Gun
        end
    end
    return nil
end

local function GetCharacterParts(Character)
    local Parts = {}
    local Count = 0
    
    for _, Child in ipairs(Character:GetChildren()) do
        local ClassName = Child.ClassName
        if ClassName == "Part" or ClassName == "MeshPart" then
            Count = Count + 1
            Parts[Count] = Child
        end
    end
    
    return Parts, Count
end

local function CheckRole(Player)
    local Character = Player.Character
    if not Character then return nil, nil end

    local Backpack = Player:FindFirstChild("Backpack")
    if not Backpack then return nil, nil end

    for _, Tool in ipairs(Character:GetChildren()) do
        local Data = Roles[Tool.Name]
        if Data then
            return Data[1], Data[2]
        end
    end

    for _, Tool in ipairs(Backpack:GetChildren()) do
        local Data = Roles[Tool.Name]
        if Data then
            return Data[1], Data[2]
        end
    end

    return nil, nil
end

local function Render()
    local Gun = Cache.Gun
    if Gun then
        local Screen, OnScreen = Camera:WorldToScreenPoint(Gun.Position)
        if OnScreen then
            DrawingImmediate.OutlinedText(Screen, 14, Color3.fromRGB(0, 255, 0), 1, "Gun", true, "Proggy")
        end
    end

    for _, Player in ipairs(Players:GetChildren()) do
        if Player == LocalPlayer then continue end

        local Role, Color = CheckRole(Player)
        if Role then
            local Character = Player.Character
            local Parts, Count = GetCharacterParts(Character)

            if Count > 0 then
                local BoundingBox = Module.GetBoundingBox(Parts)
                if BoundingBox then
                    local CenterX = BoundingBox.Position.X + BoundingBox.Size.X * 0.5
                    local BottomY = BoundingBox.Position.Y + BoundingBox.Size.Y + 1

                    DrawingImmediate.OutlinedText(Vector2.new(CenterX, BottomY), 14, Color, 1, Role, true, "Proggy")
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        
        local NewMap = GetMap()
        if NewMap ~= Cache.Map then
            Cache.Map = NewMap
        end

        local NewGun = GetGun()
        if NewGun ~= Cache.Gun then
            Cache.Gun = NewGun
        end
    end
end)

RunService.Render:Connect(Render)
