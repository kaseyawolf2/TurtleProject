GF = require("LocalGit/APIs/GF")
MF = require("LocalGit/APIs/MF")

MasterMainframeID = nil
MyID = os.getComputerID()

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