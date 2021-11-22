if term.isColor() then -- if advanced
    if not multishell then -- and doesnt have access to Multishell 
        --we are in a multishell so Require dont work
        MD = ... -- you need to pass them in to multi shell
    else
        --not in a muiltishell so require the APIs 
        
        MD = require("/LocalGit/APIs/MD")
    end
else
    --not in a advanced pc so just require the APIs 
    
    MD = require("/LocalGit/APIs/MD")
end

MD.Draw()