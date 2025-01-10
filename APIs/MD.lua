local MD = {}

--# load the touchpoint API
touchpoint = require("/LocalGit/ExternalPrograms/Touchpoint")
AF = require("/LocalGit/APIs/AF")

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
    monitor = peripheral.find("monitor")
    monitor.setTextScale(0.5)
    term.redirect(monitor)
    
    MonX, MonY = monitor.getSize()
    FourPanX = math.floor((MonX/2)-1)
    FourPanY = math.floor((MonY/2)-1)

    return monitor, MonX, MonY, FourPanX, FourPanY
end

function MD.createPage()
    return newPage(peripheral.getName(monitor))
end

function MD.getGridMath(X, Y)
    return GridMath(X, Y)
end

function MD.getListMath(Y)
    return ListMath(Y)
end

function MD.handlePageEvents(page)
    local event, side, x, y = os.pullEvent("monitor_touch")
    local buttonEvent, buttonName = page:handleEvents(event, side, x, y)
    return buttonEvent, buttonName
end

return MD
