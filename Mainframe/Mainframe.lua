
-- Await Mainframe Connection
local Modem = peripheral.find("modem")

-- Make Crafting Knowledge Folder
if not fs.isDir("CraftingKnowledge") then
    fs.makeDir("CraftingKnowledge")
end

-- Get the Mainframe Functions
if fs.exists("MF.lua") then
    TB = require("MF")
else
    shell.run("pastebin", "get", "????????","MF.lua")
    TB = require("MF")
end




print("test")


