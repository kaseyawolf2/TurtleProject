if term.isColor() then -- if advanced
    if not multishell then -- Check if we can access multishell
        --If we cant access multishell then we are most likely in a multishell
        --If we are in a multishell, Require wont work
        MD, AF, touchpoint = ... -- you need to pass them in to multi shell
    else
        --not in a multishell so require the APIs 
        MD = require("/LocalGit/APIs/MD")
        AF = require("/LocalGit/APIs/AF")
        touchpoint = require("/LocalGit/ExternalPrograms/Touchpoint")
    end
else
    --not in a advanced pc so just require the APIs 
    MD = require("/LocalGit/APIs/MD")
    AF = require("/LocalGit/APIs/AF")
    touchpoint = require("/LocalGit/ExternalPrograms/Touchpoint")
end

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

-- Function to handle page drawing and event handling
local function handlePage(Page)
    Page:draw()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        local buttonEvent, buttonName = page:handleEvents(event, side, x, y)
        if buttonEvent then
            term.native().write(string.format("Button Event: %s, Button Name: %s, X: %d, Y: %d\n", buttonEvent, buttonName, x, y))
            return buttonEvent, buttonName
        end
    end
end

-- Function to add the back button
local function addBackButton(Page, func)
    local t1, t2, t3, t4 = MD.getListMath(1)
    Page:add("Back", func, t1, t2, t3, t4, colors.red, colors.lime)
end

-- Function to handle coordinate controls
local function addCoordinateControls(Page, coords, delta)
    local function addControl(label, func, gridX, gridY)
        local t1, t2, t3, t4 = MD.getGridMath(gridX, gridY)
        Page:add(label, func, t1, t2, t3, t4, colors.red, colors.lime)
    end

    addControl("X1-", function() coords.X1 = coords.X1 - delta end, 1, 3)
    addControl("X1+", function() coords.X1 = coords.X1 + delta end, 3, 3)
    addControl("Z1-", function() coords.Z1 = coords.Z1 - delta end, 1, 4)
    addControl("Z1+", function() coords.Z1 = coords.Z1 + delta end, 3, 4)
    addControl("X2-", function() coords.X2 = coords.X2 - delta end, 5, 3)
    addControl("X2+", function() coords.X2 = coords.X2 + delta end, 7, 3)
    addControl("Z2-", function() coords.Z2 = coords.Z2 - delta end, 5, 4)
    addControl("Z2+", function() coords.Z2 = coords.Z2 + delta end, 7, 4)
end

--Start Page
function LandingPanel()
    local Page = MD.createPage()
    Page:add("Update Panel", UpdatePanel, 2, 2, FourPanX, FourPanY, colors.red, colors.lime)
    Page:add("Drone Controls", DronePanel, FourPanX+2, 2, MonX-1, FourPanY, colors.red, colors.lime)
    Page:add("Mining Controls", MiningPanel, 2, FourPanY+2, FourPanX, MonY-1, colors.red, colors.lime)
    Page:add("Statistics", StatsPanel, FourPanX+2, FourPanY+2, MonX-1, MonY-1, colors.red, colors.lime)
    handlePage(Page)
end

--Base Panels
function UpdatePanel()
    local Page = MD.createPage()
    addBackButton(Page, LandingPanel)
    Page:add("Sync Turtles", function() rednet.broadcast("Update All Turtles", "TurtleUpdate") end, 2, 2, 3, 3, colors.red, colors.lime)
    Page:add("Sync Mainframes", nil, 4, 4, 5, 5, colors.red, colors.lime)
    Page:add("Sync All", nil, 6, 6, 7, 7, colors.red, colors.lime)
    Page:add("Download Updates", function() shell.run("/LocalGit/Installer/Installer.lua") term.write("Updating And Rebooting") end, 8, 8, 9, 9, colors.red, colors.lime)
    handlePage(Page)
end

function DronePanel()
    local Page = MD.createPage()
    addBackButton(Page, LandingPanel)
    Page:add("1", nil, 2, 2, 3, 3, colors.red, colors.lime)
    Page:add("2", nil, 4, 4, 5, 5, colors.red, colors.lime)
    Page:add("3", nil, 6, 6, 7, 7, colors.red, colors.lime)
    handlePage(Page)
end

function StatsPanel()
    local Page = MD.createPage()
    addBackButton(Page, LandingPanel)
    handlePage(Page)
end

-- Mining System Functions
function MiningPanel()
    local Page = MD.createPage()
    addBackButton(Page, LandingPanel)
    Page:add("Default Mining Style", MiningStylesPanel, 2, 2, 3, 3, colors.red, colors.lime)
    Page:add("Mining Areas", MiningAreasList, 4, 4, 5, 5, colors.red, colors.lime)
    Page:add("Ore Dropoff", MiningDepositList, 6, 6, 7, 7, colors.red, colors.lime)
    Page:add("Assignments", MiningAssignment, 8, 8, 9, 9, colors.red, colors.lime)
    handlePage(Page)
end

function MiningStylesPanel(ID)
    if ID == nil then
       Style = DefaultStyle
    else
        Area = AF.LoadArea(ID)
        Style = Area["Style"]
    end

    local Page = MD.createPage()
    if ID == nil then
        addBackButton(Page, MiningPanel)
    else
        addBackButton(Page, function() MiningAreaPanel(ID) end)
    end
    Page:add("Strip Mine", StripmineType, 3, 3, 4, 4, colors.red, colors.lime)
    Page:add("Tunnel Mine", TunnelMineType, 5, 5, 6, 6, colors.red, colors.lime)
    Page:add("Water Removal", WaterType, 7, 7, 8, 8, colors.red, colors.lime)
    Page:draw()

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    local t1, t2 = MD.getListMath(2)
    term.setCursorPos(t1+1, t2+1)
    if ID == nil then
        term.write("Default Style: " .. Style)
    else 
        term.write("Current Style: " .. Style)
    end
    
    while true do 
        local event, p1 = MD.handlePageEvents(Page)
        if event == "button_click" and Page.buttonList[p1].func then
            print("Button Click") --DEBUG
            Page.buttonList[p1].func()
        end
    end
end

function StripmineType()
    local Page = MD.createPage()
    addBackButton(Page, MiningStylesPanel)
    Page:add("Single Turtle", MiningStylesPanel, 2, 2, 3, 3, colors.red, colors.lime)
    Page:add("Strip Split", MiningStylesPanel, 4, 4, 5, 5, colors.red, colors.lime)
    Page:add("3x3 Holes", MiningStylesPanel, 6, 6, 7, 7, colors.red, colors.lime)
    Page:add("Bore Holes", MiningStylesPanel, 8, 8, 9, 9, colors.red, colors.lime)
    handlePage(Page)
end

function TunnelMineType()
    if ID ~= nil then
        local Area = AF.LoadArea(ID)
        TempMiningY = Area["Y"]
    else
        TempMiningY = DefaultMiningY
    end

    local Page = MD.createPage()
    addBackButton(Page, MiningStylesPanel)
    Page:add("Save", MiningStylesPanel, 2, 2, 3, 3, colors.red, colors.lime)
    Page:add("Y+", nil, 4, 4, 5, 5, colors.red, colors.lime)
    Page:add("Y-", nil, 6, 6, 7, 7, colors.red, colors.lime)
    Page:draw()

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    local t1, t2 = MD.getGridMath(3, 2)
    term.setCursorPos(t1+2, t2+2)
    term.write("Default Mining Level")
    t1, t2 = MD.getGridMath(4, 3)
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
                    AF.SaveArea(ID, Area)
                end
            elseif p1 == "Y+" then
                TempMiningY = TempMiningY + 1
                t1, t2 = MD.getGridMath(4, 3)
                term.setCursorPos(t1, t2+1)
                term.write("    ")
                term.setCursorPos(t1+2, t2+1)
                term.write(TempMiningY)
            elseif p1 == "Y-" then
                TempMiningY = TempMiningY - 1
                t1, t2 = MD.getGridMath(4, 3)
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
                AF.SaveArea(ID, Area)
            end
            if Page.buttonList[p1].func then
                Page.buttonList[p1].func()
            end
        end
    end
end

function WaterType()
    local Page = MD.createPage()
    addBackButton(Page, MiningStylesPanel)
    Page:add("Block Remove", nil, 2, 2, 3, 3, colors.red, colors.lime)
    Page:add("Turtle Mover", nil, 4, 4, 5, 5, colors.red, colors.lime)
    Page:add("Sponge Remove", nil, 6, 6, 7, 7, colors.red, colors.lime)
    handlePage(Page)
end

function MiningAreasList(PageNum)
    local AvilSpace = math.floor(MonY / 4) - 4
    local TotalAreas = #fs.find("/Knowledge/MineAreas/*")
    PageNum = PageNum or 0
    if PageNum < 0 then PageNum = 0 end 
    if PageNum >= TotalAreas then PageNum = TotalAreas - 1 end
    
    local Page = MD.createPage()
    addBackButton(Page, MiningPanel)
    Page:add("Up", function() MiningAreasList(PageNum-1) end, 2, 2, 3, 3, colors.red, colors.lime)
    
    local AreasToPrint = math.min(AvilSpace, TotalAreas)
    for i=1,AreasToPrint do
        local t1, t2, t3, t4 = MD.getListMath(i+2)
        if i+PageNum <= TotalAreas then
            Page:add(tostring(i+PageNum), function() MiningAreaPanel(i+PageNum) end, t1, t2, t3, t4, colors.red, colors.lime)
        end
    end
    
    Page:add("Down", function() MiningAreasList(PageNum+1) end, 4, 4, 5, 5, colors.red, colors.lime)
    Page:add("New Area", function() MiningAreaPanel(TotalAreas+1) end, 6, 6, 7, 7, colors.red, colors.lime)
    handlePage(Page)
end

function MiningAreaPanel(ID)
    local Area = AF.LoadArea(ID)
    local coords = {X1 = Area and Area["X1"] or 0, Z1 = Area and Area["Z1"] or 0, X2 = Area and Area["X2"] or 0, Z2 = Area and Area["Z2"] or 0}
    local Delta = 1

    local function Save()
        local NewArea = Area or {}
        NewArea["X1"], NewArea["Z1"] = coords.X1, coords.Z1
        NewArea["X2"], NewArea["Z2"] = coords.X2, coords.Z2
        AF.SaveArea(ID, NewArea)
    end

    local Page = MD.createPage()
    addBackButton(Page, MiningAreasList)
    Page:add("Save", Save, 6, 6, 7, 7, colors.red, colors.lime)
    Page:add("Style", function() MiningStylesPanel(ID) end, 8, 8, 9, 9, colors.red, colors.lime)
    addCoordinateControls(Page, coords, Delta)
    handlePage(Page)
end

function MiningDepositList(PageNum)
    local AvilSpace = math.floor(MonY / 4) - 4
    local TotalAreas = #fs.find("/Knowledge/MineAreas/*")
    PageNum = PageNum or 0
    if PageNum < 0 then PageNum = 0 end 
    if PageNum >= TotalAreas then PageNum = TotalAreas - 1 end
    
    local Page = MD.createPage()
    addBackButton(Page, MiningPanel)
    Page:add("Up", function() MiningDepositList(PageNum-1) end, 2, 2, 3, 3, colors.red, colors.lime)
    
    local AreasToPrint = math.min(AvilSpace, TotalAreas)
    for i=1,AreasToPrint do
        local t1, t2, t3, t4 = MD.getListMath(i+2)
        if i+PageNum <= TotalAreas then
            Page:add(tostring(i+PageNum), function() MiningDepositPanel(i+PageNum) end, t1, t2, t3, t4, colors.red, colors.lime)
        end
    end
    
    Page:add("Down", function() MiningDepositList(PageNum+1) end, 4, 4, 5, 5, colors.red, colors.lime)
    Page:add("New Deposit", function() MiningDepositPanel(TotalAreas+1) end, 6, 6, 7, 7, colors.red, colors.lime)
    handlePage(Page)
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
    addBackButton(Page, MiningDepositList)
    Page:add("Save", Save, 6, 6, 7, 7, colors.red, colors.lime)

    -- Coordinate controls
    local function addControl(label, func, gridX, gridY)
        local t1, t2, t3, t4 = MD.getGridMath(gridX, gridY)
        Page:add(label, func, t1, t2, t3, t4, colors.red, colors.lime)
    end

    addControl("X-", function() X = X - Delta end, 1, 3)
    addControl("X+", function() X = X + Delta end, 3, 3)
    addControl("Z-", function() Z = Z - Delta end, 1, 4)
    addControl("Z+", function() Z = Z + Delta end, 3, 4)
    addControl("Y-", function() Y = Y - Delta end, 5, 3)
    addControl("Y+", function() Y = Y + Delta end, 7, 3)

    -- Delta controls
    addControl("-1", function() Delta = math.max(0, Delta - 1) end, 1, 5)
    addControl("-10", function() Delta = math.max(0, Delta - 10) end, 2, 5)
    addControl("-100", function() Delta = math.max(0, Delta - 100) end, 3, 5)
    addControl("+100", function() Delta = Delta + 100 end, 5, 5)
    addControl("+10", function() Delta = Delta + 10 end, 6, 5)
    addControl("+1", function() Delta = Delta + 1 end, 7, 5)

    handlePage(Page)
end

function MiningAssignment(PageNum)
    local AvilSpace = math.floor(MonY / 4) - 3
    local TotalAreas = #fs.find("/Knowledge/MineAreas/*")
    PageNum = PageNum or 0
    if PageNum < 0 then PageNum = 0 end 
    if PageNum >= TotalAreas then PageNum = TotalAreas - 1 end
    
    local Page = MD.createPage()
    addBackButton(Page, MiningPanel)
    Page:add("Up", function() MiningAssignment(PageNum-1) end, 2, 2, 3, 3, colors.red, colors.lime)
    
    local AreasToPrint = math.min(AvilSpace, TotalAreas)
    for i=1,AreasToPrint do
        local t1, t2, t3, t4 = MD.getListMath(i+2)
        if i+PageNum <= TotalAreas then
            Page:add(tostring(i+PageNum), function() AssignmentPanel(i+PageNum) end, t1, t2, t3, t4, colors.red, colors.lime)
        end
    end
    
    Page:add("Down", function() MiningAssignment(PageNum+1) end, 4, 4, 5, 5, colors.red, colors.lime)

    handlePage(Page)
end

function AssignmentPanel(ID)
    local Area = AF.LoadArea(ID)
    local Count = 1

    local Page = MD.createPage()
    addBackButton(Page, MiningAssignment)

    local t1, t2, t3, t4 = MD.getGridMath(4, 3)
    Page:add("Num-", function() Count = math.max(1, Count - 1) end, t1, t2, t3, t4, colors.red, colors.lime)
    t1, t2, t3, t4 = MD.getGridMath(6, 3)
    Page:add("Num+", function() Count = Count + 1 end, t1, t2, t3, t4, colors.red, colors.lime)

    t1, t2, t3, t4 = MD.getGridMath(3, 3)
    Page:add("Slice", function() AF.SliceArea(ID, Count) end, t1, t2, t3, t4, colors.red, colors.lime)

    handlePage(Page)
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
