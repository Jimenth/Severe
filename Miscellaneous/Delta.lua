--!optimize 2
local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/Severe/refs/heads/main/Epstein%20Highlighter.lua"))();
task.wait(2)
Bytecode = game:HttpGet("https://raw.githubusercontent.com/DCHARLESAKAMRGREEN/Severe-Luas/main/Libraries/Pseudosynonym.lua")
local Load = luau.load(Bytecode)
local Library = Load()
task.wait(2)

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Dropped = Workspace:FindFirstChild("DroppedItems")
local Containers = Workspace:FindFirstChild("Containers")
local Vehicles = Workspace:FindFirstChild("Vehicles")
local Zones = Workspace:FindFirstChild("AiZones")
local ExitLocations = Workspace:FindFirstChild("NoCollision") and Workspace.NoCollision:FindFirstChild("ExitLocations")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Version = "1.0.0"

local Window = Library:CreateWindow({
    Title = "Project Dih | "..  Workspace:GetAttribute("MapName")..  " | "..  Version,
    Tag = LocalPlayer.Name,
    Keybind = "Insert",
    AutoShow = true
})

local Interface = {
    Dimensions = {
        Width = 320,
        Height = 64,
    },

    Padding = {
        Outer = 4,
        Inner = 6,
    },

    Coloring = {
        Accent = Color3.fromRGB(95, 100, 127),
        Text = Color3.fromRGB(249, 249, 249),
        SubtleText = Color3.fromRGB(200, 200, 200),

        Border = {
            Outer = Color3.fromRGB(30, 30, 30),
            Inner = Color3.fromRGB(12, 12, 12),
        },

        Background = {
            Main = Color3.fromRGB(22, 22, 22),
            Content = Color3.fromRGB(34, 34, 34),
        }
    },

    Font = "Proggy",
    SmallText = 12,
    MediumText = 14,
}

local Crates = {
    ["Military"] = {
        "MilitaryCrate",
        "LargeMilitaryBox",
        "SmallMilitaryBox",
        "GrenadeCrate",
        "SupplyDropMilitary",
        "SupplyDropMilitary_XMAS",
        "SupplyDropMilitary_Default"
    },

    ["Civilian"] = {
        "MedBag",
        "PC",
        "Toolbox",
        "CashRegister",
        "SportBag",
        "SatchelBag",
        "Safe",
        "Fridge",
        "FilingCabinet"
    },

    ["EDF"] = {
        "SupplyDropEDF",
        "SupplyDropEDF_XMAS",
        "SupplyDropEDF_Default"
    },

    ["Other"] = {
        "HiddenCache",
        "KGBBag",
        "SerumContainer",
        "ModificationStation",
        "LargeABPOPABox",
        "LargeShippingCrate",
        "SmallShippingCrate"
    }
}

local Items = {
    ["Weapons"] = {
        "AKM",
        "AKMN",
        "AsVal",
        "FAL",
        "IZh81",
        "IZh12",
        "M4",
        "MK23",
        "MP443",
        "MP5SD",
        "Mosin",
        "PKM",
        "PPSH41",
        "R700",
        "RPG7",
        "Saiga12",
        "SKS",
        "SVD",
        "TFZ98S",
        "TT33",
        "VZ61",
        "FlareGun",
        "ADAR15",
        "M9Fade"
    },

    ["Attachments"] = {
        "ACOG",
        "DV2",
        "DAGR",
        "FlashHiderAKM",
        "FlashHiderFAL",
        "FlashHiderKAC",
        "FlashHiderM4",
        "FlashHiderSVD",
        "Flashlight",
        "FrontAKMN",
        "FrontAsVal",
        "FrontFAL",
        "FrontIZh12",
        "FrontIZh81",
        "FrontM4",
        "FrontMK12",
        "FrontPKM",
        "FrontSKS",
        "FrontSVD",
        "FrontSaiga",
        "FrontTimberwolf",
        "FrontADAR",
        "GoldenDV2",
        "HandleAKMN",
        "HandleAsVal",
        "HandleFAL",
        "HandleM4",
        "HandleRK3AKMN",
        "HoloSight",
        "ImprFrontAKM",
        "ImprHandleAKM",
        "ImprStockAKM",
        "KACSuppressor",
        "LaserPointer",
        "LaserPointerOLD",
        "LPVO",
        "MuzzleBrakeAKM",
        "OKP7",
        "OilCanSuppressor",
        "PBS1",
        "PSO1",
        "PistolMuzzleBrake",
        "PolymerStockAKMN",
        "PuScope",
        "Scope6X",
        "SniperScope",
        "SOCOM556",
        "SRO",
        "StockA5",
        "StockAKMN",
        "StockAsVal",
        "StockFAL",
        "StockIZh12",
        "StockIZh81",
        "StockM4",
        "StockMK12",
        "StockMP5",
        "StockPKM",
        "StockPPSH41",
        "StockPT1AKMN",
        "StockSKS",
        "StockSVD",
        "StockADAR",
        "T1Sight",
        "TacticalFrontAKMN",
        "TacticalFrontSKS",
        "TacticalFrontSVD",
        "TacticalStockSKS",
        "TacticalStockSVD",
        "TimberWolfSuppressor",
        "DefaultFrontMosin",
        "DefaultStockMosin"
    },

    ["Magazines"] = {
        "20Rnd556",
        "20rndFAL",
        "762x25MAG",
        "762x25Rnd71Mag",
        "762x25TTMAG",
        "762x39MAG",
        "762x39ImprMAG",
        "762x39Rnd75Mag",
        "762x54Rnd10Mag",
        "762x54Rnd20Mag",
        "9x18MakarovMAG",
        "9x18MakarovDrumMag",
        "9x18vzMag",
        "9x18vzDrumMag",
        "9x19MP443MAG",
        "9x19MP5MAG",
        "9x19MP5DrumMAG",
        "9x39Mag",
        "9x39Rnd30Mag",
        "AmmoBoxPKM100rnd",
        "Mag556",
        "Mag556Rnd100",
        "MagR700",
        "MagTFZ98",
        "MK23ExtMag",
        "PMAG10rnd",
        "SaigaMag5rnd",
        "SaigaMag20rnd"
    },

    ["Ammo"] = {
        "12gaAP",
        "12gaBuckshot",
        "12gaFlechette",
        "12gaSlug",
        "338AP",
        "338T",
        "45AP",
        "45Tracer",
        "556x45AP",
        "556x45Tracer",
        "762x25AP",
        "762x25Tracer",
        "762x39AP",
        "762x39Tracer",
        "762x51AP",
        "762x51Tracer",
        "762x54AP",
        "762x54Tracer",
        "9x18AP",
        "9x18Tracer",
        "9x18Z",
        "9x19AP",
        "9x19Tracer",
        "9x39AP",
        "9x39Z",
        "PG7"
    },

    ["Medical"] = {
        "AI2",
        "AI4",
        "AA2",
        "Bandage",
        "IFAK",
        "Rags",
        "WoundDressing",
        "SerumYellow",
        "SerumRed",
        "SerumGreen"
    },

    ["Armor"] = {
        "6B2",
        "6b 23",
        "6b 27",
        "6b 43",
        "6b 47",
        "6B5",
        "Altyn",
        "Attak5",
        "Bandoiler",
        "ConcealedVest",
        "DozerArmor",
        "FastMT",
        "HSPV",
        "IOTV4",
        "JPC",
        "Kulon",
        "LegArmor",
        "Lynx",
        "MotorcycleHelmet",
        "SSH68",
        "Smersh",
        "TORS",
        "TankCap",
        "Tortilla",
        "ZSh",
        "UNOVest",
        "UNOHelmet",
        "ScavKingVest",
        "ScavKingHelmet"
    },

    ["Clothing"] = {
        "Balaclava",
        "CamoPants",
        "CamoShirt",
        "CivilianPants",
        "CivilianShirt",
        "CombatGloves",
        "GhillieHood",
        "GhillieLegs",
        "GhillieTorso",
        "GorkaPants",
        "GorkaShirt",
        "HandWraps",
        "KneePads",
        "SpecopsBackpack",
        "WastelandBackpack",
        "WastelandPants",
        "WastelandShirt",
        "SantaHat"
    },

    ["Visors"] = {
        "AltynVisor",
        "FastVisor",
        "LowCutVisor",
        "MaskaVisor",
        "MotorcycleHelmetVisor",
        "ZShVisor"
    },

    ["Optics"] = {
        "GP5",
        "GP5Filter",
        "HeadMount",
        "ONV9",
        "QuadNVG",
        "PN6K5",
        "SPSh44"
    },

    ["Melee"] = {
        "AnarchyTomahawk",
        "Cutlass",
        "Greatsword",
        "IceAxe",
        "IceDagger",
        "Karambit",
        "Kukri",
        "Longsword",
        "PlasmaNinjato",
        "Reapir",
        "Scythe",
        "TitanShield"
    },

    ["Grenades"] = {
        "f1",
        "M84",
        "RGD5",
        "RGO"
    },

    ["Deployables"] = {
        "Barricade",
        "GrenadeTrap",
        "MON50",
        "PMN2",
        "Sandbag"
    },

    ["Food"] = {
        "Beans",
        "BloxyCola",
        "CatfrogSoda",
        "ChocolateBar",
        "CondensedMilk",
        "KevCola",
        "MaxEnergy",
        "ResKola",
        "WaterBottle"
    },

    ["Keys"] = {
        "AirfieldTunnelsKey",
        "Apartment13Key",
        "Apartment21Key",
        "ATCKey",
        "B05Key",
        "CitySubstationtKey",
        "CraneKey",
        "DormA211Key",
        "DormB203Key",
        "EVACKey",
        "FactoryGarageKey",
        "FrigateKey",
        "FuelingStationKey",
        "HydroBasementKey",
        "LighthouseKey",
        "PoolKey",
        "VillageKey",
        "Villa1Key",
        "BlueCard",
        "OrangeCard",
        "RedCard",
        "KeyChain"
    },

    ["Tools"] = {
        "FlatScrewdriver",
        "Hammer",
        "Lighter",
        "PH2Screwdriver",
        "Wrench",
        "RepairKit"
    },

    ["Materials"] = {
        "AABattery",
        "AramidFabric",
        "Bolts",
        "CopperCoil",
        "CottonFabric",
        "DuctTape",
        "Fuze",
        "Gold50g",
        "Gunpowder",
        "LinenFabric",
        "Lvl4Plate",
        "MetalChunks",
        "Nails",
        "Nuts",
        "OilCan",
        "Planks",
        "RipstopFabric",
        "Rubles",
        "SteelPipe",
        "SuperGlue",
        "WeaponParts"
    },

    ["Electronics"] = {
        "CFan",
        "CPU",
        "GPU",
        "PortableConsole",
        "PSU",
        "RAM",
        "SSD",
        "Smartphone"
    },

    ["Valuables"] = {
        "GoldWatch",
        "GoldenTicket",
        "SolterStatue"
    },

    ["Maps"] = {
        "EstonianBorderMap",
        "Map",
        "Pathfinder",
        "Radio"
    },

    ["Special"] = {
        "GiftTier1",
        "GiftTier2",
        "GiftTier3",
        "Snowball",
        "TFZ0"
    }
}

local VisualsTab = Window:AddTab({ Name = "Visuals" })
local Visuals = VisualsTab:AddContainer({ Name = "Main", Side = "Left", AutoSize = true })
local MainDrops = Visuals:AddTab("Drops")
local MainCrates = Visuals:AddTab("Crates")
local MainCorpses = Visuals:AddTab("Corpses")

local RenderDrops = MainDrops:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Renders All Item Drops" })
local RenderDropsHighlight = MainDrops:AddToggle({ Name = "Highlight", Value = false, Tooltip = "Enable Highlights for Drops" })
local DropDistance = MainDrops:AddSlider({ Name = "Distance", Min = 0, Max = 1500, Default = 150, Rounding = 5 })
local DropFilter = MainDrops:AddDropdown({ Name = "Item Filter", Values = {"Weapons", "Attachments", "Magazines", "Ammo", "Medical", "Armor", "Clothing", "Visors", "Optics", "Melee", "Grenades", "Deployables", "Food", "Keys", "Tools", "Materials", "Electronics", "Valuables", "Maps", "Special"}, Default = {"Weapons"}, Multi = true })

local RenderCrates = MainCrates:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Render All Loot Crates" })
local RenderCratesHighlight = MainCrates:AddToggle({ Name = "Highlight", Value = false, Tooltip = "Enable Highlights for Crates" })
local CrateDistance = MainCrates:AddSlider({ Name = "Distance", Min = 0, Max = 1500, Default = 150, Rounding = 5 })
local CrateFilter = MainCrates:AddDropdown({ Name = "Crate Filter", Values = {"Military", "Civilian", "EDF", "Other"}, Default = {"Civilian"}, Multi = true })
MainCrates:AddSeparator()
local DisplayInventory = MainCrates:AddToggle({ Name = "Display Inventory", Value = false, Tooltip = "Show items inside crates" })
local InventoryFilter = MainCrates:AddDropdown({ Name = "Inventory Filter", Values = {"Weapons", "Attachments", "Magazines", "Ammo", "Medical", "Armor", "Clothing", "Visors", "Optics", "Melee", "Grenades", "Deployables", "Food", "Keys", "Tools", "Materials", "Electronics", "Valuables", "Maps", "Special"}, Default = {"Weapons"}, Multi = true })

local RenderCorpses = MainCorpses:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Render All Player Corpses" })
local RenderCorpsesHighlight = MainCorpses:AddToggle({ Name = "Highlight", Value = false, Tooltip = "Performance Intensive" })
local CorpseDistance = MainCorpses:AddSlider({ Name = "Distance", Min = 0, Max = 1500, Default = 150, Rounding = 5 })

local VehiclesContainer = VisualsTab:AddContainer({ Name = "Vehicles", Side = "Right", AutoSize = true })
local MainVehicles = VehiclesContainer:AddTab("Vehicles")
local RenderVehicles = MainVehicles:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Render All Vehicles" })
local VehicleDistance = MainVehicles:AddSlider({ Name = "Distance", Min = 0, Max = 2500, Default = 400, Rounding = 5 })

local ExitsContainer = VisualsTab:AddContainer({ Name = "Exits", Side = "Right", AutoSize = true })
local MainExits = ExitsContainer:AddTab("Exits")
local RenderExits = MainExits:AddToggle({ Name = "Enabled", Value = false, Tooltip = "Render All Exit Locations" })
local ExitDistance = MainExits:AddSlider({ Name = "Distance", Min = 0, Max = 2500, Default = 500, Rounding = 5 })

local SettingsTab = Window:AddTab({ Name = "Settings" })
local MenuContainer = SettingsTab:AddContainer({ Name = "Menu", Side = "Left", AutoSize = true })

MenuContainer:AddMenuBind({})
MenuContainer:AddSeparator()

MenuContainer:AddWatermark({
    Watermark = "Project Dih | ".. Version.. " | "..  Workspace:GetAttribute("MapName"),
    ShowFPS = true
})

MenuContainer:AddKeybindList({})
MenuContainer:AddButton({ Name = "Copy Discord Link", Callback = function() setclipboard("discord.gg/severe1") end })
MenuContainer:AddButton({ Name = "Unload", Unsafe = true, Callback = function() Library:Unload() end })

local Stored = {
    Drops  = {},
    Crates = {},
    Corpses = {},
    Vehicles = {},
    Exits = {},
    AI = {},
    Players = {},
    Humanoid = {},
    Health = {}
}

local Client = {
    Character = nil,
    HumanoidRootPart = nil,
    Position = Vector3.new(0, 0, 0)
}

local function GetDistance2D(A, B)
    local DeltaX = A.X - B.X
    local DeltaY = A.Y - B.Y
    return math.sqrt(DeltaX * DeltaX + DeltaY * DeltaY)
end

local function GetClosestEntity()
    local Entities = {}
    local MousePosition = getmouseposition()
    local ClosestEntity = nil
    local ClosestDistance = 100

    for _, Player in pairs(Stored.Players) do
        table.insert(Entities, Player)
    end

    for _, AI in pairs(Stored.AI) do
        table.insert(Entities, AI)
    end
    
    for _, Entity in pairs(Entities) do
        if Entity.ClassName == "Player" then
            if Entity ~= LocalPlayer and Entity.Character then
                local Character = Entity.Character
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                
                if HumanoidRootPart then
                    local Screen, OnScreen = Camera:WorldToScreenPoint(HumanoidRootPart.Position)
                    
                    if OnScreen then
                        local Distance = GetDistance2D(Vector2.new(MousePosition.X, MousePosition.Y), Vector2.new(Screen.X, Screen.Y))
                        
                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            ClosestEntity = Entity
                        end
                    end
                end
            end
        elseif Entity.ClassName == "Model" then
            if Entity then
                local HumanoidRootPart = Entity:FindFirstChild("HumanoidRootPart")
                
                if HumanoidRootPart then
                    local Screen, OnScreen = Camera:WorldToScreenPoint(HumanoidRootPart.Position)
                    
                    if OnScreen then
                        local Distance = GetDistance2D(Vector2.new(MousePosition.X, MousePosition.Y), Vector2.new(Screen.X, Screen.Y))
                        
                        if Distance < ClosestDistance then
                            ClosestDistance = Distance
                            ClosestEntity = Entity
                        end
                    end
                end
            end
        end
    end
    
    return ClosestEntity
end

local function GetWeapon(Character)
    if not Character then return "None" end

    local Instance = Character:FindFirstChild("Holding")
    
    if Instance and Instance.ClassName == "ObjectValue" and Instance.Value then
        if Instance.Value.Name and type(Instance.Value.Name) == "string" then
            return Instance.Value.Name
        end
    end

    return "None"
end

local function GetClothing(Character)
    if not Character then return end
    local Mask, Head, Chestrig, Leg, Back, Glove = "None", "None", "None", "None", "None", "None"
    
    local Clothing = Character:FindFirstChild("Clothing")
    if Clothing then
        Mask = (Clothing.ClothingMask and Clothing.ClothingMask.Value and type(Clothing.ClothingMask.Value.Name) == "string" and Clothing.ClothingMask.Value.Name) or "None"
        Head = (Clothing.ClothingHeadware and Clothing.ClothingHeadware.Value and type(Clothing.ClothingHeadware.Value.Name) == "string" and Clothing.ClothingHeadware.Value.Name) or "None"
        Chestrig = (Clothing.ClothingChestRig and Clothing.ClothingChestRig.Value and type(Clothing.ClothingChestRig.Value.Name) == "string" and Clothing.ClothingChestRig.Value.Name) or "None"
        Leg = (Clothing.ClothingLegArmor and Clothing.ClothingLegArmor.Value and type(Clothing.ClothingLegArmor.Value.Name) == "string" and Clothing.ClothingLegArmor.Value.Name) or "None"
        Back = (Clothing.ClothingBackpack and Clothing.ClothingBackpack.Value and type(Clothing.ClothingBackpack.Value.Name) == "string" and Clothing.ClothingBackpack.Value.Name) or "None"
    end
    
    return Mask, Head, Chestrig, Leg, Back
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

        HumanoidRootPart = Model:FindFirstChild("HumanoidRootPart"),
    }
end

local function EntityData(Model, Parts)
	if not Model then return nil end 

	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	local Health = 100
	local MaxHealth = 100
	
	if Humanoid then
		Health = Humanoid.Health
		MaxHealth = Humanoid.MaxHealth
	end

	local Data = {
		Username = tostring(Model),
		Displayname = Model.Name,
		Userid = -1,
		Character = Model,
		PrimaryPart = Model.PrimaryPart or Parts.HumanoidRootPart,
		Humanoid = Humanoid or Model.PrimaryPart,
		Head = Parts.Head,
		Torso = Parts.UpperTorso,
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
		Toolname = Model:FindFirstChildOfClass("Model").Name,
		Teamname = "AI",
		Whitelisted = false,
		Archenemies = true,
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
	if not Player then return nil end

	local Character = Player.Character
	if not Character then return nil end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return nil end

	local Parts = GetBodyParts(Character)
	if not Parts then return nil end

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
		RigType = 1,
		Toolname = "Unknown",
		Teamname = Player.Team or "No Team",

		Whitelisted = false,
		Archenemies = false,

		Aimbot_Part = Parts.Head,
		Aimbot_TP_Part = Parts.Head,
		Triggerbot_Part = Parts.Head,

		Health = Health,
		MaxHealth = MaxHealth,

		body_parts_data = {
			{ name = "LowerTorso", part = Character:FindFirstChild("LowerTorso") },
			{ name = "LeftUpperLeg", part = Character:FindFirstChild("LeftUpperLeg") },
			{ name = "LeftLowerLeg", part = Character:FindFirstChild("LeftLowerLeg") },
			{ name = "RightUpperLeg", part = Character:FindFirstChild("RightUpperLeg") },
			{ name = "RightLowerLeg", part = Character:FindFirstChild("RightLowerLeg") },
			{ name = "LeftUpperArm", part = Character:FindFirstChild("LeftUpperArm") },
			{ name = "LeftLowerArm", part = Character:FindFirstChild("LeftLowerArm") },
			{ name = "RightUpperArm", part = Character:FindFirstChild("RightUpperArm") },
			{ name = "RightLowerArm", part = Character:FindFirstChild("RightLowerArm") },
		},

		full_body_data = {
			{ name = "Head", part = Character:FindFirstChild("Head") },
			{ name = "UpperTorso", part = Character:FindFirstChild("UpperTorso") },
			{ name = "LowerTorso", part = Character:FindFirstChild("LowerTorso") },
			{ name = "HumanoidRootPart", part = Character:FindFirstChild("HumanoidRootPart") },

			{ name = "LeftUpperArm", part = Character:FindFirstChild("LeftUpperArm") },
			{ name = "LeftLowerArm", part = Character:FindFirstChild("LeftLowerArm") },
			{ name = "LeftHand", part = Character:FindFirstChild("LeftHand") },

			{ name = "RightUpperArm", part = Character:FindFirstChild("RightUpperArm") },
			{ name = "RightLowerArm", part = Character:FindFirstChild("RightLowerArm") },
			{ name = "RightHand", part = Character:FindFirstChild("RightHand") },

			{ name = "LeftUpperLeg", part = Character:FindFirstChild("LeftUpperLeg") },
			{ name = "LeftLowerLeg", part = Character:FindFirstChild("LeftLowerLeg") },
			{ name = "LeftFoot", part = Character:FindFirstChild("LeftFoot") },

			{ name = "RightUpperLeg", part = Character:FindFirstChild("RightUpperLeg") },
			{ name = "RightLowerLeg", part = Character:FindFirstChild("RightLowerLeg") },
			{ name = "RightFoot", part = Character:FindFirstChild("RightFoot") },
		},
	}

	return tostring(Character), Data
end

local function UpdateClient()
    local Character = LocalPlayer and LocalPlayer.Character
    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart and HumanoidRootPart.Parent then
            Client.Character = Character
            Client.HumanoidRootPart = HumanoidRootPart
            Client.Position = HumanoidRootPart.Position
            return true
        end
    end
    Client.Character = nil
    Client.HumanoidRootPart = nil
    return false
end

local function CrateValid(Name)
    local Selected = CrateFilter.Value

    if not next(Selected) then
        return true
    end

    for Category, Enabled in pairs(Selected) do
        if Enabled then
            local CrateList = Crates[Category]
            if CrateList then
                for _, CrateName in ipairs(CrateList) do
                    if Name == CrateName then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function ItemValid(Name)
    local Selected = DropFilter.Value

    if not next(Selected) then
        return true
    end

    for Category, Enabled in pairs(Selected) do
        if Enabled then
            local ItemList = Items[Category]
            if ItemList then
                for _, ItemName in ipairs(ItemList) do
                    if Name == ItemName then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function CrateItemValid(Name)
    local Selected = InventoryFilter.Value

    if not next(Selected) then
        return true
    end

    for Category, Enabled in pairs(Selected) do
        if Enabled then
            local ItemList = Items[Category]
            if ItemList then
                for _, ItemName in ipairs(ItemList) do
                    if Name == ItemName then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function Cache()
    if not UpdateClient() then return end
    local ClientPosition = Client.Position
    
    local function Process(Enabled, Storage, MaxDistance, Validator)
        if not Enabled then return end
        
        for Key, Data in pairs(Storage) do
            if not Key.Parent or not Data.Object or not Data.Object.Parent then Storage[Key] = nil elseif Validator and not Validator(Key) then Storage[Key] = nil elseif vector.magnitude(ClientPosition - Data.Object.Position) > MaxDistance then Storage[Key] = nil end
        end
    end
    
    if RenderDrops.Value then
        local Maximum = DropDistance.Value
        Process(true, Stored.Drops, Maximum, function(Drop) return ItemValid(Drop.Name) end)
        
        if Dropped then
            for _, Drop in ipairs(Dropped:GetChildren()) do
                if Drop.ClassName == "Model" and not Drop:FindFirstChild("Head") and not Stored.Drops[Drop] then
                    local Object = Drop.PrimaryPart
                    if Object and vector.magnitude(ClientPosition - Object.Position) <= Maximum and ItemValid(Drop.Name) then
                        Stored.Drops[Drop] = { Item = Drop, Object = Object, Name = Drop.Name }
                    end
                end
            end
        end
    end
    
    if RenderCrates.Value then
        local Maximum = CrateDistance.Value
        
        for Crate, Data in pairs(Stored.Crates) do
            if not Crate.Parent or not CrateValid(Crate.Name) then
                Stored.Crates[Crate] = nil
            else
                local Object = Crate.PrimaryPart
                if not Object or vector.magnitude(ClientPosition - Object.Position) > Maximum then
                    Stored.Crates[Crate] = nil
                else
                    Data.Inventory = {}
                    if DisplayInventory.Value then
                        local Inv = Crate:FindFirstChild("Inventory")
                        if Inv then
                            for _, Item in ipairs(Inv:GetChildren()) do
                                if CrateItemValid(Item.Name) then
                                    table.insert(Data.Inventory, Item.Name)
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if Containers then
            local function AddCrate(Crate)
                if not Stored.Crates[Crate] and Crate:GetAttribute("CanSpawnLoot") then
                    local Object = Crate.PrimaryPart
                    if Object then
                        local Distance = vector.magnitude(ClientPosition - Object.Position)
                        local Name = Crate:GetAttribute("DisplayName") or Crate.Name
                        if Distance <= Maximum and CrateValid(Crate.Name) then
                            local FilteredItems = {}
                            if DisplayInventory.Value then
                                local Inv = Crate:FindFirstChild("Inventory")
                                if Inv then
                                    for _, Item in ipairs(Inv:GetChildren()) do
                                        if CrateItemValid(Item.Name) then
                                            table.insert(FilteredItems, Item.Name)
                                        end
                                    end
                                end
                            end
                            Stored.Crates[Crate] = { Item = Crate, Object = Object, Name = Name, Inventory = FilteredItems }
                        end
                    end
                end
            end
            
            for _, Container in ipairs(Containers:GetChildren()) do
                if Container.ClassName == "Folder" then
                    for _, Crate in ipairs(Container:GetChildren()) do
                        AddCrate(Crate)
                    end
                elseif Container.ClassName == "Model" then
                    AddCrate(Container)
                end
            end
        end
    end
    
    if RenderCorpses.Value then
        local Maximum = CorpseDistance.Value
        Process(true, Stored.Corpses, Maximum, nil)
        
        if Dropped then
            for _, Corpse in ipairs(Dropped:GetChildren()) do
                if Corpse:FindFirstChild("Head") and Corpse.ClassName == "Model" and not Stored.Corpses[Corpse] then
                    local Object = Corpse.PrimaryPart
                    if Object and vector.magnitude(ClientPosition - Object.Position) <= Maximum then
                        Stored.Corpses[Corpse] = {
                            Item = Corpse,
                            Object = Object,
                            Name = Corpse:GetAttribute("DisplayName") or Corpse.Name
                        }
                    end
                end
            end
        end
    end
    
    if RenderVehicles.Value then
        local Maximum = VehicleDistance.Value
        
        for Vehicle, Data in pairs(Stored.Vehicles) do
            if not Vehicle.Parent then
                Stored.Vehicles[Vehicle] = nil
            else
                local Body = Vehicle:FindFirstChild("Body")
                local Object = Body and Body.PrimaryPart
                if not Object or vector.magnitude(ClientPosition - Object.Position) > Maximum then
                    Stored.Vehicles[Vehicle] = nil
                end
            end
        end
        
        if Vehicles then
            for _, Vehicle in ipairs(Vehicles:GetChildren()) do
                if Vehicle.ClassName == "Model" and not Stored.Vehicles[Vehicle] then
                    local Body = Vehicle:FindFirstChild("Body")
                    local Object = Body and Body.PrimaryPart
                    if Object and vector.magnitude(ClientPosition - Object.Position) <= Maximum then
                        local Name = Vehicle.Name.. " [".. Vehicle:GetAttribute("VehicleType").. "]"
                        Stored.Vehicles[Vehicle] = { Item = Vehicle, Object = Object, Name = Name }
                    end
                end
            end
        end
    end
    
    if RenderExits.Value then
        local Maximum = ExitDistance.Value
        Process(true, Stored.Exits, Maximum, nil)
        
        if ExitLocations then
            for _, Exit in ipairs(ExitLocations:GetChildren()) do
                if Exit.ClassName == "Part" and not Stored.Exits[Exit] then
                    if vector.magnitude(ClientPosition - Exit.Position) <= Maximum then
                        Stored.Exits[Exit] = {
                            Item = Exit,
                            Object = Exit,
                            Name = "Exit Location"
                        }
                    end
                end
            end
        end
    end
end

local function Render()
    if not Client.HumanoidRootPart then return end
    
    if RenderDrops.Value then
        for _, Data in pairs(Stored.Drops) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    if RenderDropsHighlight.Value then
                        Module.Highlight(Interface.Coloring.Border.Inner, Object, { Outline = false, OutlineColor = Color3.fromRGB(0, 0, 0), OutlineThickness = 1, Inline = false, InlineColor = Color3.fromRGB(0, 0, 0), InlineThickness = 1, Fill = true, FillColor = Interface.Coloring.Accent, FillOpacity = 1})
                    end
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, Data.Name, true, "Proggy")
                end
            end
        end
    end

    if RenderCrates.Value then
        for _, Data in pairs(Stored.Crates) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    if RenderCratesHighlight.Value then
                        Module.Highlight(Interface.Coloring.Border.Inner, Object, { Outline = false, OutlineColor = Color3.fromRGB(0, 0, 0), OutlineThickness = 1, Inline = false, InlineColor = Color3.fromRGB(0, 0, 0), InlineThickness = 1, Fill = true, FillColor = Interface.Coloring.Accent, FillOpacity = 1})
                    end
                    
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, Data.Name, true, "Proggy")
                    
                    if DisplayInventory.Value and Data.Inventory and #Data.Inventory > 0 then
                        local InventoryText = "[" .. table.concat(Data.Inventory, ", ") .. "]"
                        local InventoryScreen = Vector2.new(Screen.X, Screen.Y + 15)
                        DrawingImmediate.OutlinedText(InventoryScreen, 13, Color3.fromRGB(255, 255, 150), 1, InventoryText, true, "Proggy")
                    end
                end
            end
        end
    end

    if RenderCorpses.Value then
        for _, Data in pairs(Stored.Corpses) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    if RenderCorpsesHighlight.Value then
                        Module.Highlight(Interface.Coloring.Border.Inner, Data.Item, { Outline = false, OutlineColor = Color3.fromRGB(0, 0, 0), OutlineThickness = 1, Inline = false, InlineColor = Color3.fromRGB(0, 0, 0), InlineThickness = 1, Fill = true, FillColor = Interface.Coloring.Accent, FillOpacity = 1})
                    end
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, Data.Name..  "'s Corpse", true, "Proggy")
                end
            end
        end
    end

    if RenderVehicles.Value then
        for _, Data in pairs(Stored.Vehicles) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(255, 255, 255), 1, Data.Name, true, "Proggy")
                end
            end
        end
    end

    if RenderExits.Value then
        for _, Data in pairs(Stored.Exits) do
            local Object = Data.Object
            if Object and Object.Parent then
                local Screen, OnScreen = Camera:WorldToScreenPoint(Object.Position)
                if OnScreen then
                    DrawingImmediate.OutlinedText(Screen, 13, Color3.fromRGB(0, 255, 100), 1, Data.Name, true, "Proggy")
                end
            end
        end
    end
end

task.spawn(function()
	while true do
		task.wait(0.5)
        Cache()

		local Seen = {}
		
		local CurrentAI = Zones and Zones:GetChildren() or {}

		for _, Zone in ipairs(CurrentAI) do
			pcall(function()
				for _, NPC in ipairs(Zone:GetChildren()) do
					pcall(function()
						if typeof(NPC) ~= "Instance" or NPC.ClassName ~= "Model" then return end

						local Humanoid = NPC:FindFirstChildOfClass("Humanoid")
						if not Humanoid then return end

						local HumanoidRootPart = NPC:FindFirstChild("HumanoidRootPart")
						if not HumanoidRootPart then return end

						if NPC.PrimaryPart ~= HumanoidRootPart then return end

						local Parts = GetBodyParts(NPC)
						if not Parts or not Parts.HumanoidRootPart then return end

						local Key = tostring(NPC)

						if not Stored.AI[Key] then
							local ID, Data = EntityData(NPC, Parts)
							if ID and Data and add_model_data(Data, ID) then
								Stored.AI[ID] = NPC
							end
						else
							edit_model_data({Health = Humanoid.Health}, Key)
						end

						Seen[Key] = true
					end)
				end
			end)
		end

	    for _, Player in ipairs(Players:GetChildren()) do
		    pcall(function()
		        if Player and Player ~= LocalPlayer then
				    local Character = Player.Character
				    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				    if Humanoid and Character ~= Client.Character then
                        local Weapon = GetWeapon(Character)
					    local Key = tostring(Character)
					    local Parts = GetBodyParts(Character)

					    if Parts and Parts.HumanoidRootPart then
						    if is_team_check_active() then
						    	if Player.Team == LocalPlayer.Team then
								    if Stored.Players[Key] then
								    	local ID = tostring(Character)
								    	remove_model_data(ID)
								    	Stored.Players[ID] = nil
								    end
								    Seen[Key] = nil
						    	else
								    if not Stored.Players[Key] then
									    local ID, Data = GetPlayerData(Player)
									    if ID and Data and add_model_data(Data, ID) then
									    	Stored.Players[ID] = Character
									    end
								    else
								    	edit_model_data({ Health = Humanoid.Health }, Key)
							    	end
							    	Seen[Key] = true
						    	end
					    	else
						    	if not Stored.Players[Key] then
								    local ID, Data = GetPlayerData(Player)
								    if ID and Data and add_model_data(Data, ID) then
								        Stored.Players[ID] = Character
								    end
								else
									edit_model_data({ Health = Humanoid.Health }, Key)
								end
								Seen[Key] = true
							end
						end
					end
				end
			end)
		end

		for ID, Model in pairs(Stored.AI) do
			pcall(function()
				if not Model or not Model.Parent or not Seen[ID] then
					remove_model_data(ID)
					Stored.AI[ID] = nil
				end
			end)
		end

		for ID, Model in pairs(Stored.Players) do
			pcall(function()
				if not Model or not Model.Parent or not Seen[ID] then
					remove_model_data(ID)
					Stored.Players[ID] = nil
				end
			end)
		end
	end
end)

local function DrawWindow(Position, Character, Transparency)
    local X = Position.X
    local Y = Position.Y
    local Width = Interface.Dimensions.Width
    local Height = Interface.Dimensions.Height
    local Coloring = Interface.Coloring
    local ContentX = X + 6
    local ContentY = Y + 6
    local ContentW = Width - 12
    local ContentH = Height - 12

    DrawingImmediate.FilledRectangle(Vector2.new(X, Y), Vector2.new(Width, Height), Coloring.Border.Outer, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(X + 2, Y + 2), Vector2.new(Width - 4, Height - 4), Coloring.Border.Inner, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(X + 3, Y + 3), Vector2.new(Width - 6, Height - 6), Coloring.Accent, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(X + 4, Y + 4), Vector2.new(Width - 8, Height - 8), Coloring.Background.Main, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(ContentX, ContentY), Vector2.new(ContentW, ContentH), Coloring.Background.Content, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(ContentX + 6, ContentY + 5), Vector2.new(ContentW - 12, 1), Coloring.Accent, Transparency)

    local WeaponName = GetWeapon(Character) or "None"
    if typeof(WeaponName) ~= "string" then WeaponName = tostring(WeaponName or "") end
    if WeaponName == "" or WeaponName == "None" then WeaponName = "No Weapon" end
    DrawingImmediate.OutlinedText(Vector2.new(X + Width / 2, ContentY + 12), Interface.MediumText, Coloring.Text, Transparency, WeaponName, true, Interface.Font)

    local CurrentHealth = 0
    local MaxHealth = 100
    if Character then
        local Hum = Stored.Humanoid[Character]
        if not Hum or not Hum.Parent then
            Hum = Character:FindFirstChildOfClass("Humanoid")
            Stored.Humanoid[Character] = Hum
        end
        if Hum then
            if Stored.Health[Character] == nil then
                Stored.Health[Character] = tonumber(Hum.MaxHealth) or 100
            end
            MaxHealth = Stored.Health[Character] or 100
            CurrentHealth = tonumber(Hum.Health) or 0
        end
    end
    
    local Percent = math.clamp((MaxHealth == 0) and 0 or (CurrentHealth / MaxHealth), 0, 1)
    local BarW = ContentW - 18
    local BarH = Interface.SmallText + 4
    local BarX = ContentX + 9
    local BarY = ContentY + ContentH - (BarH + 6)
    local FillW = math.floor((BarW - 4) * Percent)
    if Percent > 0 and FillW < 2 then FillW = 2 end

    local LocalCharacter = LocalPlayer.Character
    if LocalCharacter then
        local LocalHumanoid = LocalCharacter:FindFirstChildOfClass("Humanoid")
        if LocalHumanoid then
            local LocalHealth = LocalHumanoid.Health
            local Indication = "Even"
            local IndicationColor = Coloring.Text
            
            if LocalHealth > CurrentHealth then
                Indication = "You're Winning!"
                IndicationColor = Color3.fromRGB(0, 255, 0)
            elseif LocalHealth < CurrentHealth then
                Indication = "You're Losing!"
                IndicationColor = Color3.fromRGB(255, 0, 0)
            end
            
            local TextY = BarY - 15
            DrawingImmediate.OutlinedText(Vector2.new(BarX, TextY), Interface.SmallText, IndicationColor, Transparency, Indication, false, Interface.Font)
        end
    end

    DrawingImmediate.FilledRectangle(Vector2.new(BarX, BarY), Vector2.new(BarW, BarH), Color3.fromRGB(18, 18, 18), Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(BarX + 1, BarY + 1), Vector2.new(BarW - 2, BarH - 2), Color3.fromRGB(28, 28, 28), Transparency)
    if FillW > 0 then DrawingImmediate.FilledRectangle(Vector2.new(BarX + 2, BarY + 2), Vector2.new(FillW, BarH - 4), Coloring.Accent, Transparency) end

    local HealthText = tostring(math.floor(CurrentHealth) .. "/" .. tostring(MaxHealth))
    DrawingImmediate.OutlinedText(Vector2.new(BarX + BarW / 2, BarY + (BarH / 2) - 5), Interface.SmallText, Coloring.Text, Transparency, HealthText, true, Interface.Font)
end

local function DrawClothingWindow(Position, Character, Transparency)
    local X = Position.X
    local Y = Position.Y
    local Width = 400
    local Height = 70
    local Coloring = Interface.Coloring
    local ContentX = X + 6
    local ContentY = Y + 6
    local ContentW = Width - 12
    local ContentH = Height - 12

    DrawingImmediate.FilledRectangle(Vector2.new(X, Y), Vector2.new(Width, Height), Coloring.Border.Outer, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(X + 2, Y + 2), Vector2.new(Width - 4, Height - 4), Coloring.Border.Inner, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(X + 3, Y + 3), Vector2.new(Width - 6, Height - 6), Coloring.Accent, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(X + 4, Y + 4), Vector2.new(Width - 8, Height - 8), Coloring.Background.Main, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(ContentX, ContentY), Vector2.new(ContentW, ContentH), Coloring.Background.Content, Transparency)
    DrawingImmediate.FilledRectangle(Vector2.new(ContentX + 6, ContentY + 5), Vector2.new(ContentW - 12, 1), Coloring.Accent, Transparency)

    local Mask, Head, Chestrig, Leg, Back = GetClothing(Character)
    
    local ClothingItems = {
        {Name = "Mask", Value = Mask or "None"},
        {Name = "Helmet", Value = Head or "None"},
        {Name = "Rig", Value = Chestrig or "None"},
        {Name = "Backpack", Value = Back or "None"},
        {Name = "Legs", Value = Leg or "None"}
    }
    
    local BoxWidth = 70
    local BoxHeight = 30
    local Spacing = 6
    local StartX = ContentX + 9
    local LabelY = ContentY + 10
    local BoxY = ContentY + 22
    
    local function Shorten(String, Maximum)
        if #String <= Maximum then return String end
        return string.sub(String, 1, Maximum - 2) .. ".."
    end
    
    for Index, Item in ipairs(ClothingItems) do
        local BoxX = StartX + ((Index - 1) * (BoxWidth + Spacing))
        
        DrawingImmediate.OutlinedText(Vector2.new(BoxX + BoxWidth / 2, LabelY), Interface.SmallText, Coloring.Text, Transparency, Item.Name, true, Interface.Font)
        DrawingImmediate.FilledRectangle(Vector2.new(BoxX, BoxY), Vector2.new(BoxWidth, BoxHeight), Color3.fromRGB(18, 18, 18), Transparency)
        DrawingImmediate.FilledRectangle(Vector2.new(BoxX + 1, BoxY + 1), Vector2.new(BoxWidth - 2, BoxHeight - 2), Color3.fromRGB(28, 28, 28), Transparency)
        DrawingImmediate.OutlinedText(Vector2.new(BoxX + BoxWidth / 2, BoxY + BoxHeight / 2 - 5), Interface.SmallText, Coloring.Text, Transparency, Shorten(Item.Value, 11), true, Interface.Font)
    end
end

RunService.Render:Connect(function()
    Render()
    
    local Entity = GetClosestEntity()
    if not Entity then return end
    
    local Target
    if Entity.ClassName == "Player" then
        if not Entity.Character then return end
        Target = Entity.Character
    elseif Entity.ClassName == "Model" then
        local HumanoidRootPart = Entity:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then return end
        Target = Entity
    else
        return
    end
    
    local ClothingWindowPosition = Vector2.new((Camera.ViewportSize.X / 2) - 200, Camera.ViewportSize.Y - Interface.Dimensions.Height - 180)
    DrawClothingWindow(ClothingWindowPosition, Target, 1)
    
    local WindowPosition = Vector2.new((Camera.ViewportSize.X / 2) - (Interface.Dimensions.Width / 2), Camera.ViewportSize.Y - Interface.Dimensions.Height - 100)
    DrawWindow(WindowPosition, Target, 1)
end)
