--Search Inv For 
--4 Computers
--4 Modems
--1 Disk
--1 Disk Drive

TF = require("/LocalGit/APIs/TF")

--Check if enough Fuel
if type(turtle.getFuelLevel()) == "string" then -- if == string then the game is in no fuel mode so ignore the rest
    print("No-fuel mode")
else
    while turtle.getFuelLevel() < 350 do 
        --Find Fuel
        --refuel using 1
    end
end

--if no args were pass then ask for current XYZ and faceing
-- go up and place gps Cluster
--return to starting pos and check gps = pos
--Broadcast that GPS is online
--return to starters program