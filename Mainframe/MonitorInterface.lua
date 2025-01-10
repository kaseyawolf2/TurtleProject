if term.isColor() then -- if advanced
    if not multishell then -- and doesnt have access to Multishell 
        --we are in a multishell so Require dont work
        MD = ... -- you need to pass them in to multi shell
    else
        --not in a muiltishell so require the APIs 
        MD = require("/LocalGit/APIs/MD")
    end
else
    --not in a advanced pc so just require the APIs 
    MD = require("/LocalGit/APIs/MD")
end

-- Dependencies
local AF = require("/LocalGit/APIs/AF")

-- Global variables
local monitor, MonX, MonY, FourPanX, FourPanY
local DefaultStyle = "Strip-1Turtle"
local DefaultMiningY = 11
local Style = DefaultStyle
local ID -- Current mining area ID
local Area -- Current mining area data
local TempMiningY -- Temporary Y value for mining

-- Forward declarations for interdependent functions
local LandingPanel, UpdatePanel, DronePanel, StatsPanel
local MiningPanel, MiningStylesPanel, MiningAreasList, MiningDepositList, MiningAssignment
local MiningAreaPanel, StripmineType, TunnelMineType, WaterType

--Start Page
function LandingPanel()
    local Page = MD.createPage()
    Page:add("Update Panel", UpdatePanel, 2, 2, FourPanX, FourPanY, colors.red, colors.lime)
    Page:add("Drone Controls", DronePanel, FourPanX+2, 2, MonX-1, FourPanY, colors.red, colors.lime)
    Page:add("Mining Controls", MiningPanel, 2, FourPanY+2, FourPanX, MonY-1, colors.red, colors.lime)
    Page:add("Statistics", StatsPanel, FourPanX+2, FourPanY+2, MonX-1, MonY-1, colors.red, colors.lime)
    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

--Base Panels
function UpdatePanel()
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", LandingPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("Sync Turtles", function() rednet.broadcast("Update All Turtles" , "TurtleUpdate") end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(3)
    Page:add("Sync Mainframes", nil, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(4)
    Page:add("Sync All", nil, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(5)
    Page:add("Download Updates", function() shell.run("/LocalGit/Installer/Installer.lua") term.write("Updating And Rebooting") end, t1, t2, t3, t4, colors.red, colors.lime)
    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function DronePanel()
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", LandingPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("1", nil, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(3)
    Page:add("2", nil, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(4)
    Page:add("3", nil, t1, t2, t3, t4, colors.red, colors.lime)
    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function StatsPanel()
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", LandingPanel, t1, t2, t3, t4, colors.red, colors.lime)
    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

-- Mining System Functions
function MiningPanel()
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", LandingPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("Default Mining Style", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(3)
    Page:add("Mining Areas", MiningAreasList, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(4)
    Page:add("Ore Dropoff", MiningDepositList, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(5)
    Page:add("Assignments", MiningAssignment, t1, t2, t3, t4, colors.red, colors.lime)
    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function MiningStylesPanel(ID)
    if ID == nil then
       Style = DefaultStyle
    else
        Area = AF.LoadArea(ID)
        Style = Area["Style"]
    end

    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    if ID == nil then
        Page:add("Back", MiningPanel, t1, t2, t3, t4, colors.red, colors.lime)
    else
        Page:add("Back", function() MiningAreaPanel(ID) end, t1, t2, t3, t4, colors.red, colors.lime)
    end
    t1,t2,t3,t4 = MD.getListMath(3)
    Page:add("Strip Mine", StripmineType, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(4)
    Page:add("Tunnel Mine", TunnelMineType, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(5)
    Page:add("Water Removal", WaterType, t1, t2, t3, t4, colors.red, colors.lime)
    Page:draw()

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    t1,t2 = MD.getListMath(2)
    term.setCursorPos(t1+1, t2+1)
    if ID == nil then
        term.write("Default Style: " .. Style)
    else 
        term.write("Current Style: " .. Style)
    end
    
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function StripmineType()
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("Single Turtle", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(3)
    Page:add("Strip Split", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(4)
    Page:add("3x3 Holes", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(5)
    Page:add("Bore Holes", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
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
                Area = AF.LoadArea(ID)
                Area["Style"] = Style
                AF.SaveArea(ID,Area)
            end
            if Page.buttonList[p1].func then
                Page.buttonList[p1].func()
            end
        end
    end
end

function TunnelMineType()
    if ID ~= nil then
        local Area = AF.LoadArea(ID)
        TempMiningY = Area["Y"]
    else
        TempMiningY = DefaultMiningY
    end

    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("Save", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(3,3)
    Page:add("Y+", nil, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(5,3)
    Page:add("Y-", nil, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    t1,t2 = MD.getGridMath(3,2)
    term.setCursorPos(t1+2, t2+2)
    term.write("Default Mining Level")
    t1,t2 = MD.getGridMath(4,3)
    term.setCursorPos(t1+2, t2+1)
    term.write(TempMiningY)

    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" then
            if p1 == "Save" then
                if ID == nil then
                    DefaultStyle = "Tunnel-Standard"
                    DefaultMiningY = TempMiningY
                else
                    Area["Style"] = "Tunnel-Standard"
                    Area["Y"] = TempMiningY
                    AF.SaveArea(ID,Area)
                end
            elseif p1 == "Y+" then
                TempMiningY = TempMiningY + 1
                t1,t2 = MD.getGridMath(4,3)
                term.setCursorPos(t1, t2+1)
                term.write("    ")
                term.setCursorPos(t1+2, t2+1)
                term.write(TempMiningY)
            elseif p1 == "Y-" then
                TempMiningY = TempMiningY - 1
                t1,t2 = MD.getGridMath(4,3)
                term.setCursorPos(t1, t2+1)
                term.write("    ")
                term.setCursorPos(t1+2, t2+1)
                term.write(TempMiningY)
            end
            if ID == nil then
                DefaultStyle = Style
            else
                Area = AF.LoadArea(ID)
                Area["Style"] = Style
                AF.SaveArea(ID,Area)
            end
            if Page.buttonList[p1].func then
                Page.buttonList[p1].func()
            end
        end
    end
end

function WaterType()
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningStylesPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("Block Remove", nil, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(3)
    Page:add("Turtle Mover", nil, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(4)
    Page:add("Sponge Remove", nil, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
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
                Area = AF.LoadArea(ID)
                Area["Style"] = Style
                AF.SaveArea(ID,Area)
            end
            if Page.buttonList[p1].func then
                Page.buttonList[p1].func()
            end
        end
    end
end

function MiningAreasList(PageNum)
    local AvilSpace = math.floor(MonY / 4) - 4
    local TotalAreas = #fs.find("/Knowledge/MineAreas/*")
    PageNum = PageNum or 0
    if PageNum < 0 then PageNum = 0 end 
    if PageNum >= TotalAreas then PageNum = TotalAreas - 1 end
    
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("Up", function() MiningAreasList(PageNum-1) end, t1, t2, t3, t4, colors.red, colors.lime)
    
    local AreasToPrint = math.min(AvilSpace, TotalAreas)
    for i=1,AreasToPrint do
        t1,t2,t3,t4 = MD.getListMath(i+2)
        if i+PageNum <= TotalAreas then
            Page:add(tostring(i+PageNum), function() MiningAreaPanel(i+PageNum) end, t1, t2, t3, t4, colors.red, colors.lime)
        end
    end
    
    t1,t2,t3,t4 = MD.getListMath(AvilSpace+3)
    Page:add("Down", function() MiningAreasList(PageNum+1) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(AvilSpace+4)
    Page:add("New Area", function() MiningAreaPanel(TotalAreas+1) end, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function MiningAreaPanel(ID)
    local Area = AF.LoadArea(ID)
    local X1, Z1, X2, Z2
    if Area then
        X1, Z1 = Area["X1"], Area["Z1"]
        X2, Z2 = Area["X2"], Area["Z2"]
    else
        X1, Z1, X2, Z2 = 0, 0, 0, 0
    end
    local Delta = 1

    local function Save()
        local NewArea = Area or {}
        NewArea["X1"], NewArea["Z1"] = X1, Z1
        NewArea["X2"], NewArea["Z2"] = X2, Z2
        AF.SaveArea(ID, NewArea)
    end

    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningAreasList, t1,t2,t3,t4, colors.red, colors.lime)

    -- Coordinate controls
    t1,t2,t3,t4 = MD.getGridMath(1,3)
    Page:add("X1-", function() X1 = X1 - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(3,3)
    Page:add("X1+", function() X1 = X1 + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    
    t1,t2,t3,t4 = MD.getGridMath(1,4)
    Page:add("Z1-", function() Z1 = Z1 - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(3,4)
    Page:add("Z1+", function() Z1 = Z1 + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    
    t1,t2,t3,t4 = MD.getGridMath(5,3)
    Page:add("X2-", function() X2 = X2 - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(7,3)
    Page:add("X2+", function() X2 = X2 + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    
    t1,t2,t3,t4 = MD.getGridMath(5,4)
    Page:add("Z2-", function() Z2 = Z2 - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(7,4)
    Page:add("Z2+", function() Z2 = Z2 + Delta end, t1, t2, t3, t4, colors.red, colors.lime)

    -- Delta controls
    t1,t2,t3,t4 = MD.getGridMath(1,5)
    Page:add("-1", function() Delta = math.max(0, Delta - 1) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(2,5)
    Page:add("-10", function() Delta = math.max(0, Delta - 10) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(3,5)
    Page:add("-100", function() Delta = math.max(0, Delta - 100) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(5,5)
    Page:add("+100", function() Delta = Delta + 100 end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(6,5)
    Page:add("+10", function() Delta = Delta + 10 end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(7,5)
    Page:add("+1", function() Delta = Delta + 1 end, t1, t2, t3, t4, colors.red, colors.lime)

    t1,t2,t3,t4 = MD.getGridMath(1,6)
    Page:add("Save", Save, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(7,6)
    Page:add("Style", function() MiningStylesPanel(ID) end, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()

    local function DrawText()
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        
        t1,t2 = MD.getGridMath(2,2)
        term.setCursorPos(t1, t2+2)
        term.write("Coords 1")
        
        t1,t2 = MD.getGridMath(3,2)
        term.setCursorPos(t1+1, t2+1)
        term.write("Current Area:")
        t1,t2 = MD.getGridMath(4,2)
        term.setCursorPos(t1+1, t2+2)
        term.write(Area and Area["ID"] or "New")
        
        t1,t2 = MD.getGridMath(5,2)
        term.setCursorPos(t1, t2+2)
        term.write("Coords 2")
        
        t1,t2 = MD.getGridMath(4,5)
        term.setCursorPos(t1, t2+1)
        term.write(Delta)
        
        t1,t2 = MD.getGridMath(2,3)
        term.setCursorPos(t1, t2+1)
        term.write(X1)
        t1,t2 = MD.getGridMath(2,4)
        term.setCursorPos(t1, t2+1)
        term.write(Z1)
        t1,t2 = MD.getGridMath(6,3)
        term.setCursorPos(t1, t2+1)
        term.write(X2)
        t1,t2 = MD.getGridMath(6,4)
        term.setCursorPos(t1, t2+1)
        term.write(Z2)
    end

    while true do 
        DrawText()
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function MiningDepositList(PageNum)
    local AvilSpace = math.floor(MonY / 4) - 4
    local TotalAreas = #fs.find("/Knowledge/MineAreas/*")
    PageNum = PageNum or 0
    if PageNum < 0 then PageNum = 0 end 
    if PageNum >= TotalAreas then PageNum = TotalAreas - 1 end
    
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("Up", function() MiningDepositList(PageNum-1) end, t1, t2, t3, t4, colors.red, colors.lime)
    
    local AreasToPrint = math.min(AvilSpace, TotalAreas)
    for i=1,AreasToPrint do
        t1,t2,t3,t4 = MD.getListMath(i+2)
        if i+PageNum <= TotalAreas then
            Page:add(tostring(i+PageNum), function() MiningDepositPanel(i+PageNum) end, t1, t2, t3, t4, colors.red, colors.lime)
        end
    end
    
    t1,t2,t3,t4 = MD.getListMath(AvilSpace+3)
    Page:add("Down", function() MiningDepositList(PageNum+1) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(AvilSpace+4)
    Page:add("New Deposit", function() MiningDepositPanel(TotalAreas+1) end, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function MiningDepositPanel(ID)
    local Area = AF.LoadArea(ID)
    local X, Y, Z, Delta = 0, 0, 0, 1
    
    if Area and Area["Deposits"] then
        X = Area["Deposits"]["X"]
        Y = Area["Deposits"]["Y"]
        Z = Area["Deposits"]["Z"]
    else
        X, Y, Z = gps.locate(5)
    end

    local function Save()
        if not Area["Deposits"] then Area["Deposits"] = {} end
        Area["Deposits"]["X"] = X
        Area["Deposits"]["Y"] = Y
        Area["Deposits"]["Z"] = Z
        AF.SaveArea(ID, Area)
    end

    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningDepositList, t1,t2,t3,t4, colors.red, colors.lime)

    -- Coordinate controls
    t1,t2,t3,t4 = MD.getGridMath(1,3)
    Page:add("X-", function() X = X - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(3,3)
    Page:add("X+", function() X = X + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    
    t1,t2,t3,t4 = MD.getGridMath(1,4)
    Page:add("Z-", function() Z = Z - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(3,4)
    Page:add("Z+", function() Z = Z + Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    
    t1,t2,t3,t4 = MD.getGridMath(5,3)
    Page:add("Y-", function() Y = Y - Delta end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(7,3)
    Page:add("Y+", function() Y = Y + Delta end, t1, t2, t3, t4, colors.red, colors.lime)

    -- Delta controls
    t1,t2,t3,t4 = MD.getGridMath(1,5)
    Page:add("-1", function() Delta = math.max(0, Delta - 1) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(2,5)
    Page:add("-10", function() Delta = math.max(0, Delta - 10) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(3,5)
    Page:add("-100", function() Delta = math.max(0, Delta - 100) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(5,5)
    Page:add("+100", function() Delta = Delta + 100 end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(6,5)
    Page:add("+10", function() Delta = Delta + 10 end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(7,5)
    Page:add("+1", function() Delta = Delta + 1 end, t1, t2, t3, t4, colors.red, colors.lime)

    t1,t2,t3,t4 = MD.getGridMath(1,6)
    Page:add("Save", Save, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()

    local function DrawText()
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        
        t1,t2 = MD.getGridMath(3,2)
        term.setCursorPos(t1+1, t2+1)
        term.write("Current Area:")
        t1,t2 = MD.getGridMath(4,2)
        term.setCursorPos(t1+1, t2+2)
        term.write(Area["ID"])
        
        t1,t2 = MD.getGridMath(4,5)
        term.setCursorPos(t1, t2+1)
        term.write(Delta)
        
        t1,t2 = MD.getGridMath(2,3)
        term.setCursorPos(t1, t2+1)
        term.write(X)
        t1,t2 = MD.getGridMath(2,4)
        term.setCursorPos(t1, t2+1)
        term.write(Z)
        t1,t2 = MD.getGridMath(6,3)
        term.setCursorPos(t1, t2+1)
        term.write(Y)
    end

    while true do 
        DrawText()
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function MiningAssignment(PageNum)
    local AvilSpace = math.floor(MonY / 4) - 3
    local TotalAreas = #fs.find("/Knowledge/MineAreas/*")
    PageNum = PageNum or 0
    if PageNum < 0 then PageNum = 0 end 
    if PageNum >= TotalAreas then PageNum = TotalAreas - 1 end
    
    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningPanel, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getListMath(2)
    Page:add("Up", function() MiningAssignment(PageNum-1) end, t1, t2, t3, t4, colors.red, colors.lime)
    
    local AreasToPrint = math.min(AvilSpace, TotalAreas)
    for i=1,AreasToPrint do
        t1,t2,t3,t4 = MD.getListMath(i+2)
        if i+PageNum <= TotalAreas then
            Page:add(tostring(i+PageNum), function() AssignmentPanel(i+PageNum) end, t1, t2, t3, t4, colors.red, colors.lime)
        end
    end
    
    t1,t2,t3,t4 = MD.getListMath(AvilSpace+3)
    Page:add("Down", function() MiningAssignment(PageNum+1) end, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

function AssignmentPanel(ID)
    local Area = AF.LoadArea(ID)
    local Count = 1

    local Page = MD.createPage()
    local t1,t2,t3,t4 = MD.getListMath(1)
    Page:add("Back", MiningAssignment, t1, t2, t3, t4, colors.red, colors.lime)

    t1,t2,t3,t4 = MD.getGridMath(4,3)
    Page:add("Num-", function() Count = math.max(1, Count - 1) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1,t2,t3,t4 = MD.getGridMath(6,3)
    Page:add("Num+", function() Count = Count + 1 end, t1, t2, t3, t4, colors.red, colors.lime)

    t1,t2,t3,t4 = MD.getGridMath(3,3)
    Page:add("Slice", function() AF.SliceArea(ID,Count) end, t1, t2, t3, t4, colors.red, colors.lime)

    Page:draw()

    local function DrawText()
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        t1,t2 = MD.getGridMath(5,3)
        term.setCursorPos(t1, t2+1)
        term.write("     ")
        term.setCursorPos(t1, t2+1)
        term.write(Count)
    end

    while true do 
        DrawText()
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            Page.buttonList[p1].func()
        end
    end
end

-- Initialize monitor and start interface
local function Draw()
    monitor, MonX, MonY, FourPanX, FourPanY = MD.initializeMonitor()

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

Draw()
