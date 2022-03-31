local MD = {}

--# load the touchpoint API
touchpoint = require("/LocalGit/ExternalPrograms/Touchpoint")
--Defaults
DefaultStyle = "Strip-1Turtle"
DefaultMiningY = 11


--Local Functions
function GridMath(X,Y)
    local ButtonX = 6
    local ButtonY = 2
    local GridStartX = 2
    local GridStartY = 2

    local Rx = ((X-1)*ButtonX)+((X-1)*2)+GridStartX
    local Ry = ((Y-1)*ButtonY)+((Y-1)*2)+GridStartY

    local Rxe= (X*ButtonX)+((X-1)*2)+GridStartX
    local Rye= (Y*ButtonY)+((Y-1)*2)+GridStartY 

    return Rx, Ry, Rxe, Rye
end
function ListMath(Y)
    local MonX, MonY = monitor.getSize()
    local ButtonX = math.floor((MonX)-1)
    local ButtonY = 2
    local StartX = 2
    local StartY = 2

    local Rx = StartX
    local Ry = ((Y-1)*ButtonY)+((Y-1)*2)+StartY

    local Rxe= ButtonX
    local Rye= (Y*ButtonY)+((Y-1)*2)+StartY 

    return Rx, Ry, Rxe, Rye
end

--Area Functions
function LoadArea(ID)
    local DefaultArea = {
        ID = 0,
        X1 = 0,
        X2 = 0,
        Z1 = 0,
        Z2 = 0,
        Style = DefaultStyle,
        Y = DefaultMiningY,
        TunnelHeight = DefaultHeight,
        Slices = {}
    }
    local DefaultSlice = {
        X1 = 0,
        X2 = 0,
        Z1 = 0,
        Z2 = 0,
        Style = DefaultStyle
    }
    --if gps connection then set x and z         
    if gps.locate(5) ~= nil then
        X,Y,Z = gps.locate(5)
        DefaultArea["X1"] = X
        DefaultArea["X2"] = X
        DefaultArea["Z1"] = Z
        DefaultArea["Z2"] = Z
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
function SaveArea(ID,AreaInfo)
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
    SliceArea(AreaInfo)
end
function SliceArea(AreaInfo)
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

--Start Page
function LandingPanel()
    --# intialize button set on the monitor
    local Page = newPage(peripheral.getName(monitor))
    --# add buttons
    Page:add("Update Panel", UpdatePanel, 2, 2, FourPanX, FourPanY, colors.red, colors.lime)
    Page:add("Drone Controls", DronePanel, FourPanX+2, 2, MonX-1, FourPanY, colors.red, colors.lime)
    Page:add("Mining Controls", MiningPanel, 2, FourPanY+2, FourPanX, MonY-1, colors.red, colors.lime)
    Page:add("Statistics", StatsPanel, FourPanX+2, FourPanY+2, MonX-1, MonY-1, colors.red, colors.lime)
    --# draw the buttons
    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            
            
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end

--Base Panels
function UpdatePanel()
    --# intialize button set on the monitor
    local Page = newPage(peripheral.getName(monitor))
    --# add buttons
    local t1,t2,t3,t4 = ListMath(1)
    Page:add("Back", LandingPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(2)
    Page:add("Sync Turtles", nil, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(3)
    Page:add("Sync Mainframes", nil, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(4)
    Page:add("Sync All", nil, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(5)
    Page:add("Download Updates", function() shell.run("/LocalGit/Installer/Installer.lua") term.write("Updating And Rebooting") end, t1, t2, t3, t4, colors.red, colors.lime)
    --# draw the buttons
    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            
            
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end
function DronePanel()
    --# intialize button set on the monitor
    local Page = newPage(peripheral.getName(monitor))
    --# add buttons
    local t1,t2,t3,t4 = ListMath(1)
    Page:add("Back", LandingPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(2)
    Page:add("1", nil, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(3)
    Page:add("2", nil, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(4)
    Page:add("3", nil, t1, t2, t3, t4, colors.red, colors.lime)
    --# draw the buttons
    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            
            
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end
function StatsPanel()
    --# intialize button set on the monitor
    local Page = newPage(peripheral.getName(monitor))
    --# add buttons
    local t1,t2,t3,t4 = ListMath(1)
    Page:add("Back", LandingPanel, t1, t2, t3, t4, colors.red, colors.lime)

    --# draw the buttons
    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            
            
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end
function MiningPanel()
    -- intialize a new button set on the monitor
    local Page = newPage(peripheral.getName(monitor))
    --# add buttons
        local t1,t2,t3,t4 = ListMath(1)
        Page:add("Back", LandingPanel, t1, t2, t3, t4, colors.red, colors.lime)
        local t1,t2,t3,t4 = ListMath(2)
        Page:add("Default Mining Style", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
        local t1,t2,t3,t4 = ListMath(3)
        Page:add("Mining Areas", MiningAreasList, t1, t2, t3, t4, colors.red, colors.lime)
        local t1,t2,t3,t4 = ListMath(4)
        Page:add("Assignments", MiningAssignment, t1, t2, t3, t4, colors.red, colors.lime)
    -- draw the buttons
    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end

--Mining Panel 
function MiningStylesPanel(ID)
    if ID == nil then
       Style = DefaultStyle
    else
        Area = LoadArea(ID)
        Style = Area["Style"]
    end

    

    --# intialize button set on the monitor
    local Page = newPage(peripheral.getName(monitor))
    --# add buttons
    local t1,t2,t3,t4 = ListMath(1)
    if ID == nil then
        Page:add("Back", MiningPanel, t1, t2, t3, t4, colors.red, colors.lime)
    else
        Page:add("Back", function() MiningAreaPanel(ID) end, t1, t2, t3, t4, colors.red, colors.lime)
    end
    local t1,t2,t3,t4 = ListMath(3)
    Page:add("Strip Mine", StripmineType, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(4)
    Page:add("Tunnel Mine", TunnelMineType, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(5)
    Page:add("Water Removal", WaterType, t1, t2, t3, t4, colors.red, colors.lime)
    --# draw the buttons
    Page:draw()

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    local t1,t2 = ListMath(2)
    term.setCursorPos(t1+1, t2+1)
    if ID == nil  then
        term.write("Default Style: " .. Style)
    else 
        term.write("Current Style: " .. Style)
    end
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            
            
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end
function MiningAreasList(PageNum)
    function MiningAreaPanel(ID)
        Area = LoadArea(ID)
        if Area ~= false then
            X1 = Area["X1"]
            Z1 = Area["Z1"]
            X2 = Area["X2"]
            Z2 = Area["Z2"]
        else
            X1 = 0
            Z1 = 0
            X2 = 0
            Z2 = 0
        end
        Delta = 1
        function Save()
            NewArea = {}
            if Area ~= false then
                NewArea = Area
            end
            NewArea["X1"] = X1
            NewArea["Z1"] = Z1
            NewArea["X2"] = X2
            NewArea["Z2"] = Z2
            SaveArea(ID,NewArea)
        end

        -- intialize button set on the monitor
        local Page = newPage(peripheral.getName(monitor))
        
        --# Drawing
            --# Init Buttons
                local t1,t2,t3,t4 = ListMath(1)
                Page:add("Back", MiningAreasList, t1,t2,t3,t4, colors.red, colors.lime)

                --XMin
                t1,t2,t3,t4 = GridMath(1,3)
                Page:add("X1-", function() X1 = X1 - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(3,3)
                Page:add("X1+", function() X1 = X1 + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
                --ZMin
                t1,t2,t3,t4 = GridMath(1,4)
                Page:add("Z1-", function() Z1 = Z1 - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(3,4)
                Page:add("Z1+", function() Z1 = Z1 + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
                --XMax
                t1,t2,t3,t4 = GridMath(5,3)
                Page:add("X2-", function() X2 = X2 - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(7,3)
                Page:add("X2+", function() X2 = X2 + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
                --ZMax
                t1,t2,t3,t4 = GridMath(5,4)
                Page:add("Z2-", function() Z2 = Z2 - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(7,4)
                Page:add("Z2+", function() Z2 = Z2 + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
                    
                --ΔChange
                t1,t2,t3,t4 = GridMath(1,5)
                Page:add("-1", function() Delta = Delta - 1  if Delta < 0 then Delta = 0 end end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(2,5)
                Page:add("-10", function() Delta = Delta - 10  if Delta < 0 then Delta = 0 end end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(3,5)
                Page:add("-100", function() Delta = Delta - 100 if Delta < 0 then Delta = 0 end end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(5,5)
                Page:add("+100", function() Delta = Delta + 100 end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(6,5)
                Page:add("+10", function() Delta = Delta + 10 end, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(7,5)
                Page:add("+1", function() Delta = Delta + 1 end, t1, t2, t3, t4, colors.red, colors.lime)



                t1,t2,t3,t4 = GridMath(1,6)
                Page:add("Save", Save, t1, t2, t3, t4, colors.red, colors.lime)
                t1,t2,t3,t4 = GridMath(2,6)
                Page:add("Reset", nil, t1, t2, t3, t4, colors.red, colors.lime)

                
                t1,t2,t3,t4 = GridMath(7,6)
                Page:add("Style", function() MiningStylesPanel(ID) end , t1, t2, t3, t4, colors.red, colors.lime)
            --                 
            Page:draw() --Draw seems to Clear term before drawing
            function DrawText()
                term.setBackgroundColor(colors.black)
                term.setTextColor(colors.white)
                --Coord 1
                t1,t2 = GridMath(2,2)
                term.setCursorPos(t1, t2+2)
                term.write("Coords 1")
                --Current Area
                t1,t2 = GridMath(3,2)
                term.setCursorPos(t1+1, t2+1)
                term.write("Current Area:")
                t1,t2 = GridMath(4,2)
                term.setCursorPos(t1+1, t2+2)
                term.write(Area["ID"])
                --Coord 2
                t1,t2 = GridMath(5,2)
                term.setCursorPos(t1, t2+2)
                term.write("Coords 2")
                --Current Delta Change
                t1,t2 = GridMath(4,5)
                term.setCursorPos(t1, t2+1)
                term.write(Delta)
                --Current XMin 
                t1,t2 = GridMath(2,3)
                term.setCursorPos(t1, t2+1)
                term.write(X1)
                --Current ZMin 
                t1,t2 = GridMath(2,4)
                term.setCursorPos(t1, t2+1)
                term.write(Z1)
                --Current XMin 
                t1,t2 = GridMath(6,3)
                term.setCursorPos(t1, t2+1)
                term.write(X2)
                --Current ZMin 
                t1,t2 = GridMath(6,4)
                term.setCursorPos(t1, t2+1)
                term.write(Z2)
                --Current Style
                t1,t2 = GridMath(3,6)
                term.setCursorPos(t1+1, t2+1)
                term.write("Current Style: " .. Area["Style"] )
                t1,t2 = GridMath(5,6)
                term.setCursorPos(t1, t2+2)
                if Area["Style"] == "Tunnel-Standard" then
                    term.write("@ Y " .. Area["Y"])
                end
            end
            DrawText()
        --
        while true do 
            DrawText()
            local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
            if event == "button_click" then
                
                
                
                if Page.buttonList[p1].func ~= nil then
                    Page.buttonList[p1].func()
                end
            end
        end
        
    end
    AvilSpace = math.floor(MonY / 4) - 4
    TotalAreas = #fs.find("/Knowledge/MineAreas/*")
    if PageNum == nil then PageNum = 0 end 
    if PageNum < 0 then PageNum = 0 end 
    if PageNum >= TotalAreas then PageNum = TotalAreas -1  end
    
    -- intialize button set on the monitor
    local Page = newPage(peripheral.getName(monitor))
    --# add buttons
        local t1,t2,t3,t4 = ListMath(1)
        Page:add("Back", MiningPanel, t1, t2, t3, t4, colors.red, colors.lime)
        t1,t2,t3,t4 = ListMath(2)
        Page:add("Up", function() MiningAreasList(PageNum-1) end, t1, t2, t3, t4, colors.red, colors.lime)

        
        
        if AvilSpace <= TotalAreas then
            AreasToPrint = AvilSpace
        else
            AreasToPrint = TotalAreas
        end
        for i=1,AreasToPrint do
            t1,t2,t3,t4 = ListMath(i+2)
            if i+PageNum <= TotalAreas then
                Page:add(tostring(i+PageNum), function() MiningAreaPanel(i+PageNum) end, t1, t2, t3, t4, colors.red, colors.lime)
            end
        end
        t1,t2,t3,t4 = ListMath(AvilSpace+3)
        Page:add("Down", function() MiningAreasList(PageNum+1) end, t1, t2, t3, t4, colors.red, colors.lime)
        t1,t2,t3,t4 = ListMath(AvilSpace+4)
        Page:add("New Area", function() MiningAreaPanel(TotalAreas+1) end, t1, t2, t3, t4, colors.red, colors.lime)

    --#
    -- draw the buttons
    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
    
end
function MiningAssignment(PageNum)
    function AssignmentPanel(ID)
        --# intialize button set on the monitor
        local Page = newPage(peripheral.getName(monitor))
        --# add buttons
        local t1,t2,t3,t4 = ListMath(1)
        Page:add("Back", MiningAssignment, t1, t2, t3, t4, colors.red, colors.lime)


        Area = LoadArea(ID)

        
        local Count = 1
        t1,t2,t3,t4 = GridMath(4,3)
        Page:add("Num-", function() Count = Count - 1 end, t1, t2, t3, t4, colors.red, colors.lime)
        t1,t2,t3,t4 = GridMath(6,3)
        Page:add("Num+", function() Count = Count + 1 end, t1, t2, t3, t4, colors.red, colors.lime)
        if Count < 1 then Count = 1 end
        

        function Slice(Count)
            XSpan = Area["X2"] - Area["X1"]            
            ZSpan = Area["Z2"] - Area["Z1"] 

            SliceX = math.floor(XSpan / Count)
            SliceZ = math.floor(ZSpan / Count)

            LSliceX1 = Area["X1"]
            LSliceZ1 = Area["Z1"]
            Area["Slices"] = {}
            for X=1,Count do
                LSliceX1 = LSliceX1
                if i ~= Count then
                    LSliceX2 = LSliceX1 + SliceX
                else
                    LSliceX2 = Area["X2"]
                end
                for Z=1,Count do
                    term.setCursorPos(1, 1)

                    LSliceZ1 = LSliceZ1
                    if i ~= Count then
                        LSliceZ2 = LSliceZ1 + SliceZ
                    else
                        LSliceZ2 = Area["Z2"]
                    end
                    local CurSlice = {
                        X1 = LSliceX1,
                        Z1 = LSliceZ1,
                        X2 = LSliceX2,
                        Z2 = LSliceZ2
                    }
                    table.insert(Area["Slices"], CurSlice)
                    print(#Area["Slices"])
                    LSliceX1 = LSliceX2 + 1
                    LSliceZ1 = LSliceZ2 + 1
                end
            end
            rednet.broadcast(Area, "TestingOrder")
        end

        t1,t2,t3,t4 = GridMath(3,3)
        Page:add("Send", function() Slice(Count) end, t1, t2, t3, t4, colors.red, colors.lime)

        --# draw the buttons
        Page:draw()
        
        function DrawText()
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
            
            t1,t2 = GridMath(5,3)
            term.setCursorPos(t1, t2+1)
            term.write("     ") -- removes the left over numbers
            term.setCursorPos(t1, t2+1)
            term.write(tostring(Count))
        end

        while true do 
            DrawText()
            local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
            if event == "button_click" then
                
                
                if Page.buttonList[p1].func ~= nil then
                    Page.buttonList[p1].func()
                end
            end
            if Count < 1 then Count = 1 end
        end
    end
    AvilSpace = math.floor(MonY / 4) - 3
    TotalAreas = #fs.find("/Knowledge/MineAreas/*")
    if PageNum == nil then PageNum = 0 end 
    if PageNum < 0 then PageNum = 0 end 
    if PageNum >= TotalAreas then PageNum = TotalAreas -1  end
    
    local Page = newPage(peripheral.getName(monitor))
    --# add buttons
    local t1,t2,t3,t4 = ListMath(1)
    Page:add("Back", MiningPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = ListMath(2)
    Page:add("Up", function() MiningAssignment(PageNum-1) end, t1, t2, t3, t4, colors.red, colors.lime)

    
    
    if AvilSpace <= TotalAreas then
        AreasToPrint = AvilSpace
    else
        AreasToPrint = TotalAreas
    end
    for i=1,AreasToPrint do
        t1,t2,t3,t4 = ListMath(i+2)
        if i+PageNum <= TotalAreas then
            Page:add(tostring(i+PageNum), function() AssignmentPanel(i+PageNum) end, t1, t2, t3, t4, colors.red, colors.lime)
        end
    end

    t1,t2,t3,t4 = ListMath(AvilSpace+3)
    Page:add("Down", function() MiningAssignment(PageNum+1) end, t1, t2, t3, t4, colors.red, colors.lime)

    --#
    -- draw the buttons
    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end

--Mining Styles
function StripmineType()
    local Page = newPage(peripheral.getName(monitor))
    local t1,t2,t3,t4 = ListMath(1)
    Page:add("Back", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(2)
    Page:add("Single Turtle", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(3)
    Page:add("Strip Split", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(4)
    Page:add("3x3 Holes", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(5)
    Page:add("Bore Holes", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            
            if p1 == "Single Turtle" then
                Style = "Strip-1Turtle"
            elseif p1 == "Strip Split" then
                Style = "Strip-Split"
            elseif p1 == "3x3 Holes" then
                Style = "Strip-3x3"
            elseif p1 == "Bore Holes" then
                Style = "Strip-Bore"
            end
            if ID == nil then
                DefaultStyle = Style
            else
                Area = LoadArea(ID)
                Area["Style"] = Style
            end
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
    
end
function TunnelMineType()
    if ID ~= nil then
        local Area = LoadArea(ID)
        TempMiningY = Area["Y"]
    else
        TempMiningY = DefaultMiningY
    end
    --Add Buttons
    local Page = newPage(peripheral.getName(monitor))
    local t1,t2,t3,t4 = ListMath(1)
    Page:add("Back", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(2)
    Page:add("Save", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = GridMath(3,3)
    Page:add("Y+", nil, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = GridMath(5,3)
    Page:add("Y-", nil, t1, t2, t3, t4, colors.red, colors.lime)
    --
    Page:draw()
    -- Draw Text
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        local t1,t2 = GridMath(3,2)
        term.setCursorPos(t1+2, t2+2)
        term.write("Default Mining Level")
        local t1,t2 = GridMath(4,3)
        term.setCursorPos(t1+2, t2+1)
        term.write(TempMiningY)
    --
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            if p1 == "Save" then
                if ID == nil then
                    DefaultStyle = "Tunnel-Standard"
                    DefaultMiningY = TempMiningY
                else
                    Area["Style"] = "Tunnel-Standard"
                    Area["Y"] = TempMiningY
                    SaveArea(ID,Area)
                end
            elseif p1 == "Y+" then
                TempMiningY = TempMiningY + 1
                local t1,t2 = GridMath(4,3)
                term.setCursorPos(t1, t2+1)
                term.write("    ") -- Localized Clear()
                term.setCursorPos(t1+2, t2+1)
                term.write(TempMiningY)
            elseif p1 == "Y-" then
                TempMiningY = TempMiningY - 1
                local t1,t2 = GridMath(4,3)
                term.setCursorPos(t1, t2+1)
                term.write("    ") -- Localized Clear()
                term.setCursorPos(t1+2, t2+1)
                term.write(TempMiningY)
            end
            if ID == nil then
                DefaultStyle = Style
            else
                Area = LoadArea(ID)
                Area["Style"] = Style
                SaveArea(ID,Area)
            end
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end
function WaterType()
    local Page = newPage(peripheral.getName(monitor))
    local t1,t2,t3,t4 = ListMath(1) 
    Page:add("Back", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(2)
    Page:add("Block Remove", nil, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(3)
    Page:add("Turtle Mover", nil, t1, t2, t3, t4, colors.red, colors.lime)
    local t1,t2,t3,t4 = ListMath(4)
    Page:add("Sponge Remove", nil, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()
    while true do 
        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
        if event == "button_click" then
            if p1 == "Block Remove" then
                Style = "Water-Block"
            elseif p1 == "Turtle Mover" then
                Style = "Water-Mover"
            elseif p1 == "Sponge Remove" then
                Style = "Water-Sponge"
            end
            if ID == nil then
                DefaultStyle = Style
            else
                Area = LoadArea(ID)
                Area["Style"] = Style
            end
            if Page.buttonList[p1].func ~= nil then
                Page.buttonList[p1].func()
            end
        end
    end
end

 


--API Functions
function MD.Draw()
    monitor = peripheral.find("monitor")
    monitor.setTextScale(0.5)
    term.redirect(monitor)
    
    MonX, MonY = monitor.getSize()
    FourPanX = math.floor((MonX/2)-1)
    FourPanY = math.floor((MonY/2)-1)

    if monitor.isColor() then -- Is advanced
        LandingPanel()
    else -- Standard
        term.native().clear()
        term.native().setCursorPos(1, 1)
        term.native().write("Requires Advanced Monitors for commands")
        term.native().setCursorPos(1, 2)
        term.native().write("Opening Stats")
        StatsPanel()
    end
end


return MD