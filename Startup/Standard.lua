
-- set an alias for the update command to the local git copy
shell.setAlias("Update", "/LocalGit/Installer/Installer.lua")


-- If using CraftOS-PC (Computercraft emulator) then set up the monitor for it to use
if periphemu then
    periphemu.create("top","monitor")
    shell.run("/LocalGit/Mainframe/MonitorInterface")  
end

if not turtle then -- check if a turtle or PC
    shell.setAlias("Starter", "/LocalGit/Turtle/Starter.lua")
    shell.run("Starter")     
else-- if PC load the C2 program
    shell.setAlias("Mainframe", "/LocalGit/Mainframe/Mainframe.lua")
    shell.run("Mainframe")
end 