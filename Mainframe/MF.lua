local MF = {}

function MF.SearchKnowledge(MFItemName)
    local ReturnList = {}
    TTFItemName = string.gsub(MFItemName, ":","-")
    
    FoundItems = fs.find("CraftingKnowledge/" .. TTFItemName)

    if #FoundItems == 0 then
        return nil
    end
    --print("Found "..#FoundItems)'
    
    for i = 1, #FoundItems do
        FResults = fs.open( FoundItems[i] , "r" )
        x1 = { Itemname = MFItemName }
        ReturnList[#ReturnList + 1] = { Result = x1 , Ingredients = FResults }
    end

    return ReturnList -- return the crafting knowledge
end

function MF.SaveKnowledge(Knowledge)
    -- Save Knowledge in the CraftingKnowledge folder
    KText = string.gsub(Knowledge["Result"]["Itemname"], ":","-")
    KFile = fs.open("CraftingKnowledge/" .. KText ,"w")
    KFile.write(textutils.serialize(Knowledge["Ingredients"]))
    KFile.close()
end

return MF