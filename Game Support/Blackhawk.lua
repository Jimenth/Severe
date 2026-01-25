local Added = {}
local Workspace = game:GetService("Workspace")
local Closest
local PlaceID = game.PlaceId

local Places = {
    ["Openworld"] = 3701546109,
    ["Zombies"] = 4747446334, 
    ["2V2"] = 5289429734,
    ["5V5"] = 5480112241,
    ["Ranked"] = 4524359706
}

local function IsPlayerModel(Model)
    return Model:FindFirstChild("BillboardGui") ~= nil
end

local function IsZombieModel(Model) 
    return Model.Name == "Zombie" 
end

local function GetClosestPlayer()
    local Camera = Workspace:FindFirstChild("Camera")
    if not Camera then return nil end

    if Camera:FindFirstChild("WorldModel") then return nil end

    local ClosestModel = nil
    local ClosestDistance = math.huge
    local CameraPosition = Camera.Position

    for _, Model in pairs(Workspace:GetChildren()) do
        if Model.ClassName == "Model" and Model.Name == "Male" and IsPlayerModel(Model) then
            local Root = Model:FindFirstChild("Root")
            if Root then
                local Distance = vector.magnitude(Root.Position - CameraPosition)
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    ClosestModel = Model
                end
            end
        end
    end

    return ClosestModel
end

local function CheckWorldModel()
    local Camera = Workspace:FindFirstChild("Camera")
    if not Camera then return false end
    
    local WorldModel = Camera:FindFirstChild("WorldModel")
    return WorldModel ~= nil
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

        HumanoidRootPart = Model:FindFirstChild("Root"),
    }
end

local function PlayerData(Model, Parts)
    local Data = {
        Username = tostring(Model),
        Displayname = IsPlayerModel(Model) and "Player" or IsZombieModel(Model) and "Zombie" or "AI",
        Userid = IsPlayerModel(Model) and 0 or -1,
        Character = Model,
        PrimaryPart = Parts.Head,
        Humanoid = Parts.Head,
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
        Toolname = "None",
        Teamname = IsPlayerModel(Model) and "Players" or IsZombieModel(Model) and "Zombies" or "NPCs",
        Whitelisted = false,
        Archenemies = IsPlayerModel(Model) and true or false,
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

task.spawn(function()
    while true do
        task.wait(0.5)
        local New = GetClosestPlayer()
        
        if PlaceID == Places["Openworld"] then
            State = false
            Excluded = nil
            Closest = nil
        elseif PlaceID == Places["2V2"] or PlaceID == Places["5V5"] or PlaceID == Places["Ranked"] then
            State = false
            Excluded = nil
            Closest = New
        else
            if CheckWorldModel() then
                State = false
                Excluded = nil
            else
                State = true
                Excluded = New
            end
            
            Closest = New
        end
    end
end)

local function Update()
    local Seen = {}

    for _, Object in ipairs(Workspace:GetChildren()) do
        pcall(function()
            if not Object then return end
            
            if Object.ClassName == "Model" and (Object.Name == "Male" or (PlaceID == Places["Zombies"] and (Object.Name == "Zombie" or IsPlayerModel(Object)))) then
                local Key = tostring(Object)
                if not Key then return end
                
                if PlaceID == Places["Openworld"] and Object.Name == "Male" and IsPlayerModel(Object) then
                    return
                end
                
                local Parts = GetBodyParts(Object)

                if Parts and Parts.Head and Parts.HumanoidRootPart then
                    if not Added[Key] then
                        local Success2, ID, Data = pcall(function()
                            return PlayerData(Object, Parts)
                        end)
                        
                        if Success2 and ID and Data then
                            local Success3, Result = pcall(function()
                                return add_model_data(Data, ID)
                            end)
                            
                            if Success3 and Result then
                                Added[ID] = Object
                            end
                        end
                    end

                    Seen[Key] = true
                end
            end
        end)
    end

    for Key, Model in pairs(Added) do
        pcall(function()
            if not Model then
                remove_model_data(Key)
                Added[Key] = nil
                return
            end
            
            local Success, HumanoidRootPart = pcall(function() 
                return Model:FindFirstChild("Root") 
            end)
            
            if not Success then HumanoidRootPart = nil end
            
            if not HumanoidRootPart or not Seen[Key] then
                pcall(function() remove_model_data(Key) end)
                
                Added[Key] = nil
            end
        end)
    end
end

local function LocalPlayerData()
    local Camera = Workspace:FindFirstChild("Camera")
    if not Camera then return end

    if PlaceID == Places["Openworld"] then
        local Data = {
            LocalPlayer = Camera,
            Character = Camera,
            Username = tostring(Camera),
            Displayname = game.Players.LocalPlayer.Name,
            Userid = 1,
            Team = Camera,
            Tool = Camera,
            Humanoid = Camera,
            Health = 100,
            MaxHealth = 100,
            RigType = 1,

            Head = Camera,
            RootPart = Camera,
            LeftFoot = Camera,
            LowerTorso = Camera,
        }

        override_local_data(Data)
        return
    end

    if Closest then
        local Parts = GetBodyParts(Closest)
        if Parts and Parts.Head and Parts.HumanoidRootPart then
            local Data = {
                LocalPlayer = Closest,
                Character = Closest,
                Username = tostring(Closest),
                Displayname = game.Players.LocalPlayer.Name,
                Userid = 1,
                Teamname = IsPlayerModel(Closest) and "Players" or IsZombieModel(Closest) and "Zombies" or "NPCs",
                Toolname = "None",
                Humanoid = Parts.Head,
                Health = 100,
                MaxHealth = 100,
                RigType = 1,

                RootPart = Parts.HumanoidRootPart,
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

            override_local_data(Data)
            return
        end
    end

    local Data = {
        LocalPlayer = Camera,
        Character = Camera,
        Username = tostring(Camera),
        Displayname = game.Players.LocalPlayer.Name,
        Userid = 1,
        Team = Camera,
        Tool = Camera,
        Humanoid = Camera,
        Health = 100,
        MaxHealth = 100,
        RigType = 1,

        Head = Camera,
        RootPart = Camera,
        LeftFoot = Camera,
        LowerTorso = Camera,
    }

    override_local_data(Data)
end

RunService.PostLocal:Connect(function()
    Update()
    
    local ID, Data = LocalPlayerData()
    if ID and Data then override_local_data(Data) end
end)
