--!optimize 2
local Module = {
    Functions = {},
    Added = {},
    Container = nil,

    LocalPlayer = {
        Closest = nil,
        State = false,
        Excluded = nil,
    }
}

local Workspace = game:GetService("Workspace")
local PlaceID = game.PlaceId

local Places = {
    ["Openworld"] = { 3701546109 },
    ["Zombies"] = { 4747446334 },
    ["2V2"] = { 5480112241, 3826587512 },
    ["5V5"] = { 3826587512 },
    ["Ranked"] = { 4524359706 }
}

Module.Functions.IsPlace = function(Name)
    for _, ID in ipairs(Places[Name]) do
        if PlaceID == ID then return true end
    end
    return false
end

Module.Functions.IsPVP = function()
    return Module.Functions.IsPlace("2V2") or Module.Functions.IsPlace("5V5") or Module.Functions.IsPlace("Ranked")
end

Module.Functions.GetContainer = function()
    if Module.Functions.IsPVP() then
        Module.Container = Workspace
        return Module.Container
    end

    if Module.Container and Module.Container.Parent then return Module.Container end

    for _, Object in ipairs(Workspace:GetChildren()) do
        if Object:IsA("Model") and Object.Name == "Model" then
            if Object:FindFirstChildOfClass("Model") and Object:FindFirstChildOfClass("Model").Name == "Male" then
                Module.Container = Object
                return Module.Container
            end
        end
    end

    return Workspace
end

Module.Functions.IsPlayerModel = function(Model)
    if Module.Functions.IsPVP() then
        return Model.Name == "Male"
    end
    return Model:FindFirstChild("BillboardGui") ~= nil
end

Module.Functions.IsZombieModel = function(Model)
    return Model.Name == "Zombie"
end

Module.Functions.GetClosestPlayer = function()
    local Camera = Workspace:FindFirstChild("Camera")
    if not Camera then return nil end

    if Camera:FindFirstChild("WorldModel") then return nil end

    local ClosestModel = nil
    local ClosestDistance = math.huge

    for _, Model in pairs(Module.Container:GetChildren()) do
        if Model:IsA("Model") and Model.Name == "Male" and Module.Functions.IsPVP() or Module.Functions.IsPlayerModel(Model) then
            local HumanoidRootPart = Model:FindFirstChild("Root")
            if HumanoidRootPart then
                local Distance = vector.magnitude(HumanoidRootPart.Position - Camera.Position)
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    ClosestModel = Model
                end
            end
        end
    end

    return ClosestModel
end

Module.Functions.CheckWorldModel = function()
    local Camera = Workspace:FindFirstChild("Camera")
    if not Camera then return false end
    
    local WorldModel = Camera:FindFirstChild("WorldModel")
    return WorldModel ~= nil
end

Module.Functions.GetBodyParts = function(Model)
    return {
        Head = Model:FindFirstChild("Head"),
        UpperTorso = Model:FindFirstChild("LowerTorso"),
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

Module.Functions.PlayerData = function(Model, Parts)
    local isPlayer = Module.Functions.IsPlayerModel(Model)
    local isZombie = Module.Functions.IsZombieModel(Model)

    local Data = {
        Username = tostring(Model),
        Displayname = isPlayer and "Player" or isZombie and "Zombie" or "AI",
        Userid = isPlayer and 0 or -1,
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
        Teamname = isPlayer and "Players" or isZombie and "Zombies" or "NPCs",
        Whitelisted = false,
        Archenemies = isPlayer and true or false,
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
        local New = Module.Functions.GetClosestPlayer()
        
        if Module.Functions.IsPlace("Openworld") then
            Module.LocalPlayer.State = false
            Module.LocalPlayer.Excluded = nil
            Module.LocalPlayer.Closest = nil
        elseif Module.Functions.IsPVP() then
            Module.LocalPlayer.State = false
            Module.LocalPlayer.Excluded = nil
            Module.LocalPlayer.Closest = New
        else
            if Module.Functions.CheckWorldModel() then
                Module.LocalPlayer.State = false
                Module.LocalPlayer.Excluded = nil
            else
                Module.LocalPlayer.State = true
                Module.LocalPlayer.Excluded = New
            end
            
            Module.LocalPlayer.Closest = New
        end
    end
end)

Module.Functions.Update = function()
    Module.Functions.GetContainer()
    if not Module.Container or not Module.Container.Parent then return end

    local Seen = {}

    local function ProcessModel(Object)
        pcall(function()
            if not Object then return end

            if Object:IsA("Model") and (Object.Name == "Male" or Object.Name == "Zombie" or Module.Functions.IsPlayerModel(Object)) then
                local Key = tostring(Object)
                if not Key then return end

                if Module.Functions.IsPlace("Openworld") and Object.Name == "Male" and Module.Functions.IsPlayerModel(Object) then
                    return
                end

                local Parts = Module.Functions.GetBodyParts(Object)

                if Parts and Parts.Head and Parts.HumanoidRootPart then
                    if Module.LocalPlayer.State and Module.LocalPlayer.Excluded and Object == Module.LocalPlayer.Excluded then
                        if not Module.Functions.IsPlace("Zombies") or Module.Functions.IsPlayerModel(Object) then
                            return
                        end
                    end

                    if not Module.Added[Key] then
                        local Success2, ID, Data = pcall(function()
                            return Module.Functions.PlayerData(Object, Parts)
                        end)

                        if Success2 and ID and Data then
                            local Success3, Result = pcall(function()
                                return add_model_data(Data, ID)
                            end)

                            if Success3 and Result then
                                Module.Added[ID] = Object
                            end
                        end
                    end

                    Seen[Key] = true
                end
            end
        end)
    end

    for _, Object in ipairs(Module.Container:GetChildren()) do
        ProcessModel(Object)
    end

    if Module.Functions.IsPlace("Zombies") then
        for _, Object in ipairs(Workspace:GetChildren()) do
            if Object.Name == "Zombie" then
                ProcessModel(Object)
            end
        end
    end

    for Key, Model in pairs(Module.Added) do
        pcall(function()
            if not Model then
                remove_model_data(Key)
                Module.Added[Key] = nil
                return
            end

            local Success, HumanoidRootPart = pcall(function()
                return Model:FindFirstChild("Root")
            end)

            if not Success then HumanoidRootPart = nil end

            if not HumanoidRootPart or not Seen[Key] then
                remove_model_data(Key)
                Module.Added[Key] = nil
            end
        end)
    end
end

Module.Functions.LocalPlayerData = function()
    local Camera = Workspace:FindFirstChild("Camera")
    if not Camera then return end

    if Module.Functions.IsPlace("Openworld") then
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

    if Module.LocalPlayer.Closest then
        local Parts = Module.Functions.GetBodyParts(Module.LocalPlayer.Closest)
        if Parts and Parts.Head and Parts.HumanoidRootPart then
            local Data = {
                LocalPlayer = Module.LocalPlayer.Closest,
                Character = Module.LocalPlayer.Closest,
                Username = tostring(Module.LocalPlayer.Closest),
                Displayname = game.Players.LocalPlayer.Name,
                Userid = 1,
                Teamname = Module.Functions.IsPlayerModel(Module.LocalPlayer.Closest) and "Players" or Module.Functions.IsZombieModel(Module.LocalPlayer.Closest) and "Zombies" or "NPCs",
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

task.spawn(function()
    while true do
        task.wait(0.1)
        Module.Functions.Update()
    
        local ID, Data = Module.Functions.LocalPlayerData()
        if ID and Data then override_local_data(Data) end
    end
end)
