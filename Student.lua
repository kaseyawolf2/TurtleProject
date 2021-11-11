-- Get the Base Turtle
if TB == nil then
    if fs.exists("TB.lua") then
        TB = require("TB")
    else
        shell.run("pastebin", "get", "aERjx7BE","TB.lua")
        TB = require("TB")
    end
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
    local WB = peripheral.find("workbench")
    if WB ~= nil then
        Student()
    else
        local CT = TF.SearchInvByID("minecraft:crafting_table")
        if CT ~= nil then
            if not Equip("workbench") then -- looks in internal inv and equips the crafting table
                 -- cant find table in inventory so it must be in external storage
                if not TF.PullItemToSelf(CT[1]["Location"],CT[1]["Slot"],1) then 
                    print("could not pull item")
                    return
                end
                TF.Equip("workbench")
            end
        else
            term.clear()
            print("I need a crafting Table")
        end
        IsPrepared()
    end
end

function Student()
    term.clear()
    print("Teach me to 'C'raft or 'E'xit")
    print("Place the Items in the Crafting area then")
    print("Tell me to craft it and i will learn how")
    re = io.read()
    if re == "C" or re == "c" then
        term.clear()
        TF.SaveKnowledge(CraftandLearn())
        print("Ok i got it")
        sleep(2)
        Student()
    elseif re == "E" or re == "e" then
        term.clear()
        print("Well That was a Learning Experience")
    else
        Student()
    end
end
IsPrepared()