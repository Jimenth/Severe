local Added = {}

local Workspace = game:GetService("Workspace")
local Assets = Workspace:FindFirstChild("_Static")
local Characters = Assets:FindFirstChild("Characters")

local LocalPlayer = game.Players.LocalPlayer
local function RefreshLocalCharacter() return Characters:FindFirstChild(LocalPlayer.Name) end

local function GetBodyParts(Model)
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

local function PlayerData(Model, Parts)
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

local function LocalPlayerData()
    local Character = RefreshLocalCharacter()
    if not Character then return nil end

    local Parts = GetBodyParts(Character)
    if not Parts then return nil end

    local Health = Character:GetAttribute("Health") or 0
    local MaxHealth = Character:GetAttribute("MaxHealth") or 100

    local LocalData = {
        LocalPlayer = LocalPlayer,
        Character = Character,
        Username = LocalPlayer.Name,
        Displayname = LocalPlayer.DisplayName,
        Userid = 1,

        PrimaryPart = Parts.HumanoidRootPart,

        Humanoid = Parts.HumanoidRootPart,
        Health = Health,
        MaxHealth = MaxHealth,
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
        RootPart = Parts.HumanoidRootPart
    }

    return tostring(Character), LocalData
end

local function Update()
    local Seen = {}

    for _, Character in ipairs(Characters:GetChildren()) do
        if Character and Character.Name ~= LocalPlayer.Name then
            local Visual = Character:FindFirstChild("Visuals")
            
            if Visual then
                local Key = tostring(Character)
                local Parts = GetBodyParts(Character)
                local Health = Character:GetAttribute("Health") or 0

                if Parts and Parts.Head and Parts.HumanoidRootPart then
                    if not Added[Key] then
                        local ID, Data = PlayerData(Character, Parts)
                        if ID and Data and add_model_data(Data, ID) then
                            Added[ID] = Character
                        end
                    else
                        edit_model_data({Health = Health}, Key)
                    end
                    
                    Seen[Key] = true
                end
            end
        end
    end

    for Key, Model in pairs(Added) do
        if not Seen[Key] or not Model or not Model.Parent then
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
