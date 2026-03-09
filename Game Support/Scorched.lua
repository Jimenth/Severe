--!optimize 2
local Module = {
    Functions = {},
    Added = {},

    LocalPlayer = {
        Closest = nil,
    }
}

local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera

math.randomseed(os.time())

Module.Functions.GetPlayers = function()
    local Folders = {}
    for _, Folder in ipairs(Workspace:GetChildren()) do
        if Folder:IsA("Folder") then Folders[#Folders+1] = Folder end
    end

    local Fourth = Folders[4]
    if Fourth then
        for _, Child in ipairs(Fourth:GetChildren()) do
            if Child.Name ~= "Model" then
                return Folders[3]
            end
        end
        return Fourth
    end

    return Folders[3]
end

Module.Functions.GetSelf = function()
    local Players = Module.Functions.GetPlayers()
    if not Players then return nil end

    local Closest = nil
    local ShortestDistance = math.huge

    for _, Player in ipairs(Players:GetChildren()) do
        if Player:IsA("Model") and Player.Name == "Model" then
            local Head = Player:FindFirstChild("head")
            if Head then
                if #Head:GetChildren() <= 1 then
                    local Distance = vector.magnitude(Head.Position - Camera.Position)
                    if Distance < ShortestDistance then
                        ShortestDistance = Distance
                        Closest = Player
                    end
                end
            end
        end
    end

    return Closest
end

Module.Functions.GetBodyParts = function(Model)
    return {
        Head = Model:FindFirstChild("head"),
        UpperTorso = Model:FindFirstChild("torso"),
        LowerTorso = Model:FindFirstChild("stomach"),
        LeftUpperArm = Model:FindFirstChild("lArmUpper"),
        LeftLowerArm = Model:FindFirstChild("lArmLower"),
        LeftHand = Model:FindFirstChild("lHand"),
        RightUpperArm = Model:FindFirstChild("rArmUpper"),
        RightLowerArm = Model:FindFirstChild("rArmLower"),
        RightHand = Model:FindFirstChild("rArmLower"),
        LeftUpperLeg = Model:FindFirstChild("lLegUpper"),
        LeftLowerLeg = Model:FindFirstChild("lLegLower"),
        LeftFoot = Model:FindFirstChild("lLegLower"),
        RightUpperLeg = Model:FindFirstChild("rLegUpper"),
        RightLowerLeg = Model:FindFirstChild("rLegLower"),
        RightFoot = Model:FindFirstChild("rFoot"),
        HumanoidRootPart = Model:FindFirstChild("root"),
    }
end

Module.Functions.PlayerData = function(Model, Parts)
    local Data = {
        Username = tostring(Model),
        Displayname = Model.Name,
        Userid = math.random(1000000, 10000000),
        Character = Model,
        PrimaryPart = Model.PrimaryPart,
        Humanoid = Parts.HumanoidRootPart,
        Head = Parts.Head,
        Torso = Parts.Torso or Parts.UpperTorso,
        UpperTorso = Parts.UpperTorso,
        LowerTorso = Parts.LowerTorso,
        LeftArm = Parts.LeftArm or Parts.LeftUpperArm,
        LeftLeg = Parts.LeftLeg or Parts.LeftUpperLeg,
        RightArm = Parts.RightArm or Parts.RightUpperArm,
        RightLeg = Parts.RightLeg or Parts.RightUpperLeg,
        LeftUpperArm = Parts.LeftUpperArm,
        LeftLowerArm = Parts.LeftLowerArm,
        LeftHand = Parts.LeftHand,
        RightUpperArm = Parts.RightUpperArm,
        RightLowerArm = Parts.RightLowerArm,
        RightHand = Parts.RightHand,
        LeftUpperLeg = Parts.LeftUpperLeg,
        LeftLowerLeg = Parts.LeftLowerLeg,
        LeftFoot = Parts.LeftFoot,
        RightUpperLeg = Parts.RightUpperLeg,
        RightLowerLeg = Parts.RightLowerLeg,
        RightFoot = Parts.RightFoot,
        BodyHeightScale = 1,
        RigType = 1,
        Teamname = "Unknown",
        Toolname = "Unknown",
        Whitelisted = false,
        Archenemies = false,
        Aimbot_Part = Parts.Head,
        Aimbot_TP_Part = Parts.Head,
        Triggerbot_Part = Parts.Head,
        Health = 100,
        MaxHealth = 100,
        body_parts_data = {
            { name = "LowerTorso", part = Parts.LowerTorso },
            { name = "LeftUpperLeg", part = Parts.LeftUpperLeg },
            { name = "LeftLowerLeg", part = Parts.LeftLowerLeg },
            { name = "RightUpperLeg", part = Parts.RightUpperLeg },
            { name = "RightLowerLeg", part = Parts.RightLowerLeg },
            { name = "LeftUpperArm", part = Parts.LeftUpperArm },
            { name = "LeftLowerArm", part = Parts.LeftLowerArm },
            { name = "RightUpperArm", part = Parts.RightUpperArm },
            { name = "RightLowerArm", part = Parts.RightLowerArm },
        },
        full_body_data = {
            { name = "Head", part = Parts.Head },
            { name = "UpperTorso", part = Parts.UpperTorso },
            { name = "LowerTorso", part = Parts.LowerTorso },
            { name = "HumanoidRootPart", part = Parts.HumanoidRootPart },
            { name = "LeftUpperArm", part = Parts.LeftUpperArm },
            { name = "LeftLowerArm", part = Parts.LeftLowerArm },
            { name = "LeftHand", part = Parts.LeftHand },
            { name = "RightUpperArm", part = Parts.RightUpperArm },
            { name = "RightLowerArm", part = Parts.RightLowerArm },
            { name = "RightHand", part = Parts.RightHand },
            { name = "LeftUpperLeg", part = Parts.LeftUpperLeg },
            { name = "LeftLowerLeg", part = Parts.LeftLowerLeg },
            { name = "LeftFoot", part = Parts.LeftFoot },
            { name = "RightUpperLeg", part = Parts.RightUpperLeg },
            { name = "RightLowerLeg", part = Parts.RightLowerLeg },
            { name = "RightFoot", part = Parts.RightFoot },
        }
    }

    return tostring(Model), Data
end

Module.Functions.LocalPlayerData = function()
    local LocalPlayer = Module.LocalPlayer.Closest
    if not LocalPlayer then return nil, nil end

    local Parts = Module.Functions.GetBodyParts(LocalPlayer)
    if not Parts.Head then return nil, nil end

    local Data = {
        LocalPlayer = LocalPlayer,
        Character = LocalPlayer,
        Username = tostring(LocalPlayer),
        Displayname = LocalPlayer.Name,
        Userid = 1,
        Toolname = "Unknown",
        Teamname = "Unknown",

        Humanoid = Parts.HumanoidRootPart,
        Health = 100,
        MaxHealth = 100,
        RigType = 1,

        Head = Parts.Head,
        RootPart = Parts.HumanoidRootPart,
        LeftFoot = Parts.LeftFoot,
        LowerTorso = Parts.LowerTorso,
        LeftArm = Parts.LeftUpperArm,
        LeftLeg = Parts.LeftUpperLeg,
        RightArm = Parts.RightUpperArm,
        RightLeg = Parts.RightUpperLeg,
        UpperTorso = Parts.UpperTorso,
    }

    return tostring(LocalPlayer), Data
end

Module.Functions.Update = function()
    local Players = Module.Functions.GetPlayers()
    if not Players then return end

    local Seen = {}

    for _, Player in ipairs(Players:GetChildren()) do
        if Player:IsA("Model") and Player.Name == "Model" and Player ~= Module.LocalPlayer.Closest then
            local Key = tostring(Player)
            local Torso = Player:FindFirstChild("torso")

            if Torso and Torso:FindFirstChild("tag") and is_team_check_active() then
                continue
            end

            local Parts = Module.Functions.GetBodyParts(Player)
            if Parts.Head and Parts.HumanoidRootPart then
                if not Module.Added[Key] then
                    local ID, Data = Module.Functions.PlayerData(Player, Parts)
                    if add_model_data(Data, ID) then
                        Module.Added[ID] = Player
                    end
                end
                Seen[Key] = true
            end
        end
    end

    for Key, Model in pairs(Module.Added) do
        local HumanoidRootPart = Model:FindFirstChild("root")
        if not HumanoidRootPart or not Seen[Key] then
            remove_model_data(Key)
            Module.Added[Key] = nil
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        Module.LocalPlayer.Closest = Module.Functions.GetSelf()
    end
end)

RunService.PostLocal:Connect(function()
    Module.Functions.Update()

    local ID, Data = Module.Functions.LocalPlayerData()
    if ID and Data then override_local_data(Data) end
end)
