local MD = {}

--# IMPORTANT: All paths must use /LocalGit/ prefix for end device compatibility
--# DO NOT change these paths - they are required for the program to work on the end device
local touchpoint = require("/LocalGit/ExternalPrograms/Touchpoint")
local AF = require("/LocalGit/APIs/AF")
local newPage = touchpoint.newPage

-- Local Variables
local monitor

-- Local Functions
local function GridMath(X,Y)
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

local function ListMath(Y)
    if not monitor then
        error("Monitor not initialized.\nCall initializeMonitor() first to set up the monitor.\nMake sure a monitor is connected and try again.")
    end
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

-- Utility functions for panel creation and management
function MD.initializeMonitor()
    -- Set the module-level monitor variable
    monitor = peripheral.find("monitor")
    if not monitor then
        error("No monitor found")
    end
    
    -- Clear the monitor and set initial state
    monitor.setTextScale(0.5)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.clear()
    
    -- Save monitor dimensions
    local MonX, MonY = monitor.getSize()
    local FourPanX = math.floor((MonX/2)-1)
    local FourPanY = math.floor((MonY/2)-1)

    return monitor, MonX, MonY, FourPanX, FourPanY
end

function MD.clearMonitor()
    if not monitor then
        error("Monitor not initialized.\nCall initializeMonitor() first to set up the monitor.")
    end
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setCursorPos(1,1)
end

function MD.redirectToMonitor()
    if not monitor then
        error("Monitor not initialized.\nCall initializeMonitor() first to set up the monitor.\nMake sure a monitor is connected and try again.")
    end
    return term.redirect(monitor)
end

function MD.restoreTerminal(old)
    if old then
        term.redirect(old)
    end
end

function MD.getMonitor()
    if not monitor then
        error("Monitor not initialized.\nCall initializeMonitor() first to set up the monitor.\nMake sure a monitor is connected and try again.")
    end
    return monitor
end

function MD.createPage()
    if not monitor then
        error("Monitor not initialized.\nCall initializeMonitor() first to set up the monitor.\nMake sure a monitor is connected and try again.")
    end
    local monitorName = peripheral.getName(monitor)
    if not monitorName then
        error("Failed to get monitor name")
    end
    
    -- Clear monitor and ensure we're drawing to it
    local oldTerm = term.current()
    term.redirect(monitor)
    MD.clearMonitor()
    
    -- Create page with monitor properly set
    local page = newPage(monitorName)
    
    -- Restore terminal
    term.redirect(oldTerm)
    
    return page
end

function MD.getGridMath(X, Y)
    return GridMath(X, Y)
end

function MD.getListMath(Y)
    return ListMath(Y)
end

function MD.handlePageEvents(page)
    if not monitor then
        error("Monitor not initialized.\nCall initializeMonitor() first to set up the monitor.\nMake sure a monitor is connected and try again.")
    end
    
    -- Save current terminal state
    local oldTerm = term.current()
    term.redirect(monitor)
    
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        if side ~= peripheral.getName(monitor) then
            -- Ignore touches from other monitors
            goto continue
        end
        local buttonEvent, buttonName = page:handleEvents(event, side, x, y)
        if buttonEvent then
            -- Restore terminal for logging
            term.redirect(oldTerm)
            term.native().write(string.format("Button Event: %s, Button Name: %s, X: %d, Y: %d\n", buttonEvent, buttonName, x, y))
            -- Switch back to monitor for further drawing
            term.redirect(monitor)
            return buttonEvent, buttonName
        end
        ::continue::
    end
end

return MD
