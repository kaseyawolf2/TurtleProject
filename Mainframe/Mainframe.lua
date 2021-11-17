-- Get the General Functions
GF = require("/LocalGit/APIs/GF")
MF = require("/LocalGit/APIs/MF")

os.setComputerLabel("Mainframe")

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
term.setCursorPos(1, 1)

if term.isColor() then
    print("Advanced PC starting Responder in a new tab")
    multishell.launch({},"/LocalGit/Mainframe/Responder.lua",GF,MF)
else
    print("Standard PC Starting Responder")
    shell.run("/LocalGit/Mainframe/Responder.lua")
end