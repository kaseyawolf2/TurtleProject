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

function DGPS.Start() -- get gps using other computers
    if gps.locate(5) == nil then
        -- Ask for current Cords
        -- Ask for Current Heading
        print("No GPS")
    else
        print("Connecting to GPS")
        GPSConnect()
        Update()
        print("Finding Direction Faced")
        FindFaceDir()
    end


end

function GPSConnect() -- get gps using other computers
    DGPS_xPos, DGPS_yPos, DGPS_zPos = gps.locate()
    DGPS_GPSConn = true
end

function Update()
    if DGPS_GPSConn then 
        DGPS_TimeSinceUpdate = DGPS_TimeSinceUpdate + 1
        if DGPS_TimeSinceUpdate > DGPS_UpdateFeq then
            GPSConnect()
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

function PrintLocation() -- return the location
    print("X:" .. DGPS_xPos .. " | Z:" .. DGPS_zPos .. " | Y:" .. DGPS_yPos)
end


function DGPS.turnLeft() -- turn left
    if turtle.turnLeft() then
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

function DGPS.turnRight() -- turn right
    if turtle.turnRight() then
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

function DGPS.forward() -- go DGPS.forward
    if turtle.forward() then
        if DGPS_face == 0 then --north
            DGPS_xPos = DGPS_xPos - 1
        elseif DGPS_face == 1 then
            DGPS_zPos = DGPS_zPos - 1
        elseif DGPS_face == 2 then
            DGPS_xPos = DGPS_xPos + 1
        elseif DGPS_face == 3 then
            DGPS_zPos = DGPS_zPos + 1
        end
        Update()
    else
        return false
    end
end

function DGPS.back() -- go DGPS.back
    if turtle.back() then
        if DGPS_face == 0 then --north
            DGPS_xPos = DGPS_xPos + 1
        elseif DGPS_face == 1 then
            DGPS_zPos = DGPS_zPos + 1
        elseif DGPS_face == 2 then
            DGPS_xPos = DGPS_xPos - 1
        elseif DGPS_face == 3 then
            DGPS_zPos = DGPS_zPos - 1
        end
        Update()
    else
        return false
    end
end

function DGPS.up() -- go up
    if turtle.up() then
        DGPS_yPos = DGPS_yPos + 1
        Update()
    else
        return false
    end
end

function DGPS.down() -- go down
    if turtle.down() then
        DGPS_yPos = DGPS_yPos - 1
        Update()
    else
        return false
    end
end

function PrintDir()
    if DGPS_face == 0 then
        print("North")
    elseif DGPS_face == 1 then
        print("East")
    elseif DGPS_face == 2 then
        print("South")
    elseif DGPS_face == 3 then
        print("West")
    else 
        print("Unknown dir : " .. DGPS_face)
    end
end

function FaceDir(Dir)
    if Dir == "North" then
        while DGPS_face ~= 0 do 
            DGPS.turnLeft()
        end
    elseif Dir == "East" then
        while DGPS_face ~= 1 do 
            DGPS.turnLeft()
        end
    elseif Dir == "South" then
        while DGPS_face ~= 2 do 
            DGPS.turnLeft()
        end
    elseif Dir == "West" then
        while DGPS_face ~= 3 do 
            DGPS.turnLeft()
        end
    end
end

function FindFaceDir()
    x1,y1,z1 = gps.locate()
    if turtle.forward() then
        x2,y2,z2 = gps.locate()
        turtle.back()
    elseif turtle.turnLeft() then
        return FindFaceDir()
    else
        print("Cant move or turn")
        return nil
    end
    Dx = x1 - x2
    Dz = z1 - z2
    print(Dx .. " : " .. Dz)
    if Dx ~= 0 then
        if Dx == 1 then
            DGPS_face = 3
        elseif Dx == -1 then
            DGPS_face = 1
        else
            print("More then 1 block movement")
        end
    elseif Dz ~= 0 then
        if Dz == 1 then
            DGPS_face = 0
        elseif Dz == -1 then
            DGPS_face = 2
        else
            print("More then 1 block movement")
        end
    else
        print("No gps Change???")
    end
    PrintDir()
    return 
end

function DGPS.Goto(x,y,z,Travelheight)
        -- if not connected to GPS then wiil be relative to the turtle
        -- get the Delta Change
        if DGPS_GPSConn then
            Dx = x - DGPS_xPos 
            Dy = y - DGPS_yPos 
            Dz = z - DGPS_zPos 
            print("Movement Delta X:"..Dx.." | Y:"..Dy.." | Z:"..Dz )
        else
            Dx = x 
            Dy = y 
            Dz = z
            print("Moving X:"..Dx.." | Y:"..Dy.." | Z:"..Dz )
        end
        -- Set Default travel height (default 100)
        if Travelheight == nil then -- if travel height was given travel there
            Travelheight = DGPS_Travelheight
        end
        print("traveling at y:".. Travelheight)

        -- Get to Travel height
        if DGPS_yPos < Travelheight then -- is the turtle below the travel height
            Dth = Travelheight - DGPS_yPos  -- subtract the current height 
            for i = 1, Dth do -- go up the difference
                DGPS.up()
                Dy = Dy - 1
            end
        elseif DGPS_yPos > Travelheight then
            Dth = DGPS_yPos - Travelheight
            for i = 1, Dth do -- go down the difference
                DGPS.down() 
                Dy = Dy + 1
            end 
        end



        --Move X
        if Dx > 0 then
            FaceDir("East")
            for i = 1, Dz do -- go down the difference
                DGPS.forward() 
            end 
        elseif Dx < 0 then
            FaceDir("West")
            Dx = Dx * -1
            for i = 1, Dx do -- go down the difference
                DGPS.forward()
            end 
        end

        --Move Z
        if Dz > 0 then
            FaceDir("South")
            for i = 1, Dz do -- go down the difference
                DGPS.forward() 
            end 
        elseif Dz < 0 then
            FaceDir("North")
            Dz = Dz * -1
            for i = 1, Dx do -- go down the difference
                DGPS.forward()
            end 
        end

        

        --Move Y
        if Dy > 0 then
            for i = 1, Dy do -- go down the difference
                DGPS.up() 
            end 
        elseif Dy < 0 then
            Dy = Dy * -1
            for i = 1, Dy do -- go down the difference
                DGPS.down() 
            end 
        end

end

return DGPS