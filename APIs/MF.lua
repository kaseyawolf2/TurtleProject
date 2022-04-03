local MF = {}

AF = require("/LocalGit/APIs/AF")
MessageQueue = {}
--Mainframes Functions
function MF.BackupMode()
    local function ListenForFailure()
        while true do 
            local Sender, Message, Protocol = rednet.receive("MainframeFail")
            print("Start up Detected From : " .. tostring(Sender))
            if Sender ~= nil then
                return false
            end
        end
    end
    local function MainframeCheckIn()
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
    parallel.waitForAny(ListenForFailure,MainframeCheckIn) -- end if Receives Failure message, or Check in fails
end

function MF.BootMainframe()
    local function ListenForStartups()
        print("Broadcasting Startup")
        rednet.broadcast("Im Starting Up" , "MainframeOnline")
        while true do 
            local Sender, Message, Protocol = rednet.receive("MainframeOnline")
            print("Start up Detected From : " .. tostring(Sender))
            if Sender < os.getComputerID() then
                MasterMainframeID = Sender
                return false
            else
                rednet.broadcast("I have seniority" , "MainframeOnline")
            end
        end
    end
    local function ListenForMainframe()
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
    --Open Rednet
    rednet.close()
    sleep(1)
    rednet.open(peripheral.getName(peripheral.find("modem")))
    --Clear Screen and reset to top
    term.clear()
    term.setCursorPos(1, 1)
    print("Mainframe Booting...")
    MasterMainframeID = nil
    print("Anyone already the Mainframe or Starting up?")
    parallel.waitForAny(ListenForStartups,ListenForMainframe)
    if MasterMainframeID == nil then
        MasterMainframeID = os.getComputerID()
    end
    term.clear()
end

function MF.Listen()
    --Listen for Message
    local Event, Sender, Message, Protocol = os.pullEvent("rednet_message")
    --Package Message
    local MessagePackage = {Event = Event,Sender = Sender,Message = Message, Protocol = Protocol}
    --Add package to table
    table.insert(MessageQueue,MessagePackage)
end

function MF.Respond()
    if #MessageQueue > 0 then

        local MessagePackage = table.remove(MessageQueue,1)
        local Event =   MessagePackage["Event"]
        local Sender =  MessagePackage["Sender"]
        local Message = MessagePackage["Message"]
        local Protocol =MessagePackage["Protocol"]


        if Protocol == "MineSlotRequest" then
            local MD = require("/LocalGit/APIs/MD")
            local Area = AF.LoadArea(Message)
            CurAssigned = Area["SlicesAssigned"]
            AssignNum = 1 + CurAssigned
            Area["SlicesAssigned"] = AssignNum
            print("Assigning " .. AssignNum ..  " To " .. Sender)
            rednet.send(Sender, AssignNum ,"MineSlotAssignment")

            MD.SaveArea(Area["ID"],Area)


        elseif Protocol == "MineRequest" then
            local MD = require("/LocalGit/APIs/MD")

            -- 
            local Area = AF.LoadArea(1)

            
            CurAssigned = Area["SlicesAssigned"]


            AssignNum = 1 + CurAssigned
            Area["SlicesAssigned"] = AssignNum
            print("Assigning " .. AssignNum ..  " To " .. Sender)

            
            Pack = {Area = Area["ID"], Slice = AssignNum}
            
            MD.SaveArea(Area["ID"],Area)
            
            rednet.send(Sender, Pack ,"MineSlotAssignment")

            
        else
            print("Unknown Message from " .. Sender .. " with Protocol " .. tostring(Protocol))
        end
    else 
        print("Message Queue now : " .. #MessageQueue)

    end
end


function MF.ListenRespond()
    while true do
        term.setCursorPos(1, 1)
        print("Mainframe Online")
        --Listen
        local Event1, Sender1, Message1, Protocol1 = os.pullEvent("rednet_message")
        term.setCursorPos(1, 1)
        term.clearLine()
        term.scroll(-1)
        print("Message from " .. Sender1)
        local MessagePackage = {Event = Event1,Sender = Sender1,Message = Message1, Protocol = Protocol1}
        table.insert(MessageQueue,MessagePackage)


    end


    --     --Respond 
        



    --     --local Event, Sender, Message, Protocol = os.pullEvent("rednet_message")
    --     MessagePackage = table.remove(MessageQueue,1)
    --     local Event = MessagePackage["Event"]
    --     local Sender =MessagePackage["Sender"]
    --     local Message =MessagePackage["Message"]
    --     local Protocol = MessagePackage["Protocol"]

    --     if Protocol == "KnowledgeRequest" then
    --         print("Knowledge Request from " .. Sender .. " for " .. tostring(Message))

            

    --     elseif Protocol == "KnowledgeUpload" then
    --         SaveKnowledge(Message)
    --         print("Knowledge from " .. Sender .. " for " .. tostring(Message["Result"]["Itemname"]))




    --     elseif Protocol == "KnowledgeSync" then
            


    --     elseif Protocol == "MainframeRequest" then
    --         print("Mainframe Request from " .. Sender)
    --         rednet.send(Sender, "Im The Mainframe" ,"MainframeResponce")



    --     elseif Protocol == "MainframeOnline" then
    --         print("Mainframe Online from " .. Sender)
    --         rednet.send(Sender, "Im The Mainframe" ,"MainframeOnline")



    --     elseif Protocol == "MainframeFail" then
    --         print("Mainframe Failure Detected")                


    --     elseif Protocol == "MineSlotRequest" then
    --         local MD = require("/LocalGit/APIs/MD")

    --         AssignNum = 1 + Message["SlicesAssigned"]
    --         Message["SlicesAssigned"] = 1 + Message["SlicesAssigned"]

    --         print("Assigning " .. AssignNum ..  " To " .. Sender)
    --         rednet.send(Sender, AssignNum ,"MineSlotAssignment")

    --         MD.SaveArea(Message["ID"],Message)
    --     else
    --         print("Unknown Message from " .. Sender .. " with Protocol " .. tostring(Protocol))
    --     end
    --     term.setCursorPos(1, 1)
    --     term.clearLine()
    --     term.scroll(-1)
    -- end
end


--General Functions
function MF.SendMessage(Message,Protocol)
    rednet.broadcast(Message , Protocol)
end

return MF