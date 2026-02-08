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

local function GetVehicleTeam(Vehicle)
    if not Vehicle then return nil end

    local OwnerName = Vehicle:GetAttribute("Requester")
    if typeof(OwnerName) ~= "string" then
        return nil
    end

    return GetPlayerTeam(OwnerName)
end

local function CacheVehicles()
    if not Vehicles then return end

    for Vehicle, Data in pairs(Stored.Vehicles) do
        if not Vehicle.Parent then
            Stored.Vehicles[Vehicle] = nil
            print("Removed: ".. Vehicle.Name)
        end
    end
    
    for _, Vehicle in ipairs(Vehicles:GetChildren()) do
        if Vehicle.Name ~= "DONOT" and Vehicle.ClassName == "Model" and Vehicle.PrimaryPart then
            if not Stored.Vehicles[Vehicle] then
                local DamageModules = Vehicle:FindFirstChild("DamageModules")
                
                Stored.Vehicles[Vehicle] = {
                    Vehicle = Vehicle,
                    PrimaryPart = Vehicle.PrimaryPart,
                    DamageModules = DamageModules,
                    CachedAt = tick(),
                    ModulesCached = false,
                    Engine = nil,
                    Ammo = {}
                }
                
                task.delay(1, function()
                    local Data = Stored.Vehicles[Vehicle]
                    if not Data or Data.ModulesCached then return end
                    
                    if DamageModules and DamageModules.Parent then
                        for _, Module in ipairs(DamageModules:GetChildren()) do
                            if not (Module:IsA("Model") or Module:IsA("Folder")) then
                                continue
                            end
                            
                            local Name = Module.Name:lower()
                            
                            if Name == "engine" then
                                local EnginePart = Module:FindFirstChild("Engine")
                                if EnginePart then
                                    Data.Engine = EnginePart
                                end
                            end
                            
                            if Name:find("ammo") or Name:find("atgm") then
                                table.insert(Data.Ammo, Module)
                            end
                        end
                        
                        Data.ModulesCached = true
                    end
                end)
            end
        end
    end
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

local function Render()
    if not LocalPlayer then return end
    
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if Settings.Vehicles.Enabled then
        for Index, Data in pairs(Stored.Vehicles) do
            local Vehicle = Data.Vehicle
            local PrimaryPart = Data.PrimaryPart
        
            if Vehicle and Vehicle.Parent and PrimaryPart and PrimaryPart.Parent then
                local Team = GetVehicleTeam(Vehicle)
            
                if not Settings.Teamcheck or (Team and LocalPlayer.Team and Team ~= LocalPlayer.Team.Name) then
                    local Screen, OnScreen = Camera:WorldToScreenPoint(PrimaryPart.Position)
                    if OnScreen then
                        if Settings.Vehicles.Occupied.Require and Vehicle:GetAttribute("Occupied") ~= "true" then
                            continue
                        end

                        local Text = Vehicle.Name

                        if HumanoidRootPart then
                            local Distance = vector.magnitude(HumanoidRootPart.Position - PrimaryPart.Position)
                            local ScaledDistance = Distance / 2.78125

                            Text = string.format("%s [%.0f]", Vehicle.Name, ScaledDistance)
                        end

                        local Color = Vehicle:GetAttribute("Occupied") == "true" and Settings.Vehicles.Occupied.Color or Color3.fromRGB(255, 255, 255)

                        DrawingImmediate.OutlinedText(Screen, 13, Color, 1, Text, true, "Proggy")
                    end

                    if Settings.Vehicles.Modules.Enabled and Data.ModulesCached then
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
                        
                        if Settings.Vehicles.Modules.Ammo[1] and Data.Ammo then
                            for i = #Data.Ammo, 1, -1 do
                                local AmmoModule = Data.Ammo[i]
                                if not AmmoModule or not AmmoModule.Parent then
                                    table.remove(Data.Ammo, i)
                                else
                                    Highlight.Highlight(
                                        Settings.Vehicles.Modules.Ammo[2], 
                                        AmmoModule, {
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

                local Text = "Drone"
                if HumanoidRootPart then
                    local Distance = vector.magnitude(HumanoidRootPart.Position - Part.Position) / 2.78125
                    Text = string.format("Drone [%.0f]", Distance)
                end

                DrawingImmediate.OutlinedText(Screen, 13, Settings.Drones.Enabled[2], 1, Text, true, "Proggy")
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1 / 2)
        CacheVehicles()
        CacheDrones()
    end
end)

RunService.Render:Connect(Render)
