
if not fs.exists("bbpack") then
    shell.run("pastebin", "get", "cUYTGbpb","bbpack")
end

shell.run("bbpack", "mount", "https://github.com/kaseyawolf2/TurtleProject","install")

--fs.copy("install/Mainframe/", "/rom/")


-- Make the Mainframe run on Startup
if not fs.exists("Startup.lua") then
    file = fs.open("Startup.lua","w")
    file.write([[shell.run("Mainframe.lua")]])
    file.close()
end



os.reboot()