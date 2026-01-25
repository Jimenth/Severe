local Module = {
	Functions = {},
	Added = {},
}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local GameStorage = {
	Characters = Workspace:FindFirstChild("characters")
}

local function GetLocalModel()
	if not GameStorage.Characters then return nil end

    LocalPlayer = GameStorage.Characters:FindFirstChild("StarterCharacter")
    return LocalPlayer
end

function Module.Functions.TeamCheck(Entity)
	if not GameStorage.Characters then return nil end
	if not Players.LocalPlayer then return nil end

	local LocalPlayer = GameStorage.Characters and GameStorage.Characters:FindFirstChild("StarterCharacter")

	if not LocalPlayer then return nil end

	local Object = Entity:FindFirstChild("head")
	Object = Object and Object:FindFirstChild("head")
	Object = Object and Object:FindFirstChild("item")

	local LocalObject = LocalPlayer:FindFirstChild("head")
	LocalObject = LocalObject and LocalObject:FindFirstChild("head")
	LocalObject = LocalObject and LocalObject:FindFirstChild("item")

	if Object and LocalObject then return Object.ClassName == LocalObject.ClassName end

	return false
end

function Module.Functions.GetBodyParts(Model)
	return {
		Head = Model:FindFirstChild("head"),
		LeftArm = Model:FindFirstChild("left_arm_vis"),
		RightArm = Model:FindFirstChild("right_arm_vis"),
		RightLeg = Model:FindFirstChild("right_leg_vis"),
		LeftLeg = Model:FindFirstChild("left_leg_vis"),
		Torso = Model:FindFirstChild("torso"),
		HumanoidRootPart = Model:FindFirstChild("humanoid_root_part")
	}
end

function Module.Functions.PlayerData(Model, Parts)
	local Data = {
		Username = tostring(Model),
		Displayname = "Player",
		Userid = 0,
		Character = Model,
		PrimaryPart = Model.PrimaryPart,
		Humanoid = Parts.HumanoidRootPart,
		Head = Parts.Head,
        Torso = Parts.Torso,
        LeftArm = Parts.LeftArm, 
        LeftLeg = Parts.LeftLeg, 
        RightArm = Parts.RightArm, 
        RightLeg = Parts.RightLeg, 
		BodyHeightScale = 1,
		RigType = 0,
		Whitelisted = false,
		Archenemies = false,
		Teamname = Module.Functions.TeamCheck(Model) and "Friendly" or "Enemy",
		Toolname = "Unknown",
		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,
		Health = 100,
		MaxHealth = 100,
	}

	return tostring(Model), Data
end

function Module.Functions.LocalPlayerData()
	if not Players.LocalPlayer then return nil end 

	local LocalPlayer = GetLocalModel()

	if not LocalPlayer then
		return nil
	end

	local Parts = Module.Functions.GetBodyParts(LocalPlayer)

	local LocalData = {
		LocalPlayer = LocalPlayer,
		Character = LocalPlayer,
		Username = tostring(LocalPlayer),
		Displayname = Players.LocalPlayer.Name,
		Userid = 1,
		Team = nil,
		Tool = nil,
		Humanoid = LocalPlayer:FindFirstChild("humanoid_root_part"),
		Health = 100,
		MaxHealth = 100,
		RigType = 0,
		Teamname = "Friendly",
		Toolname = "Unknown",

		Head = Parts.Head,
		RootPart = Parts.HumanoidRootPart,
		LeftFoot = Parts.LeftLeg,
		LowerTorso = Parts.Torso,
		
		LeftArm = Parts.LeftArm,
		LeftLeg = Parts.LeftLeg,
		RightArm = Parts.RightArm,
		RightLeg = Parts.RightLeg,
		UpperTorso = Parts.Torso,
	}

	return tostring(LocalPlayer), LocalData
end

function Module.Functions.Update()
	if not GameStorage.Characters then return end

	local Descendants = GameStorage.Characters:GetChildren()
	local Seen = {}

	for _, Player in ipairs(Descendants) do
		if Player.Name ~= "StarterCharacter" then
			local Key = tostring(Player)
			local Parts = Module.Functions.GetBodyParts(Player)
			local Enemy = not Module.Functions.TeamCheck(Player)

			if Parts.Head and Parts.HumanoidRootPart and Enemy then
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
		local HumanoidRootPart = Model:FindFirstChild("humanoid_root_part")
		if not HumanoidRootPart or not Seen[Key] then
			remove_model_data(Key)
			Module.Added[Key] = nil
		end
	end
end

RunService.PostLocal:Connect(function()
    Module.Functions.Update()

	local LocalID, LocalData = Module.Functions.LocalPlayerData()
    if LocalID and LocalData then
        override_local_data(LocalData)
    end
end)
