-- Get the General Functions
GF = require("LocalGit/APIs/GF")
--MF = require("LocalGit/APIs/MF")

os.setComputerLabel("Mainframe")


function BackupMode()
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

function BootMainframe()
    local function ListenForStartups()
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

    term.clear()
    term.setCursorPos(1, 1)
    print("Mainframe Booting...")
    MasterMainframeID = nil
    print("Anyone already the Mainframe or Starting up?")
    parallel.waitForAny(ListenForStartups,ListenForMainframe)
    if MasterMainframeID == nil then
        MasterMainframeID = MyID
    end
    term.clear()
end

function ListenRespond()
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
            print("Mainframe Failure Detected")                



        else
            print("Unknown Message from " .. Sender .. " with Protocol " .. tostring(Protocol))
        end
        term.setCursorPos(1, 1)
        term.clearLine()
        term.scroll(-1)
    end
end


MasterMainframeID = nil
MyID = os.getComputerID()


-- Find/Await A Modem and open Rednet
HasWireless = false
while not HasWireless do
    term.clear()
    term.setCursorPos(1, 1)
    local ModList = peripheral.find("modem")
    if ModList ~= nil then
        if ModList.isWireless() then
            HasWireless = true
        end
    else
        print("Please Attach a Wireless Modem")
        local Event, side = os.pullEvent("peripheral")
    end
end
term.clear()
rednet.close()
sleep(1)
rednet.open(peripheral.getName(peripheral.find("modem")))

term.setCursorPos(1, 1)

while true do
    BootMainframe()
    if MasterMainframeID == MyID then
        ListenRespond() 
    else
        term.clear()
        term.setCursorPos(1, 1)
        print("Mainframe in Backup Mode")
        BackupMode()
    end
end