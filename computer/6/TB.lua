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
if fs.exists("Functions.lua") then
    Functions = require("Functions")
else
    shell.run("pastebin", "get", "vUrS0uh1","Functions.lua")
    Functions = require("Functions")
end


-- "Global Vars"
KnowledgeList = {} 
    -- Ingredients
        -- Location, Slot, Count
    -- Result
        -- Location, Slot, Count

return TB