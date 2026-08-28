-- // Service and Module \\ --

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Camera = Workspace.CurrentCamera

local Module = {
    Function = {},

    Stored = {
        Containers = {
            Players = nil,
            Entities = nil,
        },
        Mode = nil,
        Closest = nil,
        State = nil,
        Excluded = nil,
        Added = {},
    }
}

function Module.Function:CheckMode()
    if not Workspace then return nil end

    local Static = Workspace:FindFirstChild("Static")
    local Unfinished = Workspace:FindFirstChild("!Unfinished")
    local PvE = Workspace:FindFirstChild("PvE")
    local Live = Workspace:FindFirstChild("Live")

    if Static and Static.ClassName == "Folder" then
        Module.Stored.Mode = "PVP"
    elseif Unfinished and not PvE then
        Module.Stored.Mode = "Zombies PVP"
    elseif PvE then
        Module.Stored.Mode = "Zombies PVE"
    elseif Live then
        Module.Stored.Mode = "Openworld"
    end

    return Module.Stored.Mode
end

function Module.Function:GetContainer()
    if not Workspace then return nil end

    if not Module.Stored.Mode then
        Module.Function:CheckMode()
    end

    local Mode = Module.Stored.Mode

    local FirstModel = nil
    for _, Child in Workspace:GetChildren() do
        if Child.ClassName == "Model" and Child:FindFirstChild("Male") then
            FirstModel = Child
            break
        end
    end

    if Mode == "Openworld" then
        Module.Stored.Containers.Players = FirstModel
        Module.Stored.Containers.Entities = FirstModel
    elseif Mode == "Zombies PVP" or Mode == "Zombies PVE" then
        Module.Stored.Containers.Players = FirstModel
        Module.Stored.Containers.Entities = Workspace
    elseif Mode == "PVP" then
        Module.Stored.Containers.Players = FirstModel
        Module.Stored.Containers.Entities = nil
    else
        Module.Stored.Containers.Players = nil
        Module.Stored.Containers.Entities = nil
    end

    return Module.Stored.Containers
end

function Module.Function:EntityType(Entity)
    if not Entity then return nil end

    if not Module.Stored.Mode then
        Module.Function:CheckMode()
    end

    local Mode = Module.Stored.Mode

    if Mode == "PVP" then
        if Entity.Name == "Male" then return "Player" end
        return nil
    end

    if Mode == "Zombies PVE" or Mode == "Zombies PVP" then
        if Entity.Name == "Zombie" then return "Zombie" end
    end

    if Mode == "Zombies PVE" or Mode == "Zombies PVP" or Mode == "Openworld" then
        if Entity.Name == "Male" then
            if Entity:FindFirstChildOfClass("BillboardGui") then
                return "Player"
            else
                return "NPC"
            end
        end
    end

    return nil
end

function Module.Function:GetClosestPlayer()
    if not Module.Stored.Containers.Players or not Module.Stored.Containers.Players.Parent then
        Module.Function:GetContainer()
    end

    local Container = Module.Stored.Containers.Players
    if not Container then return nil end

    local ClosestModel = nil
    local ClosestDistance = math.huge

    for _, Model in Container:GetChildren() do
        if Module.Function:EntityType(Model) == "Player" then
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

function Module.Function:CheckWorldModel()
    if not Camera then return false end
    return Camera:FindFirstChild("WorldModel") ~= nil
end

function Module.Function:GetBodyParts(Model)
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

function Module.Function:PlayerData(Model, Parts)
    local Type = Module.Function:EntityType(Model)

    local Data = {
        Username = tostring(Model),
        Displayname = Type == "Player" and "Player" or Type == "Zombie" and "Zombie" or "AI",
        Userid = Type == "Player" and 0 or -1,
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
        Toolname = "Unknown",
        Teamname = Type == "Player" and "Players" or Type == "Zombie" and "Zombies" or "NPCs",
        Whitelisted = false,
        Archenemies = Type == "Player" and true or false,
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

function Module.Function:Update()
    Module.Function:GetContainer()

    local Mode = Module.Function:CheckMode()

    local Containers = Module.Stored.Containers
    if not Containers.Players and not Containers.Entities then return end

    local Seen = {}

    local function ProcessModel(Object)
        pcall(function()
            if not (Object and Object:IsA("Model")) then return end

            local Type = Module.Function:EntityType(Object)
            if not Type then return end

            if Mode == "Openworld" and Type == "Player" then return end

            local Key = tostring(Object)
            if Module.Stored.State and Object == Module.Stored.Excluded then return end

            local Parts = Module.Function:GetBodyParts(Object)
            if not (Parts and Parts.Head and Parts.HumanoidRootPart) then return end

            Seen[Key] = true

            if not Module.Stored.Added[Key] then
                local Success, ID, Data = pcall(function()
                    return Module.Function:PlayerData(Object, Parts)
                end)

                if Success and ID and Data and add_model_data(Data, Key) then
                    Module.Stored.Added[Key] = Object
                end
            end
        end)
    end

    if Containers.Players then
        for _, Object in Containers.Players:GetChildren() do
            ProcessModel(Object)
        end
    end

    if Containers.Entities and Containers.Entities ~= Containers.Players then
        for _, Object in Containers.Entities:GetChildren() do
            ProcessModel(Object)
        end
    end

    for Key, Model in pairs(Module.Stored.Added) do
        pcall(function()
            if not (Model and Model.Parent) then
                remove_model_data(Key)
                Module.Stored.Added[Key] = nil
                return
            end

            local Success, HumanoidRootPart = pcall(function()
                return Model:FindFirstChild("Root")
            end)

            if not Success or not HumanoidRootPart or not Seen[Key] then
                remove_model_data(Key)
                Module.Stored.Added[Key] = nil
            end
        end)
    end
end

local function CameraProxyData()
    return tostring(Camera), {
        LocalPlayer = Camera,
        Character = Camera,
        Username = tostring(Camera),
        Displayname = Players.LocalPlayer.Name,
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
end

function Module.Function:LocalPlayerData()
    if not Camera then return nil end

    if Module.Function:CheckMode() == "Openworld" then
        return CameraProxyData()
    end

    if Module.Stored.Closest then
        local Parts = Module.Function:GetBodyParts(Module.Stored.Closest)
        if Parts and Parts.Head and Parts.HumanoidRootPart then
            return tostring(Module.Stored.Closest), {
                LocalPlayer = Module.Stored.Closest,
                Character = Module.Stored.Closest,
                Username = tostring(Module.Stored.Closest),
                Displayname = Players.LocalPlayer.Name,
                Userid = 1,
                Team = Camera,
                Tool = Camera,
                Humanoid = Parts.Head,
                Health = 100,
                MaxHealth = 100,
                RigType = 1,
                Head = Parts.Head,
                RootPart = Parts.HumanoidRootPart,
                LeftFoot = Parts.LeftFoot,
                LowerTorso = Parts.LowerTorso,
            }
        end
    end

    return CameraProxyData()
end

task.spawn(function()
    while true do
        task.wait(0.5)
        local New = Module.Function:GetClosestPlayer()
        
        if Module.Stored.Mode == "Openworld" then
            Module.Stored.State = false
            Module.Stored.Excluded = nil
            Module.Stored.Closest = nil
        elseif Module.Stored.Mode == "PVP" then
            Module.Stored.State = false
            Module.Stored.Excluded = nil
            Module.Stored.Closest = New
        else
            if Module.Function:CheckWorldModel() then
                Module.Stored.State = false
                Module.Stored.Excluded = nil
            else
                Module.Stored.State = true
                Module.Stored.Excluded = New
            end
            
            Module.Stored.Closest = New
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        Module.Function:Update()

        local ID, Data = Module.Function:LocalPlayerData()
        if ID and Data then override_local_data(Data) end
    end
end)
