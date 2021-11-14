if not turtle then
    -- set up mainframe
    if not fs.exists("bbpack") then
        shell.run("pastebin", "get", "cUYTGbpb","bbpack")
    end
    --Mount Github Repo
    shell.run("bbpack", "mount", "https://github.com/kaseyawolf2/TurtleProject","Install")
    --Remove old files and make a local copy from the mounted Repo 
    fs.delete("LocalGit")
    fs.delete("Mainframe.lua")
    fs.delete("Update.lua")
    fs.copy("Install/Mainframe/Mainframe.lua", "Mainframe.lua")
    fs.copy("Install/Installer/Update.lua", "Update.lua")
    fs.copy("Install/","LocalGit")
    -- Make the Mainframe run on Startup
    file = fs.open("Startup.lua","w")
    file.write([[shell.run("Mainframe.lua")]])
    file.close()
else-- if a turtle
    -- await connection to Mainframe 
    -- if no mainframe then ask for one
    -- download GPS Builder
    -- Await resources for it
    -- build it 
    -- delete gps builder



end 
os.reboot()
