-- Turtle Self-tracking System created by Latias1290.
-- Tweaked by Kaseyawolf2
local DGPS =  {}

local DGPS_xPos = 0
local DGPS_yPos = 0
local DGPS_zPos = 0   -- Assume your the center of the world ( cause that where the start chest is)
local DGPS_face = 0    -- your facing 0 which is north 
local DGPS_GPSConn = false
local DGPS_UpdateFeq = 50
local DGPS_TimeSinceUpdate = 0
local DGPS_Travelheight = 100



function DGPS.GPSConnect() -- get gps using other computers
    DGPS_xPos, DGPS_yPos, DGPS_zPos = gps.locate()
    DGPS_GPSConn = true
end

function DGPS.Update()
    if DGPS_GPSConn then 
        DGPS_TimeSinceUpdate = DGPS_TimeSinceUpdate + 1
        if DGPS_TimeSinceUpdate > DGPS_UpdateFeq then
            DGPS.GPSConnect()
        end
    end
end

function DGPS.setUpdateFrequency(NumofMoves)
    DGPS_UpdateFeq = NumofMoves
end

function DGPS.manSetLocation(x, y, z) -- manually set location
    DGPS_xPos = x
    DGPS_yPos = y
    DGPS_zPos = z
end

function DGPS.getLocation() -- return the location
    if DGPS_xPos ~= nil then
        return DGPS_xPos, DGPS_yPos, DGPS_zPos
    else
        return nil
    end
end

function DGPS.turnLeft() -- turn left
    if turtle.turnLeft() then
        if DGPS_face == 0 then
            DGPS_face = 1
        elseif DGPS_face == 1 then
            DGPS_face = 2
        elseif DGPS_face == 2 then
            DGPS_face = 3
        elseif DGPS_face == 3 then
            DGPS_face = 0
        end
    else
        return false
    end
end

function DGPS.turnRight() -- turn right
    if turtle.turnRight() then
        if DGPS_face == 0 then
            DGPS_face = 3
        elseif DGPS_face == 1 then
            DGPS_face = 0
        elseif DGPS_face == 2 then
            DGPS_face = 1
        elseif DGPS_face == 3 then
            DGPS_face = 2
        end 
    else
        return false
    end
end

function DGPS.forward() -- go DGPS.forward
    if turtle.forward() then
        if DGPS_face == 0 then
            DGPS_zPos = DGPS_zPos - 1
        elseif DGPS_face == 1 then
            DGPS_xPos = DGPS_xPos - 1
        elseif DGPS_face == 2 then
            DGPS_zPos = DGPS_zPos + 1
        elseif DGPS_face == 3 then
            DGPS_xPos = DGPS_xPos + 1
        end
        DGPS.Update()
    else
        return false
    end
end

function DGPS.back() -- go DGPS.back
    if turtle.back() then
        if DGPS_face == 0 then
            DGPS_zPos = DGPS_zPos + 1
        elseif DGPS_face == 1 then
            DGPS_xPos = DGPS_xPos + 1
        elseif DGPS_face == 2 then
            DGPS_zPos = DGPS_zPos - 1
        elseif DGPS_face == 2 then
            DGPS_xPos = DGPS_xPos - 1
        end
        DGPS.Update()
    else
        return false
    end
end

function DGPS.up() -- go up
    if turtle.up() then
        DGPS_yPos = DGPS_yPos + 1
        DGPS.Update()
    else
        return false
    end
end

function DGPS.down() -- go down
    if turtle.down() then
        DGPS_yPos = DGPS_yPos - 1
        DGPS.Update()
    else
        return false
    end
end

function DGPS.FindFaceDir()
    firstpos = gps.locate()
    if DGPS.forward() then
        secondpos = gps.locate()
    elseif DGPS.back() then
        secondpos = gps.locate()
    elseif DGPS.turnLeft() then
        return DGPS.FindFaceDir()
    else
        print("Cant move or turn")
        return nil
    end
    Dpos = firstpos - secondpos

    return 

end

function DGPS.Goto(x,y,z,Travelheight)
        -- if not connected to GPS then wiil be relative to the turtle
        -- get the Delta Change
        if DGPS_GPSConn then
            Dx = x - DGPS_xPos 
            Dy = y - DGPS_yPos 
            Dz = z - DGPS_zPos 
        else
            Dx = x 
            Dy = y 
            Dz = z
        end
        print("Movement Delta :"..Dx..":"..Dy..":"..Dz )
        -- move to travel height (default 100)
        if Travelheight == nil then -- if travel height was given travel there
            Travelheight = DGPS_Travelheight
        end
        print("traveling at y:".. Travelheight)
        if DGPS_yPos < Travelheight then -- is the turtle below the travel height
            Dth = Travelheight - DGPS_yPos  -- subtract the current height 
            for i = 0, Dth do -- go up the difference
                DGPS.up() 
            end
        end


end

return DGPS