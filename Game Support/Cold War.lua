local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Module = {
    Function = {},

    Game = {
        Characters = Workspace:FindFirstChild("Characters")
    },

    Stored = {

    },

    Added = {

    }
}

function Module.Function:GetPlayerInstance(Character)
    if not Character then return nil end

    return Players:FindFirstChild(Character.Name)
end

function Module.Function:GetHealth(Character)
    if not Character then return 0, 0 end

    local Health = 0
    local MaxHealth = 0

    for _, BodyPart in ipairs({"Head", "Torso"}) do
        local Part = Character:FindFirstChild(BodyPart)

        if Part then
            local HealthValue = Part:FindFirstChild("Health")

            if HealthValue and HealthValue:IsA("NumberValue") then
                if HealthValue.Value <= 0 then
                    return 0, MaxHealth
                end

                Health += HealthValue.Value
                MaxHealth += HealthValue:GetAttribute("MaxHealth") or 0
            end
        end
    end

    return Health, MaxHealth
end

function Module.Function.Cache()
    for Identifier, Entry in Module.Stored do
        if not Entry or not Entry.Parent then
            Module.Stored[Identifier] = nil
        end
    end

    for _, Character in Module.Game.Characters:GetChildren() do
        local Identifier = tostring(Character)

        if not Module.Stored[Identifier] then
            Module.Stored[Identifier] = Character
        end
    end
end

function Module.Function:GetBodyData(Character)
    if not Character then return nil end

    return {
		Head = Character:FindFirstChild("Head"),
		
		LeftLeg = Character:FindFirstChild("Left Leg"),
		RightLeg = Character:FindFirstChild("Right Leg"),
		LeftArm = Character:FindFirstChild("Left Arm"),
		RightArm = Character:FindFirstChild("Right Arm"),
		Torso = Character:FindFirstChild("Torso"),
		
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart"),
	}
end

function Module.Function:CharacterData(Character, Parts)
    if not Character then return nil end

    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if not Humanoid then return nil end

    local Health, MaxHealth = Module.Function:GetHealth(Character)

    local Player = Module.Function:GetPlayerInstance(Character)
    if not Player then return nil end

    local Data = {
        Username = Player.Name,
        Displayname = Player.DisplayName,
        Userid = Player.UserId,
        Character = Character,
        PrimaryPart = Parts.HumanoidRootPart,
        Humanoid = Humanoid,
        Head = Parts.Head,
        Torso = Parts.Torso,
        LeftArm = Parts.LeftArm or Parts.HumanoidRootPart,
        LeftLeg = Parts.LeftLeg or Parts.HumanoidRootPart,
        RightArm = Parts.RightArm or Parts.HumanoidRootPart,
        RightLeg = Parts.RightLeg or Parts.HumanoidRootPart,
        BodyHeightScale = 1,
        RigType = 0,
        Teamname = Player.Team.Name,
        Toolname = "Unknown",
        Whitelisted = false,
        Archenemies = false,
        Aimbot_Part = Parts.Head,
        Aimbot_TP_Part = Parts.Head,
        Triggerbot_Part = Parts.Head,
        Health = Health,
        MaxHealth = MaxHealth,
        body_parts_data = {
            { name = "LowerTorso", part = Parts.Torso },
            { name = "LeftUpperLeg", part = Parts.LeftLeg },
            { name = "LeftLowerLeg", part = Parts.LeftLeg },
            { name = "RightUpperLeg", part = Parts.RightLeg },
            { name = "RightLowerLeg", part = Parts.RightLeg },
            { name = "LeftUpperArm", part = Parts.LeftArm },
            { name = "LeftLowerArm", part = Parts.LeftArm },
            { name = "RightUpperArm", part = Parts.RightArm },
            { name = "RightLowerArm", part = Parts.RightArm },
        },
        full_body_data = {
            { name = "Head", part = Parts.Head },
            { name = "UpperTorso", part = Parts.Torso },
            { name = "LowerTorso", part = Parts.Torso },
            { name = "HumanoidRootPart", part = Parts.HumanoidRootPart },
            { name = "LeftUpperArm", part = Parts.LeftArm },
            { name = "LeftLowerArm", part = Parts.LeftArm },
            { name = "LeftHand", part = Parts.LeftArm },
            { name = "RightUpperArm", part = Parts.RightArm },
            { name = "RightLowerArm", part = Parts.RightArm },
            { name = "RightHand", part = Parts.RightArm },
            { name = "LeftUpperLeg", part = Parts.LeftLeg },
            { name = "LeftLowerLeg", part = Parts.LeftLeg },
            { name = "LeftFoot", part = Parts.LeftLeg },
            { name = "RightUpperLeg", part = Parts.RightLeg },
            { name = "RightLowerLeg", part = Parts.RightLeg },
            { name = "RightFoot", part = Parts.RightLeg },
        }
    }

    return tostring(Character), Data
end

function Module.Function:UpdateLocalData()
    local Character = Module.Game.Characters:FindFirstChild(LocalPlayer.Name)
    if not Character then return end

    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end

    local Health, MaxHealth = Module.Function:GetHealth(Character)

    local Player = Module.Function:GetPlayerInstance(Character)
    if not Player then return nil end

    local Parts = Module.Function:GetBodyData(Character)

    local Data = {
        LocalPlayer = LocalPlayer,
        Character = Character,
        Username = Player.Name,
        Displayname = Player.DisplayName,
        Userid = Player.UserId,
        Humanoid = Humanoid,
        Health = Health,
        MaxHealth = MaxHealth,
        RigType = 0,
        Teamname = Player.Team.Name,
        Toolname = "Unknown",

        Head = Parts.Head,
        RootPart = Parts.HumanoidRootPart,
        LeftFoot = Parts.LeftLeg or Parts.HumanoidRootPart,
        LowerTorso = Parts.Torso,
        LeftArm = Parts.LeftArm or Parts.HumanoidRootPart,
        LeftLeg = Parts.LeftLeg or Parts.HumanoidRootPart,
        RightArm = Parts.RightArm or Parts.HumanoidRootPart,
        RightLeg = Parts.RightLeg or Parts.HumanoidRootPart,
        UpperTorso = Parts.Torso,
    }

    override_local_data(Data)
end

function Module.Function:Update()
    local Seen = {}

    for _, Player in Module.Stored do
        local Humanoid = Player:FindFirstChild("Humanoid")
        if Humanoid and Player.Parent then
            local Key = tostring(Player)
            local Parts = Module.Function:GetBodyData(Player)

            local Health, MaxHealth = Module.Function:GetHealth(Player)

            local PlayerInstance = Module.Function:GetPlayerInstance(Player)
            if is_team_check_active() and PlayerInstance and PlayerInstance.Team == LocalPlayer.Team then
                continue
            end

            if not Parts or not Parts.Head or not Parts.HumanoidRootPart then
                continue
            end

            if Parts.Head and Parts.HumanoidRootPart and Player.Name ~= LocalPlayer.Name then
                if not Module.Added[Key] then
                    local Success, ID, Data = pcall(function()
                        return Module.Function:CharacterData(Player, Parts)
                    end)

                    if Success and ID and Data then
                        add_model_data(Data, ID)
                        Module.Added[ID] = Player
                    end
                else
                    edit_model_data({ Health = Health }, Key)
                end

                Seen[Key] = true
            end
        end
    end

    for Key, Model in pairs(Module.Added) do
        local HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart or not Seen[Key] then
            remove_model_data(Key)
            Module.Added[Key] = nil
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        Module.Function:Cache()
    end
end)

RunService.PostLocal:Connect(function()
    Module.Function:Update()
    Module.Function:UpdateLocalData()
end)
