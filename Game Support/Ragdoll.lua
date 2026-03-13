--!optimize 2
local Module = {
	Functions = {},
	Added = {},

    LocalPlayer = nil,
}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Characters = Workspace:FindFirstChild("LiveRagdolls")

Module.Functions.GetLocalModel = function()
	if not Characters then return nil end

    Module.LocalPlayer = Characters:FindFirstChild(LocalPlayer.Name)
    return Module.LocalPlayer
end

Module.Functions.GetBodyParts = function(Model)
	return {
		Head = Model:FindFirstChild("Head"),
		LeftArm = Model:FindFirstChild("Left Arm"),
		RightArm = Model:FindFirstChild("Right Arm"),
		RightLeg = Model:FindFirstChild("Right Leg"),
		LeftLeg = Model:FindFirstChild("Left Leg"),
		Torso = Model:FindFirstChild("Torso"),
		HumanoidRootPart = Model:FindFirstChild("Torso")
	}
end

Module.Functions.PlayerData = function(Model, Parts)
	if not Model then return nil end

    local Instance = Players:FindFirstChild(Model.Name)
	if not Instance then return nil end

	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return nil end

	local Health = Humanoid.Health
	local MaxHealth = Humanoid.MaxHealth

	local Team = Instance:FindFirstChild("Team")
	if not Team or not Team:IsA("StringValue") then return nil end

	local Data = {
		Username = Instance.Name,
		Displayname = Instance.DisplayName,
		Userid = Instance.UserId,
		Character = Model,
		PrimaryPart = Model.PrimaryPart,
		Humanoid = Humanoid,
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
		Teamname = Team.Value,
		Toolname = "Unknown",
		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,
		Health = Health,
		MaxHealth = MaxHealth,
	}

	return tostring(Model), Data
end

Module.Functions.LocalPlayerData = function()
	if not Module.LocalPlayer then Module.Functions.GetLocalModel() end

	local Parts = Module.Functions.GetBodyParts(Module.LocalPlayer)

	local Humanoid = Module.LocalPlayer:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return nil end

	local Health = Humanoid.Health
	local MaxHealth = Humanoid.MaxHealth

	local Team = Module.LocalPlayer:FindFirstChild("Team")
	if not Team or not Team:IsA("StringValue") then return nil end

	local LocalData = {
		LocalPlayer = LocalPlayer,
		Character = Module.LocalPlayer,
		Username = LocalPlayer.Name,
		Displayname = LocalPlayer.DisplayName,
		Userid = LocalPlayer.UserId,
		Team = Team.Value,
		Tool = nil,
		Humanoid = Humanoid,
		Health = Health,
		MaxHealth = MaxHealth,
		RigType = 0,
		Teamname = Team.Value,
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

	return tostring(Module.LocalPlayer), LocalData
end

Module.Functions.Update = function()
	if not Characters then return end

	local Seen = {}

	for _, Player in ipairs(Characters:GetChildren()) do
		if Player.Name ~= LocalPlayer.Name then
			local Key = tostring(Player)
			local Parts = Module.Functions.GetBodyParts(Player)

			if Parts.Head and Parts.HumanoidRootPart then
				if not Module.Added[Key] then
   			        local ID, Data = Module.Functions.PlayerData(Player, Parts)
      			        if ID and Data then
             			    if add_model_data(Data, ID) then
                            Module.Added[ID] = Player
                        end
                    end
				else
					local Humanoid = Player:FindFirstChildOfClass("Humanoid")
					if Humanoid then
						edit_model_data({ Health = Humanoid.Health }, Key)
					end
				end

				Seen[Key] = true
			end
		end
	end

	for Key, Model in pairs(Module.Added) do
		local HumanoidRootPart = Model:FindFirstChild("Torso")
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
