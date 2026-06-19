local success, response = pcall(function()
    return game:HttpGet("https://offsets.imtheo.lol/Offsets.hpp")
end)

if not success then
    send_notification("Failed to fetch: " .. tostring(response), "warning")
    return nil
end

local Offsets = {}
local CurrentSpace = nil

for Line in response:gmatch("[^\n]+") do
    local Namespace = Line:match("^%s*namespace%s+(%w+)%s*{")
    if Namespace then
        CurrentSpace = Namespace
        Offsets[Namespace] = Offsets[Namespace] or {}
    end

    if Line:match("^%s*}") and CurrentSpace then
        CurrentSpace = nil
    end

    if CurrentSpace then
        local Name, Hex = Line:match("inline%s+constexpr%s+uintptr_t%s+(%w+)%s*=%s*(0x%x+)")
        if Name and Hex then
            Offsets[CurrentSpace][Name] = tonumber(Hex)
        end
    end
end

return Offsets
