-- Get the General Functions
GF = require("APIs/GF")
MF = require("APIs/MF")
MD = require("APIs/MD")
AF = require("APIs/AF")

os.setComputerLabel("Mainframe")

--Since The Command and control Mainframe Requires a Wireless Modem
--We will check for one and open rednet if a wireless modem is found
--If not we will wait for one to be attached and then open rednet
HasWireless = false
while not HasWireless do
    term.clear()
    term.setCursorPos(1, 1)
    local modem = peripheral.find("modem")
    if modem ~= nil then
        if modem.isWireless() then
            HasWireless = true
            rednet.close()
            rednet.open(peripheral.getName(modem))
        end
    else
        print("Please Attach a Wireless Modem")
        local Event, side = os.pullEvent("peripheral")
    end
end
term.clear()
term.setCursorPos(1, 1)

if term.isColor() then
    print("Advanced PC starting Network Coordinator in a new tab")
    multishell.launch({},"Mainframe/NetworkCoordinator.lua",GF,AF,MF)
    multishell.launch({},"Mainframe/MonitorInterface.lua",MD,AF)
else
    print("Standard PC Starting Network Coordinator")
    shell.run("Mainframe/NetworkCoordinator.lua")
end
