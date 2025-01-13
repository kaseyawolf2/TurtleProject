local MD = {}

--# IMPORTANT: All require paths must use /LocalGit/ prefix for end device compatibility
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
        error("No monitor.\nRun initializeMonitor()")
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

function MD.SimplePrint(Text, mon)
    if not mon then
        error("No monitor.\nRun initializeMonitor()")
    end
    mon.scroll(-1)
    mon.setCursorPos(1,1)
    mon.write(Text)
end

-- Utility functions for panel creation and management
function MD.initializeMonitor()
    -- Set the module-level monitor variable
    local monitor = peripheral.find("monitor")
    if not monitor then
        error("No monitor found")
    end
    
    -- Clear the monitor and set initial state
    monitor.clear()
    monitor.setTextScale(0.5)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    MD.SimplePrint("MD: Monitor Initialized", monitor)
    
    -- Save monitor dimensions
    local MonX, MonY = monitor.getSize()
    local FourPanX = math.floor((MonX/2)-1)
    local FourPanY = math.floor((MonY/2)-1)

    local monAddress = peripheral.getName(monitor)

    return monitor, MonX, MonY, FourPanX, FourPanY, monAddress
end

function MD.clearMonitor(monitor)
    if not monitor then
        error("No monitor.\nRun initializeMonitor()")
    end
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setCursorPos(1,1)
end

function MD.getGridMath(X, Y)
    return GridMath(X, Y)
end

function MD.getListMath(Y)
    return ListMath(Y)
end

function MD.handlePageEvents(page)
    if not monitor then
        error("No monitor.\nRun initializeMonitor()")
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
