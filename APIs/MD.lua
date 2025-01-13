local MD = {}

--# IMPORTANT: All require paths must use /LocalGit/ prefix for end device compatibility
--# DO NOT change these paths - they are required for the program to work on the end device
local touchpoint = require("/LocalGit/ExternalPrograms/Touchpoint")
local AF = require("/LocalGit/APIs/AF")

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

return MD
