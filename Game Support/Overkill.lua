--!optimize 2
local Module = {
    Function = {},
    Added = {},
    Entities = {},
    Debugged = {}
}

local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera

local Ignored = {
    World = true,
    Camera = true,
    Debris = true,
    Debug = true,
    Objects = true,
    VFX = true,
    Terrain = true,
}

function Module.Function:Cache()
    for ID, Entry in Module.Entities do
        if not Entry or not Entry.Parent then
            Module.Entities[ID] = nil
        end
    end

    for _, Container in Workspace:GetChildren() do
        if not Ignored[Container.Name] then
            for _, Health in Container:GetDescendants() do
                if Health.Name == "Health" and Health:IsA("Script") then
                    if Health and Health.Parent and Health.Parent:IsA("Model") then
                        local Identifier = tostring(Health.Parent)
                        if not Module.Entities[Identifier] then
                            Module.Entities[Identifier] = Health.Parent
                        end
                    end
                end
            end
        end
    end
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

        HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart"),
    }
end

function Module.Function:PlayerData(Model, Parts)
    local Humanoid = Model:FindFirstChild("Humanoid")
    local Health = Humanoid and Humanoid.Health or 100

    local Data = {
        Username = tostring(Model),
        Displayname = Model.Name,
        Userid = math.random(2, 10000),
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
        MaxHealth = Humanoid and Humanoid.MaxHealth or 100,
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

function Module.Function:ClientData()
    local Data = {
        LocalPlayer = Camera,
        Character = Camera,
        Username = tostring(Camera),
        Displayname = game.Players.LocalPlayer.Name,
        Userid = 1,
        Humanoid = Camera,
        Health = 100,
        MaxHealth = 100,
        RigType = 1,
        Teamname = "Players",
        Toolname = "Unknown",

        Head = Camera,
        RootPart = Camera,
        LeftFoot = Camera,
        LowerTorso = Camera,
        LeftArm = Camera,
        LeftLeg = Camera,
        RightArm = Camera,
        RightLeg = Camera,
        UpperTorso = Camera
    }

    override_local_data(Data)
end

function Module.Function:Update()
    local Seen = {}

    for _, Player in Module.Entities do
        local Humanoid = Player:FindFirstChild("Humanoid")

        if Humanoid and Player.Parent then
            local Key = tostring(Player)
            local Parts = Module.Function:GetBodyParts(Player)

            if Parts.Head and Parts.HumanoidRootPart then
                if not Module.Added[Key] then
                    local ID, Data = Module.Function:PlayerData(Player, Parts)
                    if add_model_data(Data, ID) then
                        Module.Added[ID] = Player
                    end
                else
                    edit_model_data({ Health = Humanoid.Health }, Key)
                end

                Seen[Key] = true
            end
        end
    end

    for Key, Model in Module.Added do
        local HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart or not Seen[Key] then
            remove_model_data(Key)
            Module.Added[Key] = nil
        end
    end
end

task.spawn(function()
    while true do
        task.wait(3)
        Module.Function:Cache()
    end
end)

RunService.PostLocal:Connect(function()
    Module.Function:Update()
    Module.Function:ClientData()
end)
