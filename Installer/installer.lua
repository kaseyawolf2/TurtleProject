term.clear()
term.setCursorPos(1, 1)
-- download and set up BBpack as it has a github Downloader
if not fs.exists("/LocalGit/ExternalPrograms/bbpack.lua") then -- if it has a local BBpack lets not download from pastebin
    print("No BBpack Downloading Now")
    shell.run("pastebin", "get", "cUYTGbpb","bbpack")
else
    print("BBpack Detected")
    --Make a Copy of BBpack since were about to delete LocalGit
    fs.copy("/LocalGit/ExternalPrograms/bbpack.lua","/bbpack")
end
--Mount Github Repo
shell.run("bbpack", "mount", "https://github.com/kaseyawolf2/TurtleProject","/Install")
--Remove old files and make a local copy from the mounted Repo 
fs.delete("/LocalGit")
fs.copy("/Install/","/LocalGit")
--Delete BBpack so less clutter
fs.delete("bbpack")
fs.delete(".bbpack.cfg")
-- Make the Mainframe run on Startup
fs.delete("/Startup.lua")
StartUp = [[
fs.delete("Installer")
shell.setAlias("Update", "/LocalGit/Installer/Installer.lua")
]]

if periphemu then
    StartUp = StartUp .. [[
periphemu.create("top","monitor")
]]
end

if not turtle then -- check if a turtle or PC
    StartUp = StartUp .. [[
shell.setAlias("Mainframe", "/LocalGit/Mainframe/Mainframe.lua")
shell.run("Mainframe")        
]]
else-- if a turtle
    StartUp = StartUp .. [[
shell.setAlias("Starter", "/LocalGit/Turtle/Starter.lua")
shell.run("Starter")
]]
end 
file = fs.open("/Startup.lua","w")
file.write(StartUp)
file.close()
os.reboot()