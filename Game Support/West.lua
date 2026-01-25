local Added = {}
local Workspace = game:GetService("Workspace")
local Entities = Workspace:FindFirstChild("WORKSPACE_Entities")
local Players = Entities:FindFirstChild("Players")

local LocalPlayer = game.Players.LocalPlayer

local function RefreshLocalCharacter()
    return Players:FindFirstChild(LocalPlayer.Name)
end

local function GetBodyParts(Model)
    return {
        Head = Model:FindFirstChild("Head"),
        UpperTorso = Model:FindFirstChild("UpperTorso"),
        LowerTorso = Model:FindFirstChild("LowerTorso"),

        LeftUpperArm = Model:FindFirstChild("LeftUpperArm"),
        LeftLowerArm = Model:FindFirstChild("LeftLowerArm"),
        LeftHand = Model:FindFirstChild("LeftHand"),

        RightUpperArm = Model:FindFirstChild("RightUpperArm"),
        RightLowerArm = Model:FindFirstChild("RightLowerArm"),
        RightHand = Model:FindFirstChild("RightHand"),

        LeftUpperLeg = Model:FindFirstChild("LeftUpperLeg"),
        LeftLowerLeg = Model:FindFirstChild("LeftLowerLeg"),
        LeftFoot = Model:FindFirstChild("LeftFoot"),

        RightUpperLeg = Model:FindFirstChild("RightUpperLeg"),
        RightLowerLeg = Model:FindFirstChild("RightLowerLeg"),
        RightFoot = Model:FindFirstChild("RightFoot"),

        LeftLeg = Model:FindFirstChild("Left Leg"),
        RightLeg = Model:FindFirstChild("Right Leg"),
        LeftArm = Model:FindFirstChild("Left Arm"),
        RightArm = Model:FindFirstChild("Right Arm"),
        Torso = Model:FindFirstChild("Torso"),

        HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart"),
    }
end

local function PlayerData(Model, Parts)
    local Humanoid = Model:FindFirstChild("Humanoid")
    local Health = Humanoid and Humanoid.Health or 0

    local Data = {
        Username = tostring(Model),
        Displayname = Model.Name,
        Userid = 3,
        Character = Model,
        PrimaryPart = Model.PrimaryPart,
        Humanoid = Humanoid,
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
        Teamname = "Players",
        Toolname = "Unknown",
        Whitelisted = false,
        Archenemies = false,
        Aimbot_Part = Parts.Head,
        Aimbot_TP_Part = Parts.Head,
        Triggerbot_Part = Parts.Head,
        Health = Health,
        MaxHealth = Humanoid and Humanoid.MaxHealth or 0,
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

local function LocalPlayerData()
    local LocalCharacter = RefreshLocalCharacter()
    if not LocalCharacter then
        return nil
    end

    local Humanoid = LocalCharacter:FindFirstChild("Humanoid")
    if not Humanoid then
        return nil
    end

    local Health = Humanoid.Health

    local LocalData = {
        LocalPlayer = LocalPlayer,
        Character = LocalCharacter,
        Username = tostring(LocalPlayer),
        Displayname = LocalPlayer.Name,
        Userid = 1,

        Humanoid = Humanoid,
        Health = Health,
        MaxHealth = Humanoid.MaxHealth,
        RigType = 1,
        Teamname = "Players",
        Toolname = "Unknown",

        Head = LocalCharacter:FindFirstChild("Head"),
        RootPart = LocalCharacter:FindFirstChild("HumanoidRootPart"),
        LeftFoot = LocalCharacter:FindFirstChild("LeftFoot"),
        LowerTorso = LocalCharacter:FindFirstChild("LowerTorso"),

        LeftArm = LocalCharacter:FindFirstChild("LeftUpperArm"),
        LeftLeg = LocalCharacter:FindFirstChild("LeftUpperLeg"),
        RightArm = LocalCharacter:FindFirstChild("RightUpperArm"),
        RightLeg = LocalCharacter:FindFirstChild("RightUpperLeg"),
        UpperTorso = LocalCharacter:FindFirstChild("UpperTorso"),
    }

    return tostring(LocalCharacter), LocalData
end

local function Update()
    local Seen = {}

    for _, Player in ipairs(Players:GetChildren()) do
        local Humanoid = Player:FindFirstChild("Humanoid")
        if Humanoid and Player.Parent then
            local Key = tostring(Player)
            local Parts = GetBodyParts(Player)

            if Parts.Head and Parts.HumanoidRootPart and Player.Name ~= LocalPlayer.Name then
                if not Added[Key] then
                    local ID, Data = PlayerData(Player, Parts)
                    if add_model_data(Data, ID) then
                        Added[ID] = Player
                    end
                else
                    edit_model_data({Health = Humanoid.Health}, Key)
                end
                Seen[Key] = true
            end
        end
    end

    for Key, Model in pairs(Added) do
        local HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart or not Seen[Key] then
            remove_model_data(Key)
            Added[Key] = nil
        end
    end
end

RunService.PostLocal:Connect(function()
    Update()

    local LocalID, LocalData = LocalPlayerData()
    if LocalID and LocalData then
        override_local_data(LocalData)
    end
end)
