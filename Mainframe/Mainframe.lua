-- Get the General Functions
GF = require("LocalGit/APIs/GF")
MF = require("LocalGit/APIs/MF")

os.setComputerLabel("Mainframe")

MasterMainframeID = nil
MyID = os.getComputerID()


-- Find/Await A Modem and open Rednet
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
        print("Please Attach a Wireless Modem")
        local Event, side = os.pullEvent("peripheral")
    end
end
term.clear()
rednet.close()
sleep(1)
rednet.open(peripheral.getName(peripheral.find("modem")))

term.setCursorPos(1, 1)

while true do
    MF.BootMainframe()
    if MasterMainframeID == MyID then
        MF.ListenRespond() 
    else
        term.clear()
        term.setCursorPos(1, 1)
        print("Mainframe in Backup Mode")
        MF.BackupMode()
    end
end