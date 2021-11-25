GF = require("/LocalGit/APIs/GF")
TF = require("/LocalGit/APIs/TF")

while gpsConnection == false do
    if gps.locate(5) ~= nil then
        gpsConnection = true
    else
        --No GPS Connection Detected
        print("No GPS Detected")
        shell.run("LocalGit/ExternalPrograms/gps-deploy")
        
    end
    
end

--Connect to GPS System
    --If no GPS Download GPS Builder and build One

--Connect to Mainframe
    --if no mainframe then ask for one and wait

--Ask for Job From Mainframe
    --Go into Long Term Storage
        --Go to Storage Area and get put in to chest
    --Go into Short Term Storage
        --Holding Pen (1x1 Chunk)
        --Hold Postion
    --Become a Miner
    --Become a Crafter
    --Become a Builder
    --Become a Storage Bot