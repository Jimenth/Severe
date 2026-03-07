--!optimize 2
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/Severe/refs/heads/main/Modules/Highlight.lua"))()
task.wait(1)

local Workspace = game:GetService("Workspace")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local Vehicles = Workspace:FindFirstChild("Vehicles")
local Camera = Workspace.CurrentCamera

local function GetAmmo(Object)
    if not Object then return nil end

    local Parts = {}
    for _, Child in ipairs(Object:GetChildren()) do
        if Child.ClassName == "MeshPart" and Child.Name == "Ammunition" then
            Parts[#Parts + 1] = Child
        end
    end

    return #Parts > 0 and Parts or nil
end

RunService.Render:Connect(function()
    if not Players.LocalPlayer or not Vehicles then return end

    for _, Tank in ipairs(Vehicles:GetChildren()) do
        if Tank.Name == "Chassis" .. Players.LocalPlayer.Name then continue end

        local PrimaryNode = Tank:FindFirstChild("HullNode")
        if not PrimaryNode then continue end

        local Player = Players:FindFirstChild(string.sub(Tank.Name, 8))
        if not Player then continue end

        if Player.Team == Players.LocalPlayer.Team then continue end

        local Hull = Tank:FindFirstChild("Hull")
        local HullModel = Hull and Hull:FindFirstChildOfClass("Model")
        local HullObject = HullModel and HullModel:FindFirstChild("Hull")
        local HullAmmo = GetAmmo(HullObject)

        local Turret = Tank:FindFirstChild("Turret")
        local TurretModel = Turret and Turret:FindFirstChildOfClass("Model")
        local TurretObject = TurretModel and TurretModel:FindFirstChild("Turret")
        local TurretAmmo = GetAmmo(TurretObject)

        if HullAmmo then
            Module.Highlight(Color3.fromRGB(255, 255, 255), HullAmmo, {Outline = false, Inline = false, Fill = true, FillColor = Color3.fromRGB(255, 255, 255), FillOpacity = 0.4})
        end

        if TurretAmmo then
            Module.Highlight(Color3.fromRGB(255, 255, 255), TurretAmmo, {Outline = false, Inline = false, Fill = true, FillColor = Color3.fromRGB(255, 255, 255), FillOpacity = 0.4})
        end

        local Screen, OnScreen = Camera:WorldToScreenPoint(PrimaryNode.Position)
        if OnScreen and HullModel then
            DrawingImmediate.OutlinedText(Screen, 12, Color3.fromRGB(255, 255, 255), 1, Player.DisplayName .. "'s " .. HullModel.Name, true, "Proxyma_Condensed")
        end
    end
end)
