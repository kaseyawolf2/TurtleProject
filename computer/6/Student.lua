-- Get the Base Turtle
if fs.exists("TB.lua") then
    TB = require("TB")
else
    shell.run("pastebin", "get", "aERjx7BE","TB.lua")
    TB = require("TB")
end


function CraftandLearn()
    local RecipeList = {}
    local CraftList = {}
    for s = 1, 16 do --Search Internal Inv
        Item = turtle.getItemDetail(s) -- get the item for i slot
        if Item ~= nil then
            CraftList[#CraftList + 1] = {Location = "Internal", Slot = s, Count = Item["count"], Name = Item["name"]} -- add the slot to the export list
        end
    end
    if #CraftList == 0 then
        print("nothing in crafting")
        return nil
    end
    turtle.select(4)
    sus = turtle.craft(1)
    if sus == true then
        local ResultList = {}
        for s = 1, 16 do --Search Internal Inv
            Item = turtle.getItemDetail(s) -- get the item for i slot
            if Item ~= nil then
                ResultList[#ResultList + 1] = {Location = "Internal", Slot = s, Count = Item["count"], Name = Item["name"]} -- add the slot to the export list
            end
        end
        RecipeList = { Ingredients = CraftList , Result = ResultList}
        return RecipeList
    else
        print("Thats didnt work Teacher")
    end

end

function IsPrepared()
    local mod = peripheral.find("modem") 
    if mod ~= nil then
        local WB = peripheral.find("workbench")
        if WB ~= nil then
            Student()
        else
            local CT = SearchInvByID("minecraft:crafting_table")
            if CT ~= nil then
                turtle.select(CT[1]["Slot"])
                turtle.equipRight()
            else
                term.clear()
                print("I need a crafting Table")
            end
        end
    else
        print("I need a Modem")
    end
end

function TeachtheClass()
    -- transmit it to the rest of the turtles/Database PC



end



function Student()
    term.clear()
    print("Teach me to 'C'raft, 'L'ist what i know or 'E'xit")
    print("Place the Items in the Crafting area then")
    print("Tell me to craft it and i will learn how")
    re = io.read()
    if re == "C" or re == "c" then
        term.clear()
        KnowledgeList[#KnowledgeList+1] = CraftandLearn()
        print(textutils.serialize(KnowledgeList))
        print("Ok i got it")
        sleep(5)
        Student()
    elseif re == "E" or re == "e" then
        term.clear()
        print("Well That was a Learning Experience")
    elseif re == "T" or re == "t" then
        term.clear()
        print("Well That was a Learning Experience")
    elseif re == "L" or re == "l" then
        term.clear()
        print(textutils.serialize(KnowledgeList))
    else
        Student()
    end
end
IsPrepared()


