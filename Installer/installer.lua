-- This is the installer for the TurtleProject
term.clear()
term.setCursorPos(1, 1)

-- Check if BBpack is installed if not download it from paste bin
if fs.exists("/LocalGit/ExternalPrograms/bbpack.lua") then
    print("BBpack Detected")
    --Make a Copy of BBpack in the main directory 
    fs.copy("/LocalGit/ExternalPrograms/bbpack.lua","/bbpack")
else
    print("No copy of BBpack found, Downloading it Now")
    shell.run("pastebin", "get", "cUYTGbpb","bbpack")
end

--Mount Github Repo to the Git Folder
shell.run("bbpack", "mount", "https://github.com/kaseyawolf2/TurtleProject","/Git")


--Delete the old LocalGit
fs.delete("/LocalGit")

--Make a copy of the Github repo to the LocalGit Folder
fs.copy("/Git/","/LocalGit")


--Delete BBpack so less clutter
fs.delete("bbpack")
fs.delete(".bbpack.cfg")

--Move the Startup Folder from the LocalGit to the root directory
if fs.exists("/Startup") then
    fs.delete("/Startup")
end
fs.copy("/LocalGit/Startup","/Startup")

--Delete the launcher program from the pastebin
fs.delete("Installer")
os.reboot()