
--Get turtle's current GPS position
local x, y, z = gps.locate(2, false)






--loop from current y level to bedrock
while y > 0 do
    --move down
    turtle.down()
    --decrement y
    y = y - 1
end
