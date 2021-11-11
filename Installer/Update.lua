if not fs.exists("bbpack") then
    shell.run("pastebin", "get", "cUYTGbpb","bbpack")
end
 
shell.run("bbpack", "mount", "https://github.com/kaseyawolf2/TurtleProject","install")

fs.delete("LocalGit")
fs.copy("install/","LocalGit")

os.reboot()