--!optimize 2
local Settings = _G.Settings
local Highlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/Severe/refs/heads/main/Modules/Highlight.lua"))();

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

local function GetTeam(Engine)
    if not Engine then return nil end

    local Team = Engine:GetAttribute("Team")
    if typeof(Team) == "string" then
        return Team
    end

    return "Unknown Team"
end

local function GetPlayerTeam(Name)
    if typeof(Name) ~= "string" then return nil end

    local Player = Players:FindFirstChild(Name)
    if not Player then return nil end 

    local Team = Player.Team
    if Team then
        return Team.Name
    else
        return "Unknown Team"
    end
end

local function IsAmmo(Name)
    local Lower = Name:lower()
    return Lower:match("ammo") or Lower:match("atgm") or Name:match("Ready Rack")
end

local function CacheModules(Vehicle)
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

local function CacheDrones()
    if not Placed then return end

    for Instance, Data in pairs(Stored.Drones) do
        if not Data.Model or not Data.Model.Parent or not Data.Part or not Data.Part.Parent then
            Stored.Drones[Instance] = nil
        end
    end

    for _, Drone in ipairs(Placed:GetChildren()) do
        if typeof(Drone) == "Instance"
        and Drone:IsA("Model")
        and Drone.Name:lower():find("drone") then

            if not Stored.Drones[Drone] then
                local DroneModel = Drone:FindFirstChild("Drone", true)
                local DronePart = DroneModel and DroneModel:FindFirstChild("Drone", true)
                local OwnershipTag = Drone:FindFirstChild("OwnershipTag", true)

                if DronePart and DronePart:IsA("BasePart") then
                    Stored.Drones[Drone] = {
                        Model = Drone,
                        Part = DronePart,
                        OwnerTag = OwnershipTag
                    }
                end
            end
        end
    end
end

local function CacheVehicles()
    if not Vehicles then return end
    
    for Instance, Data in pairs(Stored.Vehicles) do
        if not Data.Vehicle or not Data.Vehicle.Parent or not Data.Vehicle.PrimaryPart then
            Stored.Vehicles[Instance] = nil
        end
    end
    
    for _, Vehicle in ipairs(Vehicles:GetChildren()) do
        if Vehicle.Name ~= "DONOT" and Vehicle.ClassName == "Model" and Vehicle.PrimaryPart then
            local CurrentCache = Stored.Vehicles[Vehicle]
            local CurrentModules = Vehicle:FindFirstChild("DamageModules")
            
            if not CurrentCache or CurrentCache.DamageModules ~= CurrentModules then
                Stored.Vehicles[Vehicle] = CacheModules(Vehicle)
            end
        end
    end
end

local function Render()
    if not LocalPlayer then return end
    
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if Settings.Vehicles.Enabled then
        for Index, Data in pairs(Stored.Vehicles) do
            local Vehicle = Data.Vehicle
            local PrimaryPart = Data.PrimaryPart
        
            if Vehicle and Vehicle.Parent and PrimaryPart and PrimaryPart.Parent then
                local Team = GetTeam(Data.Engine)
            
                if not Settings.Teamcheck or (Team and LocalPlayer.Team and Team ~= LocalPlayer.Team.Name) then
                    local Screen, OnScreen = Camera:WorldToScreenPoint(PrimaryPart.Position)
                    if OnScreen then
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

                    if Settings.Vehicles.Modules.Enabled then
                        if Settings.Vehicles.Modules.Engine[1] and Data.Engine and Data.Engine.Parent then
                            Highlight.Highlight(
                                Settings.Vehicles.Modules.Engine[2], 
                                Data.Engine, {
                                Outline = false,
                                OutlineColor = Color3.fromRGB(0, 0, 0),
                                OutlineThickness = 2,
                                Inline = false,
                                InlineColor = Color3.fromRGB(0, 0, 0),
                                InlineThickness = 1,
                                Fill = true,
                                FillColor = Settings.Vehicles.Modules.Engine[2],
                                FillOpacity = 0.3
                            })
                        end

                            if Settings.Vehicles.Modules.Ammo[1] then
                            for _, AmmoObject in ipairs(Data.Ammo) do
                                if AmmoObject and AmmoObject.Parent then
                                    Highlight.Highlight(
                                        Settings.Vehicles.Modules.Ammo[2], 
                                        AmmoObject, {
                                        Outline = false,
                                        OutlineColor = Color3.fromRGB(0, 0, 0),
                                        OutlineThickness = 2,
                                        Inline = false,
                                        InlineColor = Color3.fromRGB(0, 0, 0),
                                        InlineThickness = 1,
                                        Fill = true,
                                        FillColor = Settings.Vehicles.Modules.Ammo[2],
                                        FillOpacity = 0.3
                                    })
                                end
                            end
                        end

                        if Settings.Vehicles.Modules.Drone[1] and Data.Drone and Data.Drone.Parent then
                            Highlight.Highlight(
                                Settings.Vehicles.Modules.Drone[2], 
                                Data.Drone, {
                                Outline = false,
                                OutlineColor = Color3.fromRGB(0, 0, 0),
                                OutlineThickness = 2,
                                Inline = false,
                                InlineColor = Color3.fromRGB(0, 0, 0),
                                InlineThickness = 1,
                                Fill = true,
                                FillColor = Settings.Vehicles.Modules.Drone[2],
                                FillOpacity = 0.3
                            })
                        end
                    end
                end
            end
        end

        if Settings.Drones.Enabled[1] then
            for _, Data in pairs(Stored.Drones) do
                local Part = Data.Part
                if not Part or not Part.Parent then continue end

                local Team
                if Data.OwnerTag and Data.OwnerTag:IsA("StringValue") then
                    Team = GetPlayerTeam(Data.OwnerTag.Value)
                end

                if Settings.Teamcheck and Team and LocalPlayer.Team and Team == LocalPlayer.Team.Name then
                    continue
                end

                local Screen, OnScreen = Camera:WorldToScreenPoint(Part.Position)
                if not OnScreen then continue end

                if HumanoidRootPart then
                    local Distance = vector.magnitude(HumanoidRootPart.Position - Part.Position) / 2.78125
                    Text = string.format("Drone [%.0f]", Distance)
                end

                DrawingImmediate.OutlinedText(Screen, 13, Settings.Drones.Enabled[2], 1, Text or "Drone", true, "Proggy")
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1 / 10)
        CacheVehicles()
        CacheDrones()
    end
end)

RunService.Render:Connect(Render)
