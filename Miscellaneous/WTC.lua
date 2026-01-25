--! optimize 2
loadstring(game:HttpGet("https://raw.githubusercontent.com/Sploiter13/severefuncs/refs/heads/main/merge.lua"))();
local Load = luau.load(game:HttpGet("https://raw.githubusercontent.com/DCHARLESAKAMRGREEN/Severe-Luas/main/Libraries/Pseudosynonym.lua"))
local Version = "1.0.0"

local Offsets = {
    TextLabelText = 3648
}

local Workspace = game:GetService("Workspace")
local Tycoons = Workspace.Tycoon.Tycoons
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = Load()
local Window = Library:CreateWindow({
    Title = "War Tycoon | "..Version,
    Tag = LocalPlayer.DisplayName,
    Keybind = "Alt",
    AutoShow = true
})

--//Assistants Tab\\--
local AssistantsTab = Window:AddTab({Name = "Assistants"})
local Main = AssistantsTab:AddContainer({Name = "Main",Side = "Left",AutoSize = true})
local Automation = Main:AddTab("Automation")
local AutomateCollection = Automation:AddToggle({Name = "Automate Collection",Value = false,Tooltip = "Automatically Collect Cash"})
local AutomateCompletion = Automation:AddToggle({Name = "Automate Completion",Value = false,Tooltip = "Automatically Complete Tycoon"})

--//Settings Tab\\--
local SettingsTab = Window:AddTab({Name = "Settings"})
local MenuContainer = SettingsTab:AddContainer({Name = "Menu",Side = "Left",AutoSize = true})
MenuContainer:AddMenuBind({})
MenuContainer:AddSeparator()
MenuContainer:AddWatermark({Watermark = "Hello Croski",ShowFPS = true})
MenuContainer:AddKeybindList({})
MenuContainer:AddButton({Name = "Unload",Unsafe = true,Callback = function()Library:Unload()end})

local function GetCompletion()
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return 0 end

    local HUD = PlayerGui.UI.Container.HUD.Menu.HUD
    local Left = HUD:FindFirstChild("Left")
    if not Left then return 0 end

    local Completion = Left:FindFirstChild("TycoonCompletion")
    if not Completion then return 0 end

    local Bar = Completion:FindFirstChild("Bar")
    if not Bar then return end

    local Progress = Bar:FindFirstChild("BarProgressAmount")
    if not Progress then return end

    local Percentage = tostring(memory.readstring(Progress,Offsets.TextLabelText))
    local RealAmount = tonumber(Percentage:match("(%d+%.?%d*)"))
    return RealAmount or 0
end

local function GetCash()
    local Stats = LocalPlayer:FindFirstChild("leaderstats")
    if not Stats then return 0 end

    local Cash = Stats:FindFirstChild("Cash")
    if not Cash then return 0 end

    return Cash.Value or 0
end

local function GetRebirths()
    local Stats = LocalPlayer:FindFirstChild("leaderstats")
    if not Stats then return 0 end

    local Rebirths = Stats:FindFirstChild("Rebirths")
    if not Rebirths then return 0 end

    return Rebirths.Value or 0
end

local function GetPlot()
    for _,Plot in ipairs(Tycoons:GetChildren()) do
        if Plot:GetAttribute("Owner") == LocalPlayer.Name then
            return Plot
        end
    end
end

local function SetPosition(Object,Target)
    Object.Position = Target + vector.create(0.2,0.2,0.2)
end

local function AutoCollect()
    local Character = LocalPlayer.Character
    if not Character then return end

    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    local Plot = GetPlot()
    if not Plot then return end

    local Collector = Plot:FindFirstChild("Essentials") and Plot.Essentials:FindFirstChild("CollectorParts")
    local Object = Collector and Collector:FindFirstChild("Display")
    if Object then
        SetPosition(HRP,Object.Position)
    end
end

Automation:AddButton({Name = "Collect Cash",Unsafe = false,Callback = function()AutoCollect()end})

local function AutoComplete()
    if not AutomateCompletion.Value then return end

    local Character = LocalPlayer.Character
    if not Character then return end

    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    local Plot = GetPlot()
    if not Plot then return end

    local Items = Plot:FindFirstChild("UnpurchasedButtons")
    if not Items then return end

    local RebirthButtons,OilButtons,CashButtons = {},{},{}

    for _,Item in ipairs(Items:GetChildren()) do
        local ButtonType = Item:GetAttribute("ButtonType")
        local name = Item.Name or ""
        local Primary = Item:FindFirstChild("Gradient")

        if ButtonType == "Rebirth" then
            local Requirement = tonumber(Item:GetAttribute("RebirthRequirement"))
            if Requirement and Primary and GetRebirths() >= Requirement then
                RebirthButtons[#RebirthButtons+1] = {Pad = Primary,Req = Requirement}
            end
        elseif ButtonType == "Cash" then
            local Price = tonumber(Item:GetAttribute("Price"))
            if Price and Primary then
                if name:sub(1,3) == "Oil" then
                    OilButtons[#OilButtons+1] = {Pad = Primary,Price = Price}
                else
                    CashButtons[#CashButtons+1] = {Pad = Primary,Price = Price}
                end
            end
        end
    end

    if #RebirthButtons > 0 then
        table.sort(RebirthButtons,function(a,b)return a.Req < b.Req end)
        SetPosition(HRP,RebirthButtons[1].Pad.Position)
        return
    end

    if #OilButtons > 0 then
        table.sort(OilButtons,function(a,b)return a.Price < b.Price end)
        local Target = OilButtons[1]
        if GetCash() < Target.Price then
            AutoCollect()
            return
        end
        SetPosition(HRP,Target.Pad.Position)
        return
    end

    if #CashButtons == 0 then return end
    table.sort(CashButtons,function(a,b)return a.Price < b.Price end)

    local CheapestButton = CashButtons[1]
    if GetCash() < CheapestButton.Price then
        AutoCollect()
        return
    end

    SetPosition(HRP,CheapestButton.Pad.Position)
end

task.spawn(function()
    while true do
        if AutomateCollection.Value then
            AutoCollect()
        end
        task.wait(0.4)
    end
end)

task.spawn(function()
    while true do
        if AutomateCompletion.Value then
            AutoComplete()
            task.wait(0.5)
        end
        task.wait(0.4)
    end
end)

GetCompletion()
