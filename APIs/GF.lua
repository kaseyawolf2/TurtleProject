local GF = {}

GFMainframeID = nil -- At start have no idea who is Mainframe

-- Make Crafting Knowledge Folder
if not fs.isDir("CraftingKnowledge") then
    fs.makeDir("CraftingKnowledge")
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

function GF.MainframeRequest()
    while true do
        rednet.broadcast("Hello", "MainframeRequest")
        local Sender, Message, Protocol = rednet.receive("MainframeResponce", 1)
        GFMainframeID = Sender
        if GFMainframeID ~= nil then
            return
        end
    end
end

function GF.MainframeTimeout(WaitTime)
    if WaitTime == nil then
        WaitTime = 30
    end
    sleep(WaitTime)
    rednet.broadcast("No Responce" , "MainframeFail")
end

function GF.SendMainframeMessage(Message, Protocol)
    while GFMainframeID == nil do
        --Send a mainframe Request every second untill responce or 30 seconds have passed
        parallel.waitForAny(GF.MainframeTimeout,GF.MainframeRequest)
    end
    rednet.send(GFMainframeID, Message, Protocol)
    return rednet.receive(Protocol)
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

return GF