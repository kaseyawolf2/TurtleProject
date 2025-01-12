--[[
    MonitorInterface.lua
    Handles the monitor-based user interface for the mining system.
    Provides panels for system updates, drone controls, mining operations, and statistics.
]]

-- Main program wrapped in vararg function to handle dependency injection
local function main(...)

-- Debug logging functionality
local DEBUG = true
local function log(...)
    if DEBUG then
        local args = {...}
        local msg = "[MonitorInterface] "
        for i, v in ipairs(args) do
            msg = msg .. tostring(v) .. " "
        end
        term.native().write("\n" .. msg .. "\n")
    end
end

-- Dependencies initialization with error handling
local function initializeDependencies(...)
    local function loadDependency(path, name)
        log("Loading dependency:", name, "from path:", path)
        local success, result = pcall(require, path)
        if not success then
            -- Format error message to be more readable
            local errorMsg = string.format("\nFailed to load %s:\n%s", name, result)
            log("Error:", errorMsg)
            error(errorMsg)
        end
        log("Successfully loaded dependency:", name)
        return result
    end

    if term.isColor() then -- Advanced computer
        if multishell then
            -- In multishell environment, dependencies are passed in
            log("Running in multishell environment, using passed dependencies")
            return ...
        end
    end
    -- IMPORTANT: All paths must use /LocalGit/ prefix for end device compatibility
    -- DO NOT change these paths - they are required for the program to work on the end device
    log("Loading dependencies normally")
    return 
        loadDependency("/LocalGit/APIs/MD", "MD"),
        loadDependency("/LocalGit/APIs/AF", "AF"),
        loadDependency("/LocalGit/ExternalPrograms/Touchpoint", "Touchpoint")
end

local MD, AF, touchpoint = initializeDependencies(...)
if not MD then
    error("Failed to load MD dependency - MD is nil")
end
if not AF then
    error("Failed to load AF dependency - AF is nil")
end
if not touchpoint then
    error("Failed to load Touchpoint dependency - Touchpoint is nil")
end
log("Dependencies loaded successfully")

-- Configuration
local Config = {
    defaultStyle = "Strip-1Turtle",
    defaultMiningY = 11,
    colors = {
        button = {
            background = colors.red,
            text = colors.lime
        },
        text = {
            background = colors.black,
            color = colors.white
        }
    }
}

-- State management
local State = {
    monitor = nil,
    monX = nil,
    monY = nil,
    fourPanX = nil,
    fourPanY = nil,
    currentStyle = Config.defaultStyle,
    currentAreaId = nil,
    currentArea = nil,
    tempMiningY = Config.defaultMiningY
}

-- UI Helper Functions
local UI = {
    handlePage = function(page)
        log("Drawing page")
        
        -- Save current terminal state
        local oldTerm = term.current()
        
        -- Ensure we're drawing to monitor
        term.redirect(State.monitor)
        State.monitor.setBackgroundColor(colors.black)
        State.monitor.clear()
        
        -- Draw the page
        page:draw()
        
        -- Handle events through MD module which manages terminal state
        local buttonEvent, buttonName = MD.handlePageEvents(page)
        
        -- Restore terminal before returning
        term.redirect(oldTerm)
        
        log("Button pressed:", buttonName)
        return buttonEvent, buttonName
    end,

    addBackButton = function(page, func)
        local t1, t2, t3, t4 = MD.getListMath(1)
        page:add(
            "Back",
            func,
            t1, t2, t3, t4,
            Config.colors.button.background,
            Config.colors.button.text
        )
    end,

    addCoordinateControls = function(page, coords, delta)
        local function addControl(label, func, gridX, gridY)
            local t1, t2, t3, t4 = MD.getGridMath(gridX, gridY)
            page:add(
                label,
                func,
                t1, t2, t3, t4,
                Config.colors.button.background,
                Config.colors.button.text
            )
        end

        -- X1 controls
        addControl("X1-", function() 
            coords.X1 = coords.X1 - delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 1, 3)
        addControl("X1+", function() 
            coords.X1 = coords.X1 + delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 3, 3)
        
        -- Z1 controls
        addControl("Z1-", function() 
            coords.Z1 = coords.Z1 - delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 1, 4)
        addControl("Z1+", function() 
            coords.Z1 = coords.Z1 + delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 3, 4)
        
        -- X2 controls
        addControl("X2-", function() 
            coords.X2 = coords.X2 - delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 5, 3)
        addControl("X2+", function() 
            coords.X2 = coords.X2 + delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 7, 3)
        
        -- Z2 controls
        addControl("Z2-", function() 
            coords.Z2 = coords.Z2 - delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 5, 4)
        addControl("Z2+", function() 
            coords.Z2 = coords.Z2 + delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 7, 4)
    end,

    displayText = function(text, gridX, gridY, offset)
        -- Save current terminal state
        local oldTerm = term.current()
        
        -- Ensure we're writing to monitor
        term.redirect(State.monitor)
        term.setBackgroundColor(Config.colors.text.background)
        term.setTextColor(Config.colors.text.color)
        
        local t1, t2 = MD.getGridMath(gridX, gridY)
        term.setCursorPos(t1 + (offset or 1), t2 + 1)
        term.write(text)
        
        -- Restore terminal
        term.redirect(oldTerm)
    end
}

-- Panel Implementations
local Panels = {
    -- Landing Panel
    landing = function()
        log("Opening Landing Panel")
        local page = MD.createPage()
        
        page:add(
            "Update Panel",
            Panels.update,
            2, 2, State.fourPanX, State.fourPanY,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        page:add(
            "Drone Controls",
            Panels.drone,
            State.fourPanX + 2, 2, State.monX - 1, State.fourPanY,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        page:add(
            "Mining Controls",
            Panels.mining,
            2, State.fourPanY + 2, State.fourPanX, State.monY - 1,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        page:add(
            "Statistics",
            Panels.stats,
            State.fourPanX + 2, State.fourPanY + 2, State.monX - 1, State.monY - 1,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        UI.handlePage(page)
    end,

    -- Update Panel
    update = function()
        log("Opening Update Panel")
        local page = MD.createPage()
        UI.addBackButton(page, Panels.landing)
        
        -- Sync Turtles button
        page:add(
            "Sync Turtles",
            function()
                -- Save current terminal state
                local oldTerm = term.current()
                term.redirect(term.native())
                
                log("Broadcasting turtle update")
                rednet.broadcast("Update All Turtles", "TurtleUpdate")
                
                -- Restore terminal
                term.redirect(oldTerm)
            end,
            2, 2, 3, 3,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        -- Download Updates button
        page:add(
            "Download Updates",
            function()
                -- Save current terminal state
                local oldTerm = term.current()
                term.redirect(term.native())
                
                log("Running installer")
                -- IMPORTANT: Path must use /LocalGit/ prefix for end device compatibility
                shell.run("/LocalGit/Installer/installer.lua")
                term.write("Updating And Rebooting")
                
                -- Restore terminal
                term.redirect(oldTerm)
            end,
            4, 4, 5, 5,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        UI.handlePage(page)
    end,

    -- Drone Panel
    drone = function()
        log("Opening Drone Panel")
        local page = MD.createPage()
        UI.addBackButton(page, Panels.landing)
        UI.handlePage(page)
    end,

    -- Stats Panel
    stats = function()
        log("Opening Stats Panel")
        local page = MD.createPage()
        UI.addBackButton(page, Panels.landing)
        UI.handlePage(page)
    end,

    -- Mining Panel
    mining = function()
        log("Opening Mining Panel")
        local page = MD.createPage()
        UI.addBackButton(page, Panels.landing)
        
        page:add(
            "Mining Areas",
            Panels.miningAreasList,
            2, 2, 3, 3,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        page:add(
            "Ore Dropoff",
            Panels.miningDepositList,
            4, 4, 5, 5,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        UI.handlePage(page)
    end,

    -- Mining Areas List Panel
    miningAreasList = function(pageNum)
        log("Opening Mining Areas List, page:", pageNum or 0)
        pageNum = pageNum or 0
        
        local availSpace = math.floor(State.monY / 4) - 4
        -- IMPORTANT: Path is accurate for end device compatibility
        local areas = fs.find("/Knowledge/MineAreas/*")
        local totalAreas = #areas
        
        -- Validate page number
        if pageNum < 0 then pageNum = 0 end
        if pageNum >= totalAreas then pageNum = totalAreas - 1 end
        
        local page = MD.createPage()
        UI.addBackButton(page, Panels.mining)
        
        -- Navigation buttons
        page:add(
            "Up",
            function()
                -- Save current terminal state
                local oldTerm = term.current()
                term.redirect(State.monitor)
                
                Panels.miningAreasList(pageNum - 1)
                
                -- Restore terminal
                term.redirect(oldTerm)
            end,
            2, 2, 3, 3,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        -- Area buttons
        local areasToPrint = math.min(availSpace, totalAreas)
        for i = 1, areasToPrint do
            if i + pageNum <= totalAreas then
                local t1, t2, t3, t4 = MD.getListMath(i + 2)
                page:add(
                    tostring(i + pageNum),
                    function() Panels.miningArea(i + pageNum) end,
                    t1, t2, t3, t4,
                    Config.colors.button.background,
                    Config.colors.button.text
                )
            end
        end
        
        page:add(
            "Down",
            function()
                -- Save current terminal state
                local oldTerm = term.current()
                term.redirect(State.monitor)
                
                Panels.miningAreasList(pageNum + 1)
                
                -- Restore terminal
                term.redirect(oldTerm)
            end,
            4, 4, 5, 5,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        page:add(
            "New Area",
            function()
                -- Save current terminal state
                local oldTerm = term.current()
                term.redirect(State.monitor)
                
                Panels.miningArea(totalAreas + 1)
                
                -- Restore terminal
                term.redirect(oldTerm)
            end,
            6, 6, 7, 7,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        UI.handlePage(page)
    end,

    -- Mining Area Panel
    miningArea = function(id)
        log("Opening Mining Area:", id)
        local area = AF.LoadArea(id)
        local coords = {
            X1 = area and area["X1"] or 0,
            Z1 = area and area["Z1"] or 0,
            X2 = area and area["X2"] or 0,
            Z2 = area and area["Z2"] or 0
        }
        local delta = 1

        local page = MD.createPage()
        UI.addBackButton(page, Panels.miningAreasList)
        
        -- Save button
        page:add(
            "Save",
            function()
                -- Save current terminal state
                local oldTerm = term.current()
                term.redirect(term.native())
                
                log("Saving area:", id)
                local newArea = area or {}
                newArea["X1"], newArea["Z1"] = coords.X1, coords.Z1
                newArea["X2"], newArea["Z2"] = coords.X2, coords.Z2
                AF.SaveArea(id, newArea)
                
                -- Restore terminal
                term.redirect(oldTerm)
            end,
            6, 6, 7, 7,
            Config.colors.button.background,
            Config.colors.button.text
        )

        UI.addCoordinateControls(page, coords, delta)
        UI.handlePage(page)
    end,

    -- Mining Deposit List Panel
    miningDepositList = function(pageNum)
        log("Opening Mining Deposit List, page:", pageNum or 0)
        pageNum = pageNum or 0
        
        local availSpace = math.floor(State.monY / 4) - 4
        -- IMPORTANT: Path is accurate for end device compatibility
        local areas = fs.find("/Knowledge/MineAreas/*")
        local totalAreas = #areas
        
        if pageNum < 0 then pageNum = 0 end
        if pageNum >= totalAreas then pageNum = totalAreas - 1 end
        
        local page = MD.createPage()
        UI.addBackButton(page, Panels.mining)
        
        -- Navigation
        page:add(
            "Up",
            function() Panels.miningDepositList(pageNum - 1) end,
            2, 2, 3, 3,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        -- Area buttons
        local areasToPrint = math.min(availSpace, totalAreas)
        for i = 1, areasToPrint do
            if i + pageNum <= totalAreas then
                local t1, t2, t3, t4 = MD.getListMath(i + 2)
                page:add(
                    tostring(i + pageNum),
                    function() Panels.miningDeposit(i + pageNum) end,
                    t1, t2, t3, t4,
                    Config.colors.button.background,
                    Config.colors.button.text
                )
            end
        end
        
        page:add(
            "Down",
            function() Panels.miningDepositList(pageNum + 1) end,
            4, 4, 5, 5,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        page:add(
            "New Deposit",
            function() Panels.miningDeposit(totalAreas + 1) end,
            6, 6, 7, 7,
            Config.colors.button.background,
            Config.colors.button.text
        )
        
        UI.handlePage(page)
    end,

    -- Mining Deposit Panel
    miningDeposit = function(id)
        log("Opening Mining Deposit:", id)
        local area = AF.LoadArea(id)
        local x, y, z = 0, 0, 0
        local delta = 1
        
        if area and area["Deposits"] then
            x = area["Deposits"]["X"]
            y = area["Deposits"]["Y"]
            z = area["Deposits"]["Z"]
        else
            x, y, z = gps.locate(5)
        end

        local page = MD.createPage()
        UI.addBackButton(page, Panels.miningDepositList)
        
        -- Save button
        page:add(
            "Save",
            function()
                -- Save current terminal state
                local oldTerm = term.current()
                term.redirect(term.native())
                
                log("Saving deposit for area:", id)
                if not area["Deposits"] then area["Deposits"] = {} end
                area["Deposits"]["X"] = x
                area["Deposits"]["Y"] = y
                area["Deposits"]["Z"] = z
                AF.SaveArea(id, area)
                
                -- Restore terminal
                term.redirect(oldTerm)
            end,
            6, 6, 7, 7,
            Config.colors.button.background,
            Config.colors.button.text
        )

        -- Coordinate controls
        local function addControl(label, func, gridX, gridY)
            local t1, t2, t3, t4 = MD.getGridMath(gridX, gridY)
            page:add(
                label,
                func,
                t1, t2, t3, t4,
                Config.colors.button.background,
                Config.colors.button.text
            )
        end

        -- X controls
        addControl("X-", function() 
            x = x - delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 1, 3)
        addControl("X+", function() 
            x = x + delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 3, 3)
        
        -- Z controls
        addControl("Z-", function() 
            z = z - delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 1, 4)
        addControl("Z+", function() 
            z = z + delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 3, 4)
        
        -- Y controls
        addControl("Y-", function() 
            y = y - delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 5, 3)
        addControl("Y+", function() 
            y = y + delta 
            MD.clearMonitor() -- Ensure clean redraw
        end, 7, 3)

        -- Delta controls
        addControl("-1", function() 
            delta = math.max(0, delta - 1) 
            MD.clearMonitor() -- Ensure clean redraw
        end, 1, 5)
        addControl("-10", function() 
            delta = math.max(0, delta - 10) 
            MD.clearMonitor() -- Ensure clean redraw
        end, 2, 5)
        addControl("-100", function() 
            delta = math.max(0, delta - 100) 
            MD.clearMonitor() -- Ensure clean redraw
        end, 3, 5)
        addControl("+100", function() 
            delta = delta + 100 
            MD.clearMonitor() -- Ensure clean redraw
        end, 5, 5)
        addControl("+10", function() 
            delta = delta + 10 
            MD.clearMonitor() -- Ensure clean redraw
        end, 6, 5)
        addControl("+1", function() 
            delta = delta + 1 
            MD.clearMonitor() -- Ensure clean redraw
        end, 7, 5)

        UI.handlePage(page)
    end
}

-- Main initialization and entry point
log("Initializing monitor interface")
    
-- Initialize monitor and terminal state
log("Initializing monitor...")
local success, result = pcall(function()
    local mon, monX, monY, fourPanX, fourPanY = MD.initializeMonitor()
    State.monitor = mon
    State.monX = monX
    State.monY = monY
    State.fourPanX = fourPanX
    State.fourPanY = fourPanY
end)

if not success then
    error("Failed to initialize monitor: " .. tostring(result))
end
log("Monitor initialized successfully")

-- Save current terminal
local oldTerm = MD.redirectToMonitor()

-- Start interface based on monitor type
local ok, err = pcall(function()
    if State.monitor.isColor() then
        log("Starting advanced interface")
        Panels.landing()
    else
        log("Starting basic interface")
        term.native().clear()
        term.native().setCursorPos(1, 1)
        term.native().write("Requires Advanced Monitors for commands")
        term.native().setCursorPos(1, 2)
        term.native().write("Opening Stats")
        Panels.stats()
    end
end)

-- Always restore terminal before exiting
MD.restoreTerminal(oldTerm)

if not ok then
    error(err) -- Re-throw error after terminal restoration
end

end -- Close main() function defined at line 8

-- Error handling wrapper
local function errorHandler(err)
    -- Ensure we're writing to the native terminal
    local nativeTerm = term.native()
    nativeTerm.setBackgroundColor(colors.black)
    nativeTerm.setTextColor(colors.red)
    nativeTerm.clear()
    
    -- Split error message into lines for better readability
    local lines = {}
    for line in tostring(err):gmatch("[^\n]+") do
        table.insert(lines, line)
    end
    
    -- Write header
    nativeTerm.setCursorPos(1, 1)
    nativeTerm.write("Monitor Interface Error:")
    
    -- Write each line of the error
    for i, line in ipairs(lines) do
        nativeTerm.setCursorPos(1, i + 1)
        nativeTerm.write(line)
    end
    
    -- Log the full error
    log("ERROR:", err)
end

-- Start the interface with error handling
xpcall(main, errorHandler, ...)
