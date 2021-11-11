local MF = {}

function MF.ListenForStartups()
    print("Broadcasting Startup")
    rednet.broadcast("Im Starting Up" , "MainframeOnline")
    while true do 
        local Sender, Message, Protocol = rednet.receive("MainframeOnline")
        print("Start up Detected From : " .. tostring(Sender))
        if Sender < MyID then
            MasterMainframeID = Sender
            return false
        else
            rednet.broadcast("I have seniority" , "MainframeOnline")
        end
    end
end

function MF.ListenForFailure()
    while true do 
        local Sender, Message, Protocol = rednet.receive("MainframeFail")
        print("Start up Detected From : " .. tostring(Sender))
        if Sender ~= nil then
            return false
        end
    end
end

function MF.ListenForMainframe()
    for i=1,5 do
        rednet.broadcast("Hello" , "MainframeRequest")
        print("Mainframe Attempt " .. i .. " : " .. tostring(Sender))
        local Sender, Message, Protocol = rednet.receive("MainframeResponce",5)
        if Sender ~= nil then
            MasterMainframeID = Sender
            return false
        end
    end
end

function MF.MainframeCheckIn()
    while true do 
        rednet.broadcast("Hello" , "MainframeRequest")
        local Sender, Message, Protocol = rednet.receive("MainframeResponce",30)
        print("Start up Detected From : " .. tostring(Sender))
        if Sender == nil then
            return false
        else
            sleep(30)
        end
    end    
end

function MF.BootMainframe()
    term.clear()
    term.setCursorPos(1, 1)
    print("Mainframe Booting...")
    MasterMainframeID = nil

    print("Anyone already the Mainframe or Starting up?")
    parallel.waitForAny(MF.ListenForStartups,MF.ListenForMainframe)
    if MasterMainframeID == nil then
        MasterMainframeID = MyID
    end

    term.clear()
end

function MF.ListenResond()
    while true do
        term.setCursorPos(1, 1)
        print("Mainframe Online")
        local Event, Sender, Message, Protocol = os.pullEvent("rednet_message")
        if Protocol == "KnowledgeRequest" then
            print("Knowledge Request from " .. Sender .. " for " .. tostring(Message))
        elseif Protocol == "KnowledgeUpload" then
            SaveKnowledge(Message)
            print("Knowledge from " .. Sender .. " for " .. tostring(Message["Result"]["Itemname"]))
        elseif Protocol == "KnowledgeSync" then
            
        elseif Protocol == "MainframeRequest" then
            print("Mainframe Request from " .. Sender)
            rednet.send(Sender, "Im The Mainframe" ,"MainframeResponce")
        elseif Protocol == "MainframeOnline" then
            print("Mainframe Online from " .. Sender)
            rednet.send(Sender, "Im The Mainframe" ,"MainframeOnline")
        elseif Protocol == "MainframeFail" then
            print("Mainframe Failure")                
        else
            print("Unknown Message from " .. Sender .. " with Protocol " .. tostring(Protocol))
        end
        term.setCursorPos(1, 1)
        term.clearLine()
        term.scroll(-1)
    end
end

return MF