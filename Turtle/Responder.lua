if term.isColor() then -- if advanced
    if not multishell then -- and doesnt have access to Multishell 
        --we are in a multishell so Require dont work
        GF , TF = ... -- you need to pass them in to multi shell
    else
        --not in a muiltishell so require the APIs 
        GF = require("/LocalGit/APIs/GF")
        TF = require("/LocalGit/APIs/TF")
    end
else
    --not in a advanced pc so just require the APIs 
    GF = require("/LocalGit/APIs/GF")
    TF = require("/LocalGit/APIs/TF")
end



if GF ~= nil and TF ~= nil then -- APIs are required
    MasterMainframeID = nil
    MyID = os.getComputerID()
    while true do
        parallel.waitForAll(TF.Listen, TF.Respond) 
    end
else
    error("Requires GF and TF to be passed to Program")
end