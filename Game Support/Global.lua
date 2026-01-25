local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Cache = {
	Instances = {},
	Folders = {}
}

local Located = false
local Last = 0

local function GetWeapon(Entity)
	if not Entity then return "None" end
	
	for _, Tool in ipairs(Entity:GetChildren()) do
		if Tool.ClassName == "Tool" then
			return Tool.Name
		end
	end

	for _, Model in ipairs(Entity:GetChildren()) do
		if Model.ClassName == "Model" then
			if Model.Name ~= "Hat" and Model.Name ~= "Accessory" and 
			   Model.Name ~= "Hair" and Model.Name ~= "GunModel" and 
			   Model.Name ~= "HolsterModel" and Model.Name ~= "Model" and
			   not Model.Name:match("^Armor") then
				if Model:FindFirstChild("Muzzle") or Model:FindFirstChild("Handle") then
					return Model.Name
				end
			end
		end
	end

	return "None"
end

local function GetEntityParts(Model)
	if not Model then return nil end

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
		
		LeftLeg = Model:FindFirstChild("Left Leg") or Model:FindFirstChild("LeftLeg"),
		RightLeg = Model:FindFirstChild("Right Leg") or Model:FindFirstChild("RightLeg"),
		LeftArm = Model:FindFirstChild("Left Arm") or Model:FindFirstChild("LeftArm"),
		RightArm = Model:FindFirstChild("Right Arm") or Model:FindFirstChild("RightArm"),
		Torso = Model:FindFirstChild("Torso") or Model:FindFirstChild("Body"),
		
		HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChild("Root"),
	}
end

local function Validated(Model)
	if not Model or Model.ClassName ~= "Model" then return false end
	
	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return false end
	
	local Parts = GetEntityParts(Model)
	if not Parts or not Parts.HumanoidRootPart then return false end
	
	return true
end

local function GetEntityData(Model, Parts)
	if not Model or not Parts then return nil, nil end

	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	local Health = Humanoid and Humanoid.Health or 100
	local MaxHealth = Humanoid and Humanoid.MaxHealth or 100

	local Data = {
		Username = tostring(Model),
		Displayname = Model.Name,
		Userid = -1,
		Character = Model,
		PrimaryPart = Model.PrimaryPart or Parts.HumanoidRootPart,
		Humanoid = Humanoid or Model.PrimaryPart,
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
		RigType = Model:FindFirstChild("Torso") and 0 or 1,
		Toolname = GetWeapon(Model),
		Teamname = "NPCs",
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

local function GetPlayerData(Player)
	if not Player or not Player.Character then return nil, nil end

	local Character = Player.Character
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return nil, nil end

	local Parts = GetEntityParts(Character)
	if not Parts or not Parts.HumanoidRootPart then return nil, nil end

	local Health = Humanoid.Health
	local MaxHealth = Humanoid.MaxHealth

	local Data = {
		Username = Player.Name,
		Displayname = Player.DisplayName,
		Userid = Player.UserId,
		Character = Character,
		PrimaryPart = Character.PrimaryPart,
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
		RigType = Character:FindFirstChild("Torso") and 0 or 1,
		Toolname = GetWeapon(Character),
		Teamname = Player.Team and Player.Team.Name or "No Team",
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
		},
	}

	return tostring(Character), Data
end

local function Locate()
	local Allowed = {}
	Cache.Folders = {}
	
	for _, Object in ipairs(Workspace:GetDescendants()) do
		if Object.ClassName == "Model" and Validated(Object) then
			local Parent = Object.Parent
			
			if Parent and Parent ~= Workspace then
				local IsCharacter = false
				for _, Player in ipairs(Players:GetChildren()) do
					if Player.Character == Object then
						IsCharacter = true
						break
					end
				end
				
				if not IsCharacter then
					Allowed[Parent] = (Allowed[Parent] or 0) + 1
				end
			end
		end
	end
	
	for Folder, Count in pairs(Allowed) do
		if Count >= 1 then
			table.insert(Cache.Folders, Folder)
		end
	end
	
	if #Cache.Folders == 0 then
		table.insert(Cache.Folders, Workspace)
	end
	
	Located = true
	Last = os.clock()
end

local function PlayerScan(LocalPlayer, LocalCharacter, TState, Seen)
	for _, Player in ipairs(Players:GetChildren()) do
		pcall(function()
			if not Player or Player == LocalPlayer then return end
			
			local Character = Player.Character
			if not Character or Character == LocalCharacter then return end
			
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if not Humanoid then return end
			
			local Parts = GetEntityParts(Character)
			if not Parts or not Parts.HumanoidRootPart then return end
			
			local Key = tostring(Character)
			local Weapon = GetWeapon(Character)
			
			if TState and LocalPlayer.Team and Player.Team == LocalPlayer.Team then
				if Cache.Instances[Key] then
					remove_model_data(Key)
					Cache.Instances[Key] = nil
				end
				return
			end
			
			if not Cache.Instances[Key] then
				local ID, Data = GetPlayerData(Player)
				if ID and Data then
					if add_model_data(Data, ID) then
						Cache.Instances[ID] = Character
					end
				end
			else
				edit_model_data({ Toolname = Weapon }, Key)
				edit_model_data({ Health = Humanoid.Health }, Key)
			end
			
			Seen[Key] = true
		end)
	end
end

local function NPCScan(LocalCharacter, Seen)
	for _, Folder in ipairs(Cache.Folders) do
		if not Folder or not Folder.Parent then continue end
		
		local NPCs = Folder == Workspace and Folder:GetDescendants() or Folder:GetChildren()
		
		for _, NPC in ipairs(NPCs) do
			pcall(function()
				if not NPC or NPC.ClassName ~= "Model" or NPC == LocalCharacter then return end
				if not Validated(NPC) then return end
				
				local IsPlayerChar = false
				for _, Player in ipairs(Players:GetChildren()) do
					if Player.Character == NPC then
						IsPlayerChar = true
						break
					end
				end
				if IsPlayerChar then return end
				
				local Key = tostring(NPC)
				local Parts = GetEntityParts(NPC)
				
				if not Parts or not Parts.HumanoidRootPart then return end
				
				local Humanoid = NPC:FindFirstChildOfClass("Humanoid")
				local Weapon = GetWeapon(NPC)
				
				if not Cache.Instances[Key] then
					local ID, Data = GetEntityData(NPC, Parts)
					if ID and Data then
						if add_model_data(Data, ID) then
							Cache.Instances[ID] = NPC
						end
					end
				else
					edit_model_data({ Toolname = Weapon }, Key)
					if Humanoid then
						edit_model_data({ Health = Humanoid.Health }, Key)
					end
				end
				
				Seen[Key] = true
			end)
		end
	end
end

RunService.PostLocal:Connect(function()
	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then return end
	
	local LocalCharacter = LocalPlayer.Character
	
	if not Located then pcall(Locate) return end
	if #Cache.Folders == 0 and (os.clock() - Last) > 5 then Located = false return end
	
	local Seen = {}
	
	for Key, Model in pairs(Cache.Instances) do
		pcall(function()
			if not Model or not Model.Parent then
				remove_model_data(Key)
				Cache.Instances[Key] = nil
				return
			end
			
			if not Seen[Key] then
				local HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart")
				if not HumanoidRootPart then
					remove_model_data(Key)
					Cache.Instances[Key] = nil
				end
			end
		end)
	end

	PlayerScan(LocalPlayer, LocalCharacter, is_team_check_active(), Seen)
	NPCScan(LocalCharacter, Seen)
end)
