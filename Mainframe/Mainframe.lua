-- Make Crafting Knowledge Folder
if not fs.isDir("CraftingKnowledge") then
    fs.makeDir("CraftingKnowledge")
end

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
    BootMainframe()
    if MasterMainframeID == MyID then
        ListenResond() 
    else
        term.clear()
        term.setCursorPos(1, 1)
        print("Mainframe in Backup Mode")
        parallel.waitForAny(ListenForFailure,MainframeCheckIn) -- end if Receives Failure message, or Check in fails
    end
end