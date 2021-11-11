local GF = {}


--Peripheral/Item Names (incase something changes )
PeriDiskDrive = "computercraft:disk_drive"
PeriFloppyDisk = "computercraft:disk"
PeriPickaxe = "minecraft:diamond_pickaxe"
PeriWorkbench = "minecraft:crafting_table"
PeriWirelessAdvanced = "computercraft:wireless_modem_advanced"
PeriWireless = "computercraft:wireless_modem_normal"
PeriStorage = "forge:storage" -- any Storage 
PeriTurtle = "computercraft:turtle_normal"



function GF.FindPeripheralByMethod(Method)
    local ReturnList = {}
    for x = 1,6 do -- Check the 6 sides
        perf = peripheral.getNames()[x] -- this gets the side its on
        if perf ~= nil then -- if not empty
            meth = peripheral.getMethods(perf) -- get the methods
            for l = 0, #meth do -- look though the methods
                if meth[l] == Method then -- see if theres a size method
                    ReturnList[#ReturnList+1] = perf -- Adds the side to the list of results                   
                end
            end
        end
    end
    if #ReturnList == 0 then
        return nil
    end
    return ReturnList -- outputs chest side
end

function GF.SearchInvByID(IdName,InvToSearch)
    local ReturnList = {}
    if InvToSearch == nil or InvToSearch == "Internal" then
        for s = 1, 16 do --Search Internal Inv
            Item = turtle.getItemDetail(s) -- get the item for i slot
            if Item ~= nil then -- if not no item
                if Item["name"] == IdName then -- does the name match the requested item
                    ReturnList[#ReturnList + 1] = {Location = "Internal", Slot = s, Count = Item["count"]} -- add the slot to the export list
                end
            end
        end    
    end
    if InvToSearch == nil then
        Chests = GF.FindPeripheralByMethod("size")
        if Chests ~= nil then
            for i = 1, #Chests do
                CurChest = peripheral.wrap(Chests[i])
                for s = 1, CurChest.size() do
                    Item = CurChest.getItemDetail(s)
                    if Item ~= nil then -- if not no item
                        if Item["name"] == IdName then -- does the name match the requested item
                            ReturnList[#ReturnList + 1] = {Location = Chests[i], Slot = s, Count = Item["count"]} -- add the slot to the export list
                        end
                    end
                end
            end
        end
    elseif InvToSearch ~= "Internal" then
        CurChest = peripheral.wrap(InvToSearch)
        for s = 1, CurChest.size() do
            Item = CurChest.getItemDetail(s)
            if Item ~= nil then -- if not no item
                if Item["name"] == IdName then -- does the name match the requested item
                    ReturnList[#ReturnList + 1] = {Location = Chests[i], Slot = s, Count = Item["count"]} -- add the slot to the export list
                end
            end
        end
    end
    if #ReturnList == 0 then
        return nil
    end
    return ReturnList
end

function GF.SearchInvByTag(TagName,InvToSearch)
    local ReturnList = {}
    if InvToSearch == nil or InvToSearch == "Internal" then
        for i = 1, 16 do
            Item = turtle.getItemDetail(i,true)
            if Item ~= nil then
                if Item["tags"][TagName] == true then
                    ReturnList[#ReturnList + 1] = {Location = "Internal", Slot = i, Count = Item["count"]}
                end
            end
        end
    end
    if InvToSearch == nil then
        Chests = GF.FindPeripheralByMethod("size")
        if Chests ~= nil then
            for i = 1, #Chests do
                CurChest = peripheral.wrap(Chests[i])
                for s = 1, CurChest.size() do
                    Item = CurChest.getItemDetail(s)
                    if Item ~= nil then -- if not no item
                        if Item["tags"][TagName] == true then -- does the name match the requested item
                            ReturnList[#ReturnList + 1] = {Location = Chests[i], Slot = s, Count = Item["count"]} -- add the slot to the export list
                        end
                    end
                end
            end
        end
    elseif InvToSearch ~= "Internal" then
        CurChest = peripheral.wrap(InvToSearch)
        for s = 1, CurChest.size() do
            Item = CurChest.getItemDetail(s)
            if Item ~= nil then -- if not no item
                if Item["tags"][TagName] == true then -- does the name match the requested item
                    ReturnList[#ReturnList + 1] = {Location = Chests[i], Slot = s, Count = Item["count"]} -- add the slot to the export list
                end
            end
        end
    end
    if #ReturnList == 0 then
        return nil
    end
    return ReturnList
end

function GF.PlaceBlockByList(Listofitems,PlaceDir)
    if #Listofitems == 0 or Listofitems == nil then
        return false -- end if the list is empty
    end
    for i=1, #Listofitems do --cycle through till its placed
        turtle.select(Listofitems[i]["Slot"])
        if PlaceDir == "Forward" or PlaceDir == "forward" or PlaceDir == "Front" or PlaceDir == "front" or PlaceDir == nil then
            while turtle.placeUp() == false do -- wait till youve placed it
                term.clear()
                print("Please get out of the way")
            end
        elseif PlaceDir == "Up" or PlaceDir == "up" or PlaceDir == "Top" or PlaceDir == "top" then
            while turtle.placeUp() == false do -- wait till youve placed it
                term.clear()
                print("Please get off me")
            end
        elseif PlaceDir == "Down" or PlaceDir == "down" or PlaceDir == "Bottom" or PlaceDir == "bottom" then
            while turtle.placeDown() == false do -- wait till youve placed it
                term.clear()
                print("Please get out from under me")
            end
        else
            error("Unknown Placement Direction") -- PS this stops the program
        end
        return true
    end
end

function GF.SearchInvForEmptySlot(InvToSearch)
    local ReturnList = {}
    if InvToSearch == nil or InvToSearch == "Internal" then
        for i = 1, 16 do
            Item = turtle.getItemDetail(i,true)
            if Item == nil then -- if  no item
                ReturnList[#ReturnList + 1] = {Location = "Internal", Slot = i} -- add the slot to the export list
            end
        end
    end
    if InvToSearch == nil then
        Chests = GF.FindPeripheralByMethod("size")
        if Chests ~= nil then
            for i = 1, #Chests do
                CurChest = peripheral.wrap(Chests[i])
                for s = 1, CurChest.size() do
                    Item = CurChest.getItemDetail(s)
                    if Item == nil then -- if  no item
                        ReturnList[#ReturnList + 1] = {Location = Chests[i], Slot = s} -- add the slot to the export list
                    end
                end
            end
        end
    elseif InvToSearch ~= "Internal" then
        CurChest = peripheral.wrap(InvToSearch)
        for s = 1, CurChest.size() do
            Item = CurChest.getItemDetail(s)
            if Item == nil then -- if  no item
                ReturnList[#ReturnList + 1] = {Location = Chests[i], Slot = s} -- add the slot to the export list
            end
        end
    end
    if #ReturnList == 0 then
        return nil
    end
    return ReturnList

end

function GF.PullItemToSelf(FromInv, FromSlot, Number, ToSlot)
    Chest = GF.SearchInvByTag(PeriStorage,"Internal")
    while Chest == nil do
        print("Please Give Me a chest")
        os.pullEvent("turtle_inventory")
        Chest = GF.SearchInvByTag(PeriStorage,"Internal")
    end
    if turtle.detectUp() == false then
        GF.PlaceBlockByList(Chest,"Up")
        TChest = "top"
    elseif turtle.detectDown() == false then 
        GF.PlaceBlockByList(Chest,"Down")
        TChest = "bottom"
    else 
        print("Failed to place Transfer Chest")
        return false
    end
    print("Placed Chest : " .. TChest)
    CWrap = peripheral.wrap(FromInv)
    if CWrap.pushItems(TChest, FromSlot,Number,ToSlot) == 0 then
        print("Failed to move any items")
        return false
    end
    GF.Equip("pickaxe")
    if TChest == "top" then
        turtle.suckUp()
        if not turtle.digUp() then
            while turtle.detectUp() do 
                term.clear()
                print("Please Break the chest above me")
            end
        end
    elseif TChest == "bottom" then
        turtle.suckDown()
        if not turtle.digDown() then
            while turtle.detectDown() do 
                term.clear()
                print("Please Break the chest below me")
            end
        end
    else
        error("Lost TChest Location") -- Will stop program
    end
    term.clear()
    return true
end

function GF.Equip(Item)
    if Item == "modem" then -- only equipment that can go to the left
        EQ = GF.SearchInvByID(PeriWirelessAdvanced,"Internal") -- look for advanced modems first
        if EQ == nil then
            EQ = GF.SearchInvByID(PeriWireless,"Internal") -- then for standard
        end
        if EQ == nil then -- if still zero then return false
            return false
        end
        for i=1, #EQ do -- go thought the list
            turtle.select(EQ[1]["Slot"]) -- select the item
            if turtle.equipLeft() then  -- equip it 
                return true -- if it equips then exit out
            end --else try the next one iguess
        end
    elseif Item == "pickaxe" then
        EQ = GF.SearchInvByID(PeriPickaxe,"Internal")
        if EQ == nil then -- if zero then return false
            return false
        end
        for i=1, #EQ do -- go thought the list
            turtle.select(EQ[1]["Slot"]) -- select the item
            if turtle.equipRight() then  -- equip it 
                return true -- if it equips then exit out
            end --else try the next one iguess
        end
    elseif Item == "workbench" then 
        EQ = GF.SearchInvByID(PeriWorkbench,"Internal")
        if EQ == nil then -- if zero then return false
            return false
        end
        for i=1, #EQ do -- go thought the list
            turtle.select(EQ[1]["Slot"]) -- select the item
            if turtle.equipRight() then  -- equip it 
                return true -- if it equips then exit out
            end --else try the next one iguess
        end
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    else
        Error("I dont know what Equipment that is")
    end
    return true
end

function GF.SendMainframeMessage(Message, Protocol)
    local GFMainframeID
    while GFMainframeID == nil do
        rednet.broadcast("Hello" , "MainframeRequest")
        local Sender, Message, Protocol = rednet.receive("MainframeResponce", 1)
        GFMainframeID = Sender
        if GFMainframeID == nil then
            rednet.broadcast("No Responce" , "MainframeFail")
        end
    end
    rednet.send(GFMainframeID, Message, Protocol)
end

function GF.SyncKnowledge()
    local ReturnList = {}
    FoundItems = fs.list("CraftingKnowledge/")
    print("Syncing " .. #FoundItems)
    for i = 1, #FoundItems do
        ResultItemName = string.gsub(FoundItems[i], ":","-")
        FResults = fs.open("CraftingKnowledge/"..FoundItems[i] , "r" )
        LResults = FResults.readAll()
        FResults.close()
        LResults = textutils.unserialize(LResults)
        x1 = { Itemname = ResultItemName }
        ReturnList[#ReturnList + 1] = { Result = x1 , Ingredients = LResults }
    end
    for i=1, #ReturnList do
        --print(ReturnList[i]["Result"]["Itemname"])
        GF.UploadKnowledge(ReturnList[i])
    end
end

function GF.UploadKnowledge(Knowledge)
    --local Message = textutils.serialize(Knowledge)
    local Message = Knowledge
    GF.SendMainframeMessage(Message, "KnowledgeUpload")
end

function GF.SaveKnowledge(Knowledge)
    -- Save Knowledge in the CraftingKnowledge folder
    KText = string.gsub(Knowledge["Result"]["Itemname"], ":","-")
    KFile = fs.open("CraftingKnowledge/" .. KText ,"w")
    KFile.write(textutils.serialize(Knowledge["Ingredients"]))
    KFile.close()
end

function GF.SearchKnowledge(ResultItemName)
    local ReturnList = {}
    TResultItemName = string.gsub(ResultItemName, ":","-")
    FoundItems = fs.find("CraftingKnowledge/" .. TResultItemName)
    if #FoundItems == 0 then
        return nil
    end
    for i = 1, #FoundItems do
        FResults = fs.open( FoundItems[i] , "r" )
        LResults = FResults.readAll()
        FResults.close()
        LResults = textutils.unserialize(LResults)
        x1 = { Itemname = ResultItemName }
        ReturnList[#ReturnList + 1] = { Result = x1 , Ingredients = LResults }
    end
    return ReturnList -- return the crafting knowledge
end

function GF.RunClass(ClassName)
    if GF.CanSwitchClass(ClassName) then --if you can switch then go download or Run the Class
        if ClassName == "Student" or ClassName == "student" then
            --qzt7K4sd
            if fs.exists("Student.lua") then
                shell.run("Student")
            else
                shell.run("pastebin", "get", PasteStudent,"Student.lua")
                shell.run("Student")
            end
        else
            print("Unknown Class Name")
            print(ClassName)
        end
    end
end

function GF.PlaceItemByID(IdName,PlaceDir,InvToSearch)
    --Find Item
    Items = GF.SearchInvByID(IdName,InvToSearch)
    -- place it base off the list
    return GF.PlaceBlockByList(Items,PlaceDir)
end

function GF.PlaceItemByTag(TagName,PlaceDir,InvToSearch)
    Items = GF.SearchInvByTag(TagName,InvToSearch)
    return GF.PlaceBlockByList(Items,PlaceDir)
end

function GF.CanSwitchClass(TurtleClass)
    if TurtleClass == "Crafter" or TurtleClass == "crafter" then
        if not peripheral.find("workbench") then -- if no Crafting table equiped
            if GF.SearchInvByID(PeriWorkbench) == nil then -- and none in inventory or nearby
                return false -- then you cant be one
            end
        end
    elseif TurtleClass == "Student" or TurtleClass == "student" then
        if not peripheral.find("workbench") then -- if no Crafting table equiped
            if GF.SearchInvByID(PeriWorkbench) == nil then -- and none in inventory or nearby
                return false -- then you cant be one
            end
        end
    elseif TurtleClass == "Miner" or TurtleClass == "miner" then
        -- first See if theres a pickaxe equiped
        if not turtle.detectUp() then -- first see if theres a block above 
            local Temp1, Temp2 = turtle.digUp()
            if Temp2 == "No tool to dig with" then
               return false 
            end
        elseif not turtle.detectDown() then -- first see if theres a block below 
            local Temp1, Temp2 = turtle.digDown()
            if Temp2 == "No tool to dig with" then
               return false 
            end
        elseif not turtle.detect() then -- first see if theres a block in front 
            local Temp1, Temp2 = turtle.dig()
            if Temp2 == "No tool to dig with" then
               return false 
            end
        else -- turn right and try again    
            DGPS.turnRight()
            GF.CanSwitchClass(TurtleClass)
        end
        if GF.SearchInvByID("minecraft:diamond_pickaxe") == nil then -- and none in inventory or nearby
            return false -- then you cant be one
        end
    else 
        error("Unknown Class to Switch to : " .. TurtleClass )
    end
    return true
end

function GF.PlaceTurtleByClass(TurtleClass)
    while Drive == nil do
        print("Please Give Me a Disk Drive")
        os.pullEvent("turtle_inventory")
        Drive = GF.PlaceItemByID(PeriDiskDrive,"Internal")
    end
    while Disk == nil do
        print("Please Give Me a Floppy Disk")
        os.pullEvent("turtle_inventory")
        Disk = GF.PlaceItemByID(PeriFloppyDisk,"Internal")
    end
    while Turtle == nil do
        print("Please Give Me a Turtle")
        os.pullEvent("turtle_inventory")
        Turtle = GF.PlaceItemByID(PeriTurtle,"Internal")
    end
    while TurtleModem == nil do
        print("Please Give Me a Modem")
        os.pullEvent("turtle_inventory")
        TurtleModem = GF.SearchInvByID(PeriWirelessAdvanced,"Internal") -- look for advanced modems first
        if TurtleModem == nil then
            TurtleModem = GF.SearchInvByID(PeriWireless,"Internal") -- then for standard
        end
    end

    --Place DiskDrive
    --insert Floppy
    --Write a program in the start up of the floppy
    --  Equips the Modem and connects to the mainframe 
    --  downloads the class selected
    --  runs class
    --Place turtle and start it

end 

return GF