--!optimize 2
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/Severe/refs/heads/main/Epstein%20Highlighter.lua"))();
task.wait(1)

local Vehicles = game:GetService("Workspace"):FindFirstChild("Vehicles")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CurrentCamera = workspace.CurrentCamera

RunService.Render:Connect(function()
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end

    for _, Tank in ipairs(Vehicles:GetChildren()) do
        if Tank and Tank.Name ~= "Chassis" .. LocalPlayer.Name then

            local PrimaryNode = Tank:FindFirstChild("HullNode")
            if not PrimaryNode then continue end

            local RealName = string.sub(Tank.Name, 8)
            local Player = Players:FindFirstChild(RealName)
            if not Player then continue end

            if Player and Player.Team == LocalPlayer.Team then continue end

            local DisplayName = Player.DisplayName or Player.Name

            local Hull = Tank:FindFirstChild("Hull")
            local HullObject = Hull and Hull:FindFirstChildOfClass("Model") and Hull:FindFirstChildOfClass("Model"):FindFirstChild("Hull")

            local HullName = Hull and Hull:FindFirstChildOfClass("Model") and Hull:FindFirstChildOfClass("Model").Name

            local Turret = Tank:FindFirstChild("Turret")
            local TurretObject = Turret and Turret:FindFirstChildOfClass("Model") and Turret:FindFirstChildOfClass("Model"):FindFirstChild("Turret")
            local Container = nil

            if HullObject then
                for _, Child in ipairs(HullObject:GetChildren()) do
                    if Child.ClassName == "MeshPart" and Child.Name == "Ammunition" then
                        Container = HullObject
                        break
                    end
                end
            end

            if not Container and TurretObject then
                for _, Child in ipairs(TurretObject:GetChildren()) do
                    if Child.ClassName == "MeshPart" and Child.Name == "Ammunition" then
                        Container = TurretObject
                        break
                    end
                end
            end

            if Container then
                for _, AmmoPart in ipairs(Container:GetChildren()) do
                    if AmmoPart.ClassName == "MeshPart" and AmmoPart.Name == "Ammunition" then
                        Module.Highlight(
                            Color3.fromRGB(255, 255, 255), 
                            AmmoPart, {
                            Outline = true,
                            OutlineColor = Color3.fromRGB(0, 0, 0),
                            OutlineThickness = 1,
                            Inline = true,
                            InlineColor = Color3.fromRGB(0, 0, 0),
                            InlineThickness = 1,
                            Fill = true,
                            FillColor = Color3.fromRGB(255, 255, 255),
                            FillOpacity = 0.4
                        })
                    end
                end
            end

            local Screen, OnScreen = CurrentCamera:WorldToScreenPoint(PrimaryNode.Position)
            if OnScreen then
                DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, DisplayName .. "'s " .. HullName, true, "Proggy")
            end
        end
    end
end)
