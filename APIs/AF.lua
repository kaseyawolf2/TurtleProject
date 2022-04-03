AF = {}

function NewAreaTable()
    DefaultArea = {
        ID = 0,
        X1 = 0,
        X2 = 0,
        Z1 = 0,
        Z2 = 0,
        Style = "EvenSplit",
        Y = 11,
        TunnelHeight = DefaultHeight,
        Slices = {},
        SlicesAssigned = 0,
        Deposits = {
            X = 0,
            Y = 0,
            Z = 0
        }
    }
    --Not Returned currently but here for the info
    DefaultSlice = {
        X1 = 0,
        X2 = 0,
        Z1 = 0,
        Z2 = 0,
        ID = 0
    }
    return DefaultArea
end


--Area Functions
function AF.LoadArea(ID)
    local DefaultArea = NewAreaTable()



    --if gps connection then set x and z         
    if gps.locate(5) ~= nil then
        local X, Y, Z = gps.locate(5)
        DefaultArea["X1"] = X
        DefaultArea["X2"] = X
        DefaultArea["Z1"] = Z
        DefaultArea["Z2"] = Z
        DefaultArea["Deposits"]["X"] = X
        DefaultArea["Deposits"]["Y"] = Y
        DefaultArea["Deposits"]["Z"] = Z
    end


    if fs.exists("/Knowledge/MineAreas/"..ID) then
        local AreaInfo = {}
        local FResults = fs.open("/Knowledge/MineAreas/"..ID , "r" )
        local LResults = FResults.readAll()
        FResults.close()
        local AreaInfo = textutils.unserialize(LResults)
        return AreaInfo
    else
        DefaultArea["ID"] = #fs.find("/Knowledge/MineAreas/*")+1

        return DefaultArea
    end
end
function AF.SaveArea(ID,AreaInfo)
    --X1/Z1 should always be the smaller number
    if AreaInfo["X1"] > AreaInfo["X2"] then
        local Tx1 = AreaInfo["X2"]
        local Tx2 = AreaInfo["X1"]
        AreaInfo["X1"] = Tx1
        AreaInfo["X2"] = Tx2
    end
    if AreaInfo["Z1"] > AreaInfo["Z2"] then
        local Tz1 = AreaInfo["Z2"]
        local Tz2 = AreaInfo["Z1"]
        AreaInfo["Z1"] = Tz1
        AreaInfo["Z2"] = Tz2
    end
    local FResults = fs.open("/Knowledge/MineAreas/"..ID , "w" )
    FResults.write(textutils.serialize(AreaInfo))
    FResults.close()
    --SliceArea(AreaInfo)
end
function SliceAreaOld(AreaInfo)
    local SlicedArea = AreaInfo
    Format, Type = string.match(AreaInfo["Style"],"(.*)-%s*(.*)") --fucking regex black magic (Splits The Style at the -)

    local BoundX1 = AreaInfo["X1"]
    local BoundX2 = AreaInfo["X2"]
    local BoundZ1 = AreaInfo["Z1"]
    local BoundZ2 = AreaInfo["Z2"]
    --Get the Chunks affected
    XChunk1 = math.floor(BoundX1/16) -- Block/16 = chunk + where in the chunk
    XChunk2 = math.floor(BoundX2/16) -- floor it to get only the chunk
    ZChunk1 = math.floor(BoundZ1/16)
    ZChunk2 = math.floor(BoundZ2/16)

    local Slices = {}
    if Format == "Strip" then
        if Type == "1Turtle" then
            for Xc = XChunk1, XChunk2 do --once per x chunk strip
                for Zc = ZChunk1, ZChunk2 do--once per z chunk
                    local Slice = {X1 = nil, X2 = nil, Z1 = nil,Z2 = nil}
                    if Xc*16 >= BoundX1 then -- if The Chunk Minimum is bigger or equal to The X Bounds then use chunk bound
                        Slice["X1"] = Xc*16
                    else
                        Slice["X1"] = BoundX1
                    end
                    if (Xc*16)+15 <= BoundX2 then -- if The Chunk Max is Smaller or equal to The X Bounds then use chunk bound
                        Slice["X2"] = (Xc*16)+15
                    else
                        Slice["X2"] = BoundX2
                    end
                    if Xc*16 >= BoundX1 then -- if The Chunk Minimum is bigger or equal to The Z Bounds then use chunk bound
                        Slice["Z1"] = Zc*16
                    else
                        Slice["Z1"] = BoundZ1
                    end
                    if (Zc*16)+15 <= BoundZ2 then -- if The Chunk Max is Smaller or equal to The Z Bounds then use chunk bound
                        Slice["Z2"] = (Zc*16)+15
                    else
                        Slice["Z2"] = BoundZ2
                    end
                    Slices[#Slices+1]= Slice
                end
            end
        elseif Type == "Split" then
            for Xc = XChunk1, XChunk2 do --once per x chunk strip
                for Zc = ZChunk1, ZChunk2 do--once per z chunk
                    local Slice = {X1 = nil, X2 = nil, Z1 = nil,Z2 = nil}
                    for Zb = 0, 15 do 
                        if Xc*16 >= BoundX1 then -- if The Chunk Minimum is bigger or equal to The X Bounds then use chunk bound
                            Slice["X1"] = Xc*16
                        else
                            Slice["X1"] = BoundX1
                        end
                        if (Xc*16)+15 <= BoundX2 then -- if The Chunk Max is Smaller or equal to The X Bounds then use chunk bound
                            Slice["X2"] = (Xc*16)+15
                        else
                            Slice["X2"] = BoundX2
                        end
                        if Xc*16 >= BoundX1 then -- if The Chunk Minimum is bigger or equal to The Z Bounds then use chunk bound
                            Slice["Z1"] = Zc*16
                        else
                            Slice["Z1"] = BoundZ1
                        end
                        if (Zc*16)+Zb <= BoundZ2 then -- if The Chunk Max is Smaller or equal to The Z Bounds then use chunk bound
                            Slice["Z2"] = (Zc*16)+Zb
                        else
                            Slice["Z2"] = BoundZ2
                        end
                        Slices[#Slices+1]= Slice
                    end
                end
            end
        elseif Type == "3x3" then
        elseif Type == "Bore" then
        else
            error("Unknown "..Format.." Type :" .. Type)
        end
    elseif Format == "Tunnel" then
        if Type == "Standard" then

        else
            error("Unknown "..Format.." Type :" .. Type)
        end
    elseif Format == "Water" then
        if Type == "Block" then
        elseif Type == "Mover" then
        elseif Type == "Sponge" then
        else
            error("Unknown "..Format.." Type :" .. Type)
        end
    else
        error("Unknown Style : ".. Format.. " "..Type)
    end
    SlicedArea["Slices"] = Slices
end

function AF.SliceArea(AreaID,Count)
    Area = AF.LoadArea(AreaID)
    Area["Slices"] = {}

    if Area["Style"] == "EvenSplit" then
        --Get the Total Span of the X And Z
        XSpan = Area["X2"] - Area["X1"]            
        ZSpan = Area["Z2"] - Area["Z1"] 

        --Get the Slice Size to the smallest Int
        SliceX = math.floor(XSpan / Count)
        SliceZ = math.floor(ZSpan / Count)

        --Set Starting Coords to the Start of the Area
        LSliceX1 = Area["X1"]
        LSliceZ1 = Area["Z1"]

        local CurSliceID = 0

        for X=1,Count do
            -- Add the Slice Size to Start Coords to get the End Coords
            LSliceX2 = LSliceX1 + SliceX
            
            --If the last slice set End Coords to the Area end
            if X == Count then 
                LSliceX2 = Area["X2"]
            end
            

            for Z=1,Count do
                --Increment the ID
                CurSliceID = CurSliceID + 1

                -- Add the Slice Size to Start Coords to get the End Coords
                LSliceZ2 = LSliceZ1 + SliceZ

                --If the last slice set End Coords to the Area end
                if Z == Count then 
                    LSliceZ2 = Area["Z2"]
                end

                --Make a Table 
                local CurSlice = {
                    X1 = LSliceX1,
                    Z1 = LSliceZ1,
                    X2 = LSliceX2,
                    Z2 = LSliceZ2,
                    ID = CurSliceID
                }

                --Add the Slice to the Area
                table.insert(Area["Slices"], CurSlice)
                --Make the Next Slices Start Coords to the Current End Coords + 1 
                LSliceZ1 = LSliceZ2 + 1
            end
            --Make the Next Slices Start Coords to the Current End Coords + 1 
            LSliceX1 = LSliceX2 + 1
        end
    end
    --rednet.broadcast(Area, "TestingOrder")
    AF.SaveArea(AreaID,Area)
end



return AF