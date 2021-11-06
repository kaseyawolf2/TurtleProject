local TF = {}

function TF.FindPeripheralByMethod(Method)
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

function TF.SearchInvByID(IdName,InvToSearch)
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
        Chests = TF.FindPeripheralByMethod("size")
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

function TF.SearchInvByTag(TagName,InvToSearch)
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
        Chests = TF.FindPeripheralByMethod("size")
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

function TF.PullItemToSelf(FromInv, FromSlot, Number, ToSlot)
    Chest = TF.SearchInvByTag("forge:storage","Internal")
    while Chest == nil do
        print("Please Give Me a chest")
        os.pullEvent("turtle_inventory")
        Chest = TF.SearchInvByTag("forge:storage","Internal")
    end
    turtle.select(Chest[1]["Slot"])
    if turtle.detectUp() == false then
        while turtle.placeUp() == false do
            term.clear()
            print("Please get off me")
        end
        TChest = "top"
    elseif turtle.detectDown() == false then 
        while turtle.placeDown() == false do
            term.clear()
            print("Please get out from under me")
        end
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
    TF.Equip("pickaxe")
    if TChest == "top" then
        turtle.suckUp()
        if not turtle.digUp() then
            term.clear()
            print("Please Break the chest above me")
            while turtle.detectUp() do 

            end
        end
    elseif TChest == "bottom" then
        turtle.suckDown()
        if not turtle.digDown() then
            term.clear()
            print("Please Break the chest below me")
            while turtle.detectDown() do 

            end
        end
    else
        print("Lost TChest Location")
    end
    term.clear()
    return true
end

function TF.Equip(Item)
    if Item == "modem" then -- only equipment that can go to the left
        EQ = TF.SearchInvByID("computercraft:wireless_modem_advanced","Internal") -- look for advanced modems first
        if EQ == nil then
            EQ = TF.SearchInvByID("computercraft:wireless_modem_normal","Internal") -- then for standard
        end
        if EQ == nil then -- if still zero then return false
            return false
        end
        turtle.select(EQ[1]["Slot"])
        turtle.equipLeft()
    elseif Item == "pickaxe" then
        EQ = TF.SearchInvByID("minecraft:diamond_pickaxe","Internal")
        if EQ == nil then -- if zero then return false
            return false
        end
        turtle.select(EQ[1]["Slot"])
        turtle.equipRight()
    elseif Item == "workbench" then 
        EQ = TF.SearchInvByID("minecraft:crafting_table","Internal")
        if EQ == nil then -- if zero then return false
            return false
        end
        turtle.select(EQ[1]["Slot"])
        turtle.equipRight()
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    -- elseif Item == "x" then 
    else
        print("I dont know what that is")
    end
    return true
end

function TF.SyncKnowledge()
    -- Look for Database computer

end

function TF.SaveKnowledge(Knowledge)
    -- Save Knowledge in the CraftingKnowledge folder
    KText = string.gsub(Knowledge["Result"][1]["Name"], ":","-")
    KFile = fs.open("CraftingKnowledge/" .. KText ,"w")
    KFile.write(textutils.serialize(Knowledge["Ingredients"]))
    KFile.close()

end

function TF.SearchKnowledge(TFItemName)
    local ReturnList = {}
    TTFItemName = string.gsub(TFItemName, ":","-")
    
    FoundItems = fs.find("CraftingKnowledge/" .. TTFItemName)

    if #FoundItems == 0 then
        return nil
    end
    --print("Found "..#FoundItems)'
    
    for i = 1, #FoundItems do
        FResults = fs.open( FoundItems[i] , "r" )
        x1 = { Itemname = TFItemName }
        ReturnList[#ReturnList + 1] = { Result = x1 , Ingredients = FResults }
    end

    return ReturnList -- return the crafting knowledge
end

return TF