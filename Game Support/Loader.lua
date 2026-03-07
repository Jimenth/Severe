repeat task.wait() until isrbxactive()

local Games = {
    [1054526971] = "Blackhawk.lua",
    [4283416256] = "Deadline.lua",
    [2491559356] = "Tank.lua",
    [104984488] = "Traitor.lua",
    [807930589] = "West.lua"
}

local Branch = "main"
local Script = Games[game.GameId] or "Global.lua"

loadstring(game:HttpGet("https://raw.githubusercontent.com/Jimenth/Severe/refs/heads/" .. Branch .. "/Game%20Support/" .. Script))()
