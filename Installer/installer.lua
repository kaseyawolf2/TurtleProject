if not turtle then -- check if a turtle or PC
    -- download and set up
    if not fs.exists("bbpack") then -- BBpack has a github Downloader
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
    fs.delete("Startup.lua")
    file = fs.open("Startup.lua","w")
    file.write([[shell.run("Mainframe.lua")]])
    file.close()
else-- if a turtle
    -- download and set up
    if not fs.exists("bbpack") then -- BBpack has a github Downloader
        shell.run("pastebin", "get", "cUYTGbpb","bbpack")
    end
    --Mount Github Repo
    shell.run("bbpack", "mount", "https://github.com/kaseyawolf2/TurtleProject","Install")
    --Remove old files and make a local copy from the mounted Repo 
    fs.delete("LocalGit")
    fs.delete("Starter.lua")
    fs.delete("Update.lua")
    fs.copy("Install/Turtle/Starter.lua", "Starter.lua")
    fs.copy("Install/Installer/Update.lua", "Update.lua")
    fs.copy("Install/","LocalGit")
    -- Make the turtle run on Startup
    fs.delete("Startup.lua")
    file = fs.open("Startup.lua","w")
    file.write([[shell.run("Starter.lua")]])
    file.close()
end 
os.reboot()