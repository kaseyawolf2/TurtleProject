-- download and set up
if not fs.exists("bbpack") then -- BBpack has a github Downloader
    shell.run("pastebin", "get", "cUYTGbpb","bbpack")
end
--Mount Github Repo
shell.run("bbpack", "mount", "https://github.com/kaseyawolf2/TurtleProject","/Install")
--Remove old files and make a local copy from the mounted Repo 
fs.delete("LocalGit")
fs.copy("/Install/","LocalGit")
-- Make the Mainframe run on Startup
fs.delete("Startup.lua")
file = fs.open("Startup.lua","w")
if not turtle then -- check if a turtle or PC
    file.write([[
shell.setAlias("Mainframe", "/LocalGit/Turtle/Mainframe.lua")
shell.setAlias("Update", "/LocalGit/Installer/Installer.lua")
shell.run("Mainframe.lua")
]])
    file.close()
else-- if a turtle
    file.write([[
shell.setAlias("Starter", "/LocalGit/Turtle/Starter.lua")
shell.setAlias("Update", "/LocalGit/Installer/Installer.lua")
shell.run("Starter.lua")
]])
    file.close()
end 
os.reboot()