if term.isColor() then -- if advanced
    if not multishell then -- and doesnt have access to Multishell 
        --we are in a multishell so Require dont work
        GF , MF = ... -- you need to pass them in to multi shell
    else
        --not in a muiltishell so require the APIs 
        GF = require("/LocalGit/APIs/GF")
        MF = require("/LocalGit/APIs/MF")
    end
else
    --not in a advanced pc so just require the APIs 
    GF = require("/LocalGit/APIs/GF")
    MF = require("/LocalGit/APIs/MF")
end



if GF ~= nil and MF ~= nil then -- APIs are required

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
else
    error("Requires GF and MF to be passed to Program")
end