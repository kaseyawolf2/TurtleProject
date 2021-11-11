local TB = {} -- Turtle Basics

-- General Requirements

-- Get DGPS API
if fs.exists("DGPS.lua") then
    DGPS = require("DGPS")
else
    shell.run("pastebin", "get", "wxtU0Ajy","DGPS.lua")
    DGPS = require("DGPS")
end
-- Get Functions API
if fs.exists("GF.lua") then
    GF = require("GF")
else
    shell.run("pastebin", "get", "vUrS0uh1","GF.lua")
    GF = require("GF")
end

-- Make Crafting Knowledge Folder
if not fs.isDir("CraftingKnowledge") then
    fs.makeDir("CraftingKnowledge")
end

-- "Global Vars"
-- textutils.serialize(
--Knowledge
    -- Ingredients
        -- Location, Slot, Count, Itemname
    -- Result
        -- Location, Slot, Count, Itemname

        return TB