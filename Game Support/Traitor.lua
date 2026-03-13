--!optimize 2
local Module = {
    Functions = {},
    Added = {},
}

local Workspace = game:GetService("Workspace")
local Assets = Workspace:FindFirstChild("_Static")
local Characters = Assets:FindFirstChild("Characters")
local LocalPlayer = game.Players.LocalPlayer

Module.Functions.RefreshLocalCharacter = function()
    return Characters:FindFirstChild(LocalPlayer.Name)
end

Module.Functions.GetBodyParts = function(Model)
    if not Model then return nil end

    local Visual = Model:FindFirstChild("Visuals")
    if not Visual then return nil end

    return {
        Head = Visual:FindFirstChild("Head"),
        UpperTorso = Visual:FindFirstChild("UpperTorso"),
        LowerTorso = Visual:FindFirstChild("LowerTorso"),

        LeftUpperArm = Visual:FindFirstChild("LeftUpperArm"),
        LeftLowerArm = Visual:FindFirstChild("LeftLowerArm"),
        LeftHand = Visual:FindFirstChild("LeftHand"),

        RightUpperArm = Visual:FindFirstChild("RightUpperArm"),
        RightLowerArm = Visual:FindFirstChild("RightLowerArm"),
        RightHand = Visual:FindFirstChild("RightHand"),

        LeftUpperLeg = Visual:FindFirstChild("LeftUpperLeg"),
        LeftLowerLeg = Visual:FindFirstChild("LeftLowerLeg"),
        LeftFoot = Visual:FindFirstChild("LeftFoot"),

        RightUpperLeg = Visual:FindFirstChild("RightUpperLeg"),
        RightLowerLeg = Visual:FindFirstChild("RightLowerLeg"),
        RightFoot = Visual:FindFirstChild("RightFoot"),

        HumanoidRootPart = Visual:FindFirstChild("HumanoidRootPart"),
    }
end

Module.Functions.PlayerData = function(Model, Parts)
    local Health = Model:GetAttribute("Health") or 0
    local MaxHealth = Model:GetAttribute("MaxHealth") or 100

    local Data = {
        Username = tostring(Model),
        Displayname = Model.Name,
        Userid = Model:GetAttribute("UserId"),
        Character = Model,
        PrimaryPart = Model.PrimaryPart,
        Humanoid = Model.PrimaryPart,
        Head = Parts.Head,
        Torso = Parts.UpperTorso,
        UpperTorso = Parts.UpperTorso,
        LowerTorso = Parts.LowerTorso,
        LeftArm = Parts.LeftUpperArm,
        LeftLeg = Parts.LeftUpperLeg,
        RightArm = Parts.RightUpperArm,
        RightLeg = Parts.RightUpperLeg,
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
        Teamname = "Players",
        Toolname = "Unknown",
        Whitelisted = false,
        Archenemies = false,
        Aimbot_Part = Parts.Head,
        Aimbot_TP_Part = Parts.Head,
        Triggerbot_Part = Parts.Head,
        Health = Health,
        MaxHealth = MaxHealth,
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
    local Character = Module.Functions.RefreshLocalCharacter()
    if not Character then return end

    local Parts = Module.Functions.GetBodyParts(Character)
    if not Parts then return end

    local Data = {
        LocalPlayer = LocalPlayer,
        Character = Character,
        Username = LocalPlayer.Name,
        Displayname = LocalPlayer.DisplayName,
        Userid = 1,
        PrimaryPart = Parts.HumanoidRootPart,
        Humanoid = Parts.HumanoidRootPart,
        Health = Character:GetAttribute("Health") or 0,
        MaxHealth = Character:GetAttribute("MaxHealth") or 100,
        RigType = 1,
        Teamname = "Players",
        Toolname = "Unknown",
        Head = Parts.Head,
        Torso = Parts.UpperTorso,
        UpperTorso = Parts.UpperTorso,
        LowerTorso = Parts.LowerTorso,
        LeftArm = Parts.LeftUpperArm,
        LeftLeg = Parts.LeftUpperLeg,
        RightArm = Parts.RightUpperArm,
        RightLeg = Parts.RightUpperLeg,
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
        RootPart = Parts.HumanoidRootPart,
    }

    override_local_data(Data)
end

Module.Functions.Update = function()
    local Seen = {}

    for _, Character in ipairs(Characters:GetChildren()) do
        pcall(function()
            if not Character or Character.Name == LocalPlayer.Name then return end

            local Visual = Character:FindFirstChild("Visuals")
            if not Visual then return end

            local Key = tostring(Character)
            local Parts = Module.Functions.GetBodyParts(Character)
            local Health = Character:GetAttribute("Health") or 0

            if Parts and Parts.Head and Parts.HumanoidRootPart then
                if not Module.Added[Key] then
                    local Success, ID, Data = pcall(function()
                        return Module.Functions.PlayerData(Character, Parts)
                    end)

                    if Success and ID and Data then
                        local Success2, Result = pcall(function()
                            return add_model_data(Data, ID)
                        end)

                        if Success2 and Result then
                            Module.Added[ID] = Character
                        end
                    end
                else
                    pcall(function()
                        edit_model_data({ Health = Health }, Key)
                    end)
                end

                Seen[Key] = true
            end
        end)
    end

    for Key, Model in pairs(Module.Added) do
        pcall(function()
            if not Seen[Key] or not Model or not Model.Parent then
                remove_model_data(Key)
                Module.Added[Key] = nil
            end
        end)
    end
end

RunService.PostLocal:Connect(function()
    Module.Functions.Update()
    Module.Functions.LocalPlayerData()
end)
