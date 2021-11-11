https://pastebin.com/wPbHNfDM

To Start using 
place any PC down (Turtles May Work but my cause issues later idk)

run
    pastebin get wPbHNfDM Installer
    Installer


Tools Used or may use
bbpack -- pastebin get cUYTGbpb bbpack // git hub get http://www.computercraft.info/forums2/index.php?/topic/21801-bbpack-pastebin-uploader-downloader/
https://computercraft.info/wiki/Category:APIs
https://tweaked.cc/

Currently Implemented Features

Installer
    Installs the mainframe
    Updates the Startup File
    Downloads the all the Github files


Mainframe
    Can Have Multiple PC as Mainframes
        Backups Listen For a failed Responce then they start up and take over command
    Houses Crafting Knowledge
        Saves New Knowledge
        Can Search for a Requested Recipe and transmit it to the requester


To Do List

Mainframe
    Local Git
        Send Files from LocalGit to New Turtles
    Crafting Knowledge
        Sync Knowledge With The rest of the mainframes
    Request Reponce
        Make it a Background Program so i can send mass commands
    GUI
        Make a Gui
    Monitor Support
        Make a GUI and tabs
            Communication Tab
                The Past few Communications
            Command Tab
                Send out Mass Commands
                    Update
                    RTB


Starter System
    Wait till requred resources / mine for them
    Builds GPS System https://pastebin.com/qLthLak5 -- make it smarter/ a pre gps system http://computercraft.info/wiki/Turtle_GPS_self-tracker_expansion_(tutorial)
    Build Command Computer // 

Command System
    NEEDs to be able to have multiple Command PCs / be hotswapable
    Start Screen
        At a Glace Numbers
            Number of Bots
            Number of Requested Bots
            Number of Mining Sites
        Storage System Info
            Only for Chest Style 
            Current Resources
        Bot Override Screen
            Recall all to storage
            Update All Bots via Rednet (that way paste bin doesnt get hit with 100+ bots updateing) https://computercraft.info/wiki/Fs_(API) https://computercraft.info/wiki/Rednet_(API)
            Stop Dispaching Bots
            Dispach All bots (To upgrade)
    Handheld PC View
    AR View

Storage System
    Ask what system it should use
        Chest
        Advanced Peripherals Required  
            AE2
            Refined Storage
            
Mining System
    Get mining zone
        split zone by number of miners assigned
        Request more miners if needed
    Several Mining Styles
        Open Air Strip Mine
        Y Level Bore
        Y 255 to 0 Hole Mining (1x1 stright down)
        Water Removal
    AR Glasses OverLay

Building System
    Ocean Circle Builder 

Crafting System
    Show And Learn System ( Might need a dedicated Student Bot)
        place items in turtle then have it craft and remember it
        then teaches the rest of the turtles    
    
    
    IF Ae2 or Refined 
        Stop and request 
    IF CHest storage then get items then craft

Command&Control System
    Send Commands to turtles
    Revoke old Commands / Edit them 


