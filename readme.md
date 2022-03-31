https://pastebin.com/wPbHNfDM

To Start

place any PC down 
and a turtle
run the installer on both

run
    pastebin get wPbHNfDM Installer
    Installer


Tools Used or may use
bbpack -- git hub get http://www.computercraft.info/forums2/index.php?/topic/21801-bbpack-pastebin-uploader-downloader/
    pastebin get cUYTGbpb bbpack        
GPS System Builder --   https://pastebin.com/qLthLak5
    pastebin get qLthLak5 GPSbuild

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
    Houses Knowledge
        Mining Area Knowledge
            Where to Mine
            How To mine 
        Crafting Knowledge
            Saves New Knowledge
            Can Search for a Requested Recipe and transmit it to the requester
    GUI
        Update
        Mining Controls
        


To Do List
Bug List
    Responder starts up in backup mode
    responder keeps Restarting

* = Done
- = Works but with requirements

Minium Viable Product
    Turtle
        - DGPS- 
            - Entry point - Works but needs refinement for non perfect start
                * Get the turtle setup for use * 
                GPS Detection of settings
                if no GPS get user input
            * Goto *
                * XYZ Movement *
                * Travel Height *
        Mine
            - Recieve Area To Mine -
            Deposit Ores at Set Site
    Mainframe
        Areas
            - Stripmine - 
                Even Distubion between Turtles
        - Ore Deposit Site -

Milestone 1
    Mainframe
        Send out Update Commands
        Mining Styles
        Stats
            Connected Turtles
    Turtles
        Listen for Update Commands
        Courier Turtles
            Transfer from dig site to Main Storage

Milestone 2
    Mainframe
        Download Turtle updates and send it out over rednet 
        Multi Mainframes/Backups
    Turtles
        Return to Home 
        GPS deploying

Milestone 3
    Turtles
        Crafting
            Self Replication
        Starter Turtle
            Build 1 and have it mine till its able to craft a gps system and mainframe



Refinements
    Turtles
        Optimize Turning to Dir
            Right now it turns left till its face the correct dir even if 1 right would do the same
    Mainframe
        Encripted messages
        Custom Message Channels to keep spam down






Wish List
    Add Ownership

    Installer

    TF
        fix eqiup

    Mainframe
        Local Git
            Send Files from LocalGit to New Turtles
        Crafting Knowledge
            Sync Knowledge With The rest of the mainframes
        Request Reponce
            Make it a Background Program so i can send mass commands
        GUI
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


        Monitor Support
            Make a GUI and tabs
                Communication Tab
                    The Past few Communications
                Command Tab
                    Send out Mass Commands
                        Update
                        RTB

    Starter System

        Connect to GPS
            if No GPS
                Await Resources to build one
                build it
        Builds  -- make it smarter/ http://computercraft.info/wiki/Turtle_GPS_self-tracker_expansion_(tutorial)

    Command System
        Handheld PC View
        AR View

    Storage System
        Ask what system it should use
            Chest
            Advanced Peripherals Required  
                AE2
                Refined Storage
                
    Mining System
        Save Mined Out area
        Split Mining area Up based off of Style
            Save turtle Id whos working on
            
            Remove From list when turtle completes
        Provide Chucky Turtle Support if advanced perfierals are a thing
        Get mining zone
            split zone by number of miners assigned
            Assigned Turtles
                - X + Of ChunkLoaders
                    Min of 1
                    Max of num of chunks
                - X + Of miners
                    Min of 1
                    Max of num of slices*Loadable Chunks
                Recommended Default
                Request more miners if needed
        Several Mining Styles
            Open Air Strip Mine
                1 Turtle Mine(1 Chunk at a time) if multichunk can request more bots
                Strip Split (split the mine in to 1 block x 1 chunk strips)
                3x3 Partion (each turtle is assigned 3x3 to y0 to mine)
                Y 255 to 0 BoreHole Mining (1x1 stright down)
            Y Level Excavate(tunnel to y level and tunnel)
                Toggle if Vein Mines
                Y height of Tunnel
            Water Removal
                if enough tutles can just sweep across
                    might need a command turtle?
                if not enough then
                    spongeing
                    fill strip with coble then remove 
        AR Glasses OverLay?

    Turtle Transport(TM)
        Chunky turtle
            Holding Shulkers
            

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


