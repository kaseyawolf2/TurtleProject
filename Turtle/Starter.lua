GF = require("./LocalGit/APIs/GF")
TF = require("./LocalGit/APIs/TF")


-- await connection to Mainframe
-- if no mainframe then ask for one
-- download GPS Builder
-- Await resources for it
-- build it 
-- delete gps builder

local x  = GF.MainframeConnect()
print(x)