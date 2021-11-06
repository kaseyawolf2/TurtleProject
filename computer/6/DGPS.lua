-- Turtle Self-tracking System created by Latias1290.
-- Made to Dead Reconing by Kaseyawolf2
local DGPS =  {}

local xPos, yPos, zPos = 0   -- Assume your the center of the world ( cause that where the start chest is)
face = 0    -- your facing 0 which is north 
GPSConn = false
UpdateFeq = 50
TimeSinceUpdate = 0

function GPSConnect() -- get gps using other computers
    xPos, yPos, zPos = gps.locate()
    GPSConn = true
end

function Update()
    if GPSConn then 
        TimeSinceUpdate = TimeSinceUpdate + 1
        if TimeSinceUpdate > UpdateFeq then
            GPSConnect()
        end
    end
end

function setUpdateFrequency(NumofMoves)
    UpdateFeq = NumofMoves
end

function manSetLocation(x, y, z) -- manually set location
    xPos = x
    yPos = y
    zPos = z
end

function getLocation() -- return the location
    if xPos ~= nil then
        return xPos, yPos, zPos
    else
        return nil
    end
end

function turnLeft() -- turn left
    if face == 0 then
        face = 1
    elseif face == 1 then
        face = 2
    elseif face == 2 then
        face = 3
    elseif face == 3 then
        face = 0
    end
end

function turnRight() -- turn right
    if face == 0 then
        face = 3
    elseif face == 1 then
        face = 0
    elseif face == 2 then
        face = 1
    elseif face == 3 then
        face = 2
    end
end

function forward() -- go forward
    turtle.forward()
    if face == 0 then
        zPos = zPos - 1
    elseif face == 1 then
        xPos = xPos - 1
    elseif face == 2 then
        zPos = zPos + 1
    elseif face == 3 then
        xPos = xPos + 1
    end
    Update()
end

function back() -- go back
    turtle.back()
    if face == 0 then
        zPos = zPos + 1
    elseif face == 1 then
        xPos = xPos + 1
    elseif face == 2 then
        zPos = zPos - 1
    elseif face == 2 then
        xPos = xPos - 1
    end
    Update()
end

function up() -- go up
    turtle.up()
    yPos = yPos + 1
    Update()
end

function down() -- go down
    turtle.down()
    yPos = yPos - 1
    Update()
end



return DGPS