-- Get the Base Turtle
if fs.exists("TB.lua") then
    TB = require("TB")
else
    shell.run("pastebin", "get", "aERjx7BE","TB.lua")
    TB = require("TB")
end

-- ToolCheck1,ToolCheck2 = turtle.digUp()
-- if ToolCheck2 == "No tool to dig with" then
--     print("no tool")
-- end

print(TF.CanSwitchClass("miner"))