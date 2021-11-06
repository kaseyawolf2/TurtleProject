-- Starter System
--     Wait till requred resources / mine for them
--     Builds GPS System https://pastebin.com/qLthLak5
--     Build Command Computer // 


-- First thing Label Turtle 
os.setComputerLabel("Starter Bot")

-- Get the Base Turtle
if fs.exists("TB.lua") then
    TB = require("TB")
else
    shell.run("pastebin", "get", "aERjx7BE","TB.lua")
    TB = require("TB")
end

-- Detect if there Chest
function ChestCheck()
    term.clear()
    StartChest = TF.FindPeripheralByMethod("size")
    if StartChest == nil then -- if no chest ask for one
        InvChest = TF.SearchInvByTag("forge:storage") -- check if and forge storage items in inv
        if InvChest == nil then -- if no ask for a chest
            print("Please Place Down or Put in Inventory a Chest")
            print("Press Enter when Complete")
            re = io.read()
            if re ~= nil then
                ChestCheck()
            end
        else -- if yes place it down 
            turtle.select(InvChest[1])
            turtle.place()
            ChestCheck()
        end
    else
        print("Chest Found")
        StartChest = TF.FindPeripheralByMethod("size")[1] -- Take the first chest and remeber it
    end
end
ChestCheck()

--Ask if turtle should mine and expand or wait for resources to be delivered ( Should be able to tell the turtle to go mine at any time )
function MineCheck()
    term.clear()
    print("Should i Go and 'M'ine or just 'W'ait for you to get me resources")
    re = io.read()
    if re == "w" or re == "W" then --if told to wait then
        term.clear()
        print("Ok Waiting")
        if not peripheral.find("workbench") then
            print("Please give me a crafting table")
            while TF.SearchInvByID("minecraft:crafting_table") == nil do -- wait till theres a crafting table
                term.clear()
                print("Please give me a crafting table")
                sleep(10)
            end
        end
        -- Search the knowledge list on how to make turtles
        while not TF.SearchKnowledge("computercraft:turtle_normal") do
            term.clear()
            print("I dont know how to make a turtle")
            sleep(2)
            TF.RunClass("Student")
        end

        
    elseif re == "m" or re == "M" then -- if told to go mine
        -- see if theres a pickaxe
            -- get mining area / ask if the turtle should just mine down to get resources
                -- mining area needs to be relitive unless theres a gps
                    -- go mine
        print("Not done yet")

    else
        MineCheck()
    end
end
MineCheck()