--!optimize 2
local Settings = _G.Settings
local Highlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/Severe/refs/heads/main/Modules/Highlight.lua"))();

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Vehicles = Workspace:FindFirstChild("SpawnedVehicles")
local Stored = {}

local function GetTeam(Engine)
    if not Engine then return nil end

    local Team = Engine:GetAttribute("Team")
    if typeof(Team) == "string" then
        return Team
    end

    return "Unknown Team"
end

local function IsAmmo(Name)
    local Lower = Name:lower()
    return Lower:match("ammo") or Lower:match("atgm") or Name:match("Ready Rack")
end

local function CacheVehicleModules(Vehicle)
    local Cached = {
        Vehicle = Vehicle,
        PrimaryPart = Vehicle.PrimaryPart,
        Engine = nil,
        Ammo = {},
        Drone = nil,
        DamageModules = Vehicle:FindFirstChild("DamageModules")
    }
    
    local Modules = Cached.DamageModules
    if Modules then
        local EngineFolder = Modules:FindFirstChild("Engine")
        if EngineFolder then
            Cached.Engine = EngineFolder:FindFirstChild("Engine")
        end
        
        for _, Module in ipairs(Modules:GetChildren()) do
            if IsAmmo(Module.Name) then
                for _, Child in ipairs(Module:GetChildren()) do
                    if Child.Name:match("^AmmoModel") then
                        table.insert(Cached.Ammo, Child)
                    end
                end
            end
        end
        
        local DroneFolder = Modules:FindFirstChild("DroneLauncher")
        if DroneFolder then
            Cached.Drone = DroneFolder:FindFirstChild("DroneLauncher")
        end
    end
    
    return Cached
end

local function UpdateCache()
    if not Vehicles then return end
    
    for Instance, Data in pairs(Stored) do
        if not Data.Vehicle or not Data.Vehicle.Parent or not Data.Vehicle.PrimaryPart then
            Stored[Instance] = nil
        end
    end
    
    for _, Vehicle in ipairs(Vehicles:GetChildren()) do
        if Vehicle.Name ~= "DONOT" and Vehicle.ClassName == "Model" and Vehicle.PrimaryPart then
            local CurrentCache = Stored[Vehicle]
            local CurrentModules = Vehicle:FindFirstChild("DamageModules")
            
            if not CurrentCache or CurrentCache.DamageModules ~= CurrentModules then
                Stored[Vehicle] = CacheVehicleModules(Vehicle)
            end
        end
    end
end

local function Render()
    if not Settings.Rendering.Enabled or not LocalPlayer then return end
    
    for Index, Data in pairs(Stored) do
        local Vehicle = Data.Vehicle
        local PrimaryPart = Data.PrimaryPart
        
        if Vehicle and Vehicle.Parent and PrimaryPart and PrimaryPart.Parent then
            local Team = GetTeam(Data.Engine)
            
            if not Settings.Teamcheck or (Team and LocalPlayer.Team and Team ~= LocalPlayer.Team.Name) then
                local Screen, OnScreen = Camera:WorldToScreenPoint(PrimaryPart.Position)
                if OnScreen then
                    local Character = LocalPlayer.Character
                    if not Character then return nil end

                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                    local Text = Vehicle.Name

                    if HumanoidRootPart then
                        local Distance = vector.magnitude(HumanoidRootPart.Position - PrimaryPart.Position)
                        local ScaledDistance = Distance / 2.78125

                        Text = string.format(
                            "%s [%.0f]",
                            Vehicle.Name,
                            ScaledDistance
                        )
                    end

                    DrawingImmediate.OutlinedText(
                        Screen,
                        13,
                        Color3.fromRGB(255, 255, 255),
                        1,
                        Text,
                        true,
                        "Proggy"
                    )
                end

                if Settings.Rendering.Modules.Enabled then
                    if Settings.Rendering.Modules.Engine[1] and Data.Engine and Data.Engine.Parent then
                        Highlight.Highlight(
                            Settings.Rendering.Modules.Engine[2], 
                            Data.Engine, {
                            Outline = false,
                            OutlineColor = Color3.fromRGB(0, 0, 0),
                            OutlineThickness = 2,
                            Inline = false,
                            InlineColor = Color3.fromRGB(0, 0, 0),
                            InlineThickness = 1,
                            Fill = true,
                            FillColor = Settings.Rendering.Modules.Engine[2],
                            FillOpacity = 0.3
                        })
                    end

                    if Settings.Rendering.Modules.Ammo[1] then
                        for _, AmmoObject in ipairs(Data.Ammo) do
                            if AmmoObject and AmmoObject.Parent then
                                Highlight.Highlight(
                                    Settings.Rendering.Modules.Ammo[2], 
                                    AmmoObject, {
                                    Outline = false,
                                    OutlineColor = Color3.fromRGB(0, 0, 0),
                                    OutlineThickness = 2,
                                    Inline = false,
                                    InlineColor = Color3.fromRGB(0, 0, 0),
                                    InlineThickness = 1,
                                    Fill = true,
                                    FillColor = Settings.Rendering.Modules.Ammo[2],
                                    FillOpacity = 0.3
                                })
                            end
                        end
                    end

                    if Settings.Rendering.Modules.Drone[1] and Data.Drone and Data.Drone.Parent then
                        Highlight.Highlight(
                            Settings.Rendering.Modules.Drone[2], 
                            Data.Drone, {
                            Outline = false,
                            OutlineColor = Color3.fromRGB(0, 0, 0),
                            OutlineThickness = 2,
                            Inline = false,
                            InlineColor = Color3.fromRGB(0, 0, 0),
                            InlineThickness = 1,
                            Fill = true,
                            FillColor = Settings.Rendering.Modules.Drone[2],
                            FillOpacity = 0.3
                        })
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1 / 10)
        UpdateCache()
    end
end)

RunService.Render:Connect(Render)
