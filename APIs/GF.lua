local GF = {}
--GF? What does that stand for? I'm guessing it's short for "General Functions" or something like that.

-- Make Crafting Knowledge Folder
if not fs.isDir("/Knowledge/Crafting") then
    fs.makeDir("/Knowledge/Crafting")
end

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

function GF.MainframeConnect(TimeOut,BreakoutNumber)
    local function MainframeRequest() -- Dont call this call Mainframe Connect
        local MainframeID = nil
        while true do
            rednet.broadcast("Hello", "MainframeRequest")
            local Sender, Message, Protocol = rednet.receive("MainframeResponce", 1)
            MainframeID = Sender
            if MainframeID ~= nil then
                return MainframeID
            end
        end
    end

    local function MainframeTimeout(WaitTime) -- Dont call this call Mainframe Connect
        if WaitTime == nil then
            WaitTime = 30
        end
        sleep(WaitTime)
        rednet.broadcast("No Responce" , "MainframeFail")
    end
    
    local MainframeID = nil
    if BreakoutNumber ~= nil then
        local i = BreakoutNumber
        local c = 1
    end
    while MainframeID == nil do
        --Send a mainframe Request every second untill responce or 30 seconds have passed
        parallel.waitForAny(function() MainframeTimeout(TimeOut) end , function() MainframeID = MainframeRequest() end)
        if BreakoutNumber ~= nil then
            if i == c then
                return nil
            end
        end
    end
    return MainframeID
end

function GF.SendMainframeMessage(Message, Protocol)
    local MainframeID = GF.MainframeConnect()
    rednet.send(MainframeID, Message, Protocol)
    return rednet.receive(Protocol)
end

function GF.SyncKnowledge()
    local ReturnList = {}
    FoundItems = fs.list("/Knowledge/Crafting/")
    print("Syncing " .. #FoundItems)
    for i = 1, #FoundItems do
        ResultItemName = string.gsub(FoundItems[i], ":","-")
        FResults = fs.open("/Knowledge/Crafting/"..FoundItems[i] , "r" )
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
    KFile = fs.open("/Knowledge/Crafting/" .. KText ,"w")
    KFile.write(textutils.serialize(Knowledge["Ingredients"]))
    KFile.close()
end

function GF.SearchKnowledge(ResultItemName)
    local ReturnList = {}
    TResultItemName = string.gsub(ResultItemName, ":","-")
    FoundItems = fs.find("/Knowledge/Crafting/" .. TResultItemName)
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

return GF