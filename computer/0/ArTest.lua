
local controller = peripheral.find("arController") -- Finds the peripheral if one is connected

if controller == nil then error("arController not found") end

controller.setRelativeMode(true, 1600, 900) -- Convenient Aspect ratio for most screens

controller.clear() -- If you don't do this, the texts will draw over each other
print("Drew Test")
controller.drawRightboundString("Test", -100, -100, 0xFF0000)
