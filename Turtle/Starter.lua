GF = require("/LocalGit/APIs/GF")
DGPS = require("/LocalGit/APIs/DGPS")
TF = require("/LocalGit/APIs/TF")


term.clear()
print("Turtle Starter")

print("Connecting to Modem")
--Find Wireless Modem
HasWireless = false
while not HasWireless do
    term.clear()
    term.setCursorPos(1, 1)
    local ModList = peripheral.find("modem")
    if ModList ~= nil then
        if ModList.isWireless() then
            HasWireless = true
        end
    else
        if not TF.Equip("modem") then
            error("Please Attach a Wireless Modem")
        end
    end
end

print("Attempting to Connect to GPS System")
gpsConnection = false
while not gpsConnection do
    if gps.locate(5) ~= nil then
        gpsConnection = true
        print("GPS Detected")
    else
        --No GPS Connection Detected
        print("No GPS Detected")
        shell.run("LocalGit/ExternalPrograms/gps-deploy")
        
    end
    
end

DGPS.Start()
DGPS.Goto(-1918,68,1531,67)

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