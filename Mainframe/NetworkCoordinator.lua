if term.isColor() then -- if advanced
    if not multishell then -- Check if we can access multishell
        --If we cant access multishell then we are most likely in a multishell
        --If we are in a multishell, Require wont work
        GF, AF, MD = ... -- you need to pass them in to multi shell
    else
        --not in a multishell so require the APIs 
        GF = require("/LocalGit/APIs/GF")
        AF = require("/LocalGit/APIs/AF")
        MD = require("/LocalGit/APIs/MD")
    end
else
    --not in a advanced pc so just require the APIs 
    GF = require("/LocalGit/APIs/GF")
    AF = require("/LocalGit/APIs/AF")
    MD = require("/LocalGit/APIs/MD")
end

if GF ~= nil then -- APIs are required
    MessageQueue = {}

    local function BackupMode()
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
        parallel.waitForAny(ListenForFailure,MainframeCheckIn)
    end

    local function BootMainframe()
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
                local Sender, Message, Protocol = rednet.receive("MainframeResponce",5)
                print("Mainframe Attempt " .. i .. " : " .. tostring(Sender))
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

    local function Listen()
        --Listen for Message
        local Event, Sender, Message, Protocol = os.pullEvent("rednet_message")
        --Package Message
        local MessagePackage = {Event = Event,Sender = Sender,Message = Message, Protocol = Protocol}
        --Add package to table
        table.insert(MessageQueue,MessagePackage)
    end

    local function Respond()
        if #MessageQueue > 0 then
            local MessagePackage = table.remove(MessageQueue,1)
            local Event =   MessagePackage["Event"]
            local Sender =  MessagePackage["Sender"]
            local Message = MessagePackage["Message"]
            local Protocol =MessagePackage["Protocol"]

            if Protocol == "MineSlotRequest" then
                local Area = AF.LoadArea(Message)
                CurAssigned = Area["SlicesAssigned"]
                AssignNum = 1 + CurAssigned
                Area["SlicesAssigned"] = AssignNum
                print("Assigning " .. AssignNum ..  " To " .. Sender)
                rednet.send(Sender, AssignNum ,"MineSlotAssignment")
                AF.SaveArea(Area["ID"],Area)

            elseif Protocol == "MineRequest" then
                local Area = AF.LoadArea(1)
                CurAssigned = Area["SlicesAssigned"]
                AssignNum = 1 + CurAssigned
                Area["SlicesAssigned"] = AssignNum
                print("Assigning " .. AssignNum ..  " To " .. Sender)
                Pack = {Area = AF.LoadArea(Area["ID"]), Slice = AssignNum}
                AF.SaveArea(Area["ID"],Area)
                rednet.send(Sender, Pack ,"MineSlotAssignment")
            else
                print("Unknown Message from " .. Sender .. " with Protocol " .. tostring(Protocol))
            end
        else 
            print("Message Queue now : " .. #MessageQueue)
        end
    end

    -- Main execution
    MasterMainframeID = nil
    MyID = os.getComputerID()
    
    -- Boot up the mainframe
    BootMainframe()
    
    -- Main loop
    while true do
        parallel.waitForAll(Listen, Respond)
    end
else
    error("Requires GF to be passed to Program")
end
