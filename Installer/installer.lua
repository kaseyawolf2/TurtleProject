if not fs.exists("bbpack") then
    shell.run("pastebin", "get", "cUYTGbpb","bbpack")
end
 
shell.run("bbpack", "mount", "https://github.com/kaseyawolf2/TurtleProject","Install")
 
fs.delete("LocalGit")
fs.delete("Mainframe.lua")
fs.copy("Install/Mainframe/Mainframe.lua", "Mainframe.lua")
fs.copy("Install/Installer/Update.lua", "Update.lua")
fs.copy("Install/","LocalGit")
 
-- Make the Mainframe run on Startup
file = fs.open("Startup.lua","w")
file.write([[shell.run("Mainframe.lua")]])
file.close()
 
os.reboot()