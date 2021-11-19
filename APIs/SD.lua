local SD = {}
local monitor = peripheral.find("monitor")
monitor.setTextScale(0.5)
term.redirect(monitor)

if monitor.isColor() then -- Is advanced
    --# load the touchpoint API
    touchpoint = require("/LocalGit/ExternalPrograms/Touchpoint")
    
    MonX, MonY = monitor.getSize()

    FourPanX = math.floor((MonX/2)-1)
    FourPanY = math.floor((MonY/2)-1)
    MultiPanX = math.floor((MonX)-1)
    MultiPanY = 2
    tempx = 0
    tempz = 0


    function SD.Draw()
        function Nothing( )
            --Do Nothing since Nil causes errors
        end
        function LandingPanel()
            --# intialize button set on the monitor
            local Page = new(peripheral.getName(monitor))
            --# add buttons
            Page:add("Update Panel", UpdatePanel, 2, 2, FourPanX, FourPanY, colors.red, colors.lime)
            Page:add("Drone Controls", DronePanel, FourPanX+2, 2, MonX-1, FourPanY, colors.red, colors.lime)
            Page:add("Mining Controls", MiningPanel, 2, FourPanY+2, FourPanX, MonY-1, colors.red, colors.lime)
            Page:add("Statistics", StatsPanel, FourPanX+2, FourPanY+2, MonX-1, MonY-1, colors.red, colors.lime)
            --# draw the buttons
            Page:draw()
            Page:run()
        end
        function UpdatePanel( ... )
            --# intialize button set on the monitor
            local Page = new(peripheral.getName(monitor))
            --# add buttons
            Page:add("Back", LandingPanel, 2, 2, FourPanX, FourPanY, colors.red, colors.lime)
            Page:add("Sync Turtles", nil, FourPanX+2, 2, MonX-1, FourPanY, colors.red, colors.lime)
            Page:add("Sync Mainframes", nil, 2, FourPanY+2, FourPanX, MonY-1, colors.red, colors.lime)
            Page:add("Sync All", nil, FourPanX+2, FourPanY+2, MonX-1, MonY-1, colors.red, colors.lime)
            --# draw the buttons
            Page:draw()
            Page:run()
        end
        function DronePanel( ... )
            --# intialize button set on the monitor
            local Page = new(peripheral.getName(monitor))
            --# add buttons
            Page:add("Back", LandingPanel, 2, 2, FourPanX, FourPanY, colors.red, colors.lime)
            Page:add("", nil, FourPanX+2, 2, MonX-1, FourPanY, colors.red, colors.lime)
            Page:add("", nil, 2, FourPanY+2, FourPanX, MonY-1, colors.red, colors.lime)
            Page:add("", nil, FourPanX+2, FourPanY+2, MonX-1, MonY-1, colors.red, colors.lime)
            --# draw the buttons
            Page:draw()
            Page:run()
        end
        function StatsPanel( ... )
            --# intialize button set on the monitor
            local Page = new(peripheral.getName(monitor))
            --# add buttons
            Page:add("Back", LandingPanel, 2, 2, FourPanX, FourPanY, colors.red, colors.lime)
            Page:add("", nil, FourPanX+2, 2, MonX-1, FourPanY, colors.red, colors.lime)
            Page:add("", nil, 2, FourPanY+2, FourPanX, MonY-1, colors.red, colors.lime)
            Page:add("", nil, FourPanX+2, FourPanY+2, MonX-1, MonY-1, colors.red, colors.lime)
            --# draw the buttons
            Page:draw()
            Page:run()
        end
        function MiningPanel()
            function MiningAreasList(PageNum)
                function MiningAreaPanel(ID)
                    
                    
                    
                    --# intialize button set on the monitor
                    local Page = new(peripheral.getName(monitor))
                    Page:add("Reset Screen", nil, 22, 20, 28, 24, colors.red, colors.lime)
                    --# add buttons
                    Page:add("Back", MiningAreasList, 2, 2, MultiPanX, MultiPanY, colors.red, colors.lime)
                    --XMin
                    Page:add("X-", function() tempx = tempx - 1
                        MiningAreaPanel(ID) end , 4, 6, 7, 8, colors.red, colors.lime)
                    Page:add("X+", function() tempx = tempx + 1
                        MiningAreaPanel(ID) end, 16, 6, 18, 8, colors.red, colors.lime)
                    --ZMin
                    Page:add("Z-", function() tempz = tempz - 1 
                        MiningAreaPanel(ID) end, 4, 10, 8, 12, colors.red, colors.lime)
                    Page:add("Z+", function() tempz = tempz + 1 
                        MiningAreaPanel(ID) end, 16, 10, 18, 12, colors.red, colors.lime)

                    Page:draw() --Draw seems to Clear term before drawing

                    term.setBackgroundColor(colors.black)
                    term.setTextColor(colors.white)
                    --Current XMin 
                    term.setCursorPos(10, 7)
                    term.write(tempx)
                    --Current ZMin 
                    term.setCursorPos(10, 11)
                    term.write(tempz)
                    local Break = false
                    while true do 
                        local event, p1 = Page:handleEvents(os.pullEvent())   ---button_click, name
                        if event == "button_click" then
                            --remove toggling and simplify button running
                            Break = true
                            Page.buttonList[p1].func()
                        end
                    end
                    
                end
                if PageNum == nil then PageNum = 0 end 
                if PageNum < 0 then PageNum = 0 end 
                
                --# intialize button set on the monitor
                local Page = new(peripheral.getName(monitor))
                --# add buttons
                Page:add("Back", MiningPanel, 2, 2, MultiPanX, MultiPanY, colors.red, colors.lime)
                Page:add("Up", function() MiningAreasList(PageNum-1) end, 2, (MultiPanY)+2, MultiPanX, 2*MultiPanY, colors.red, colors.lime)
                AvilSpace = (MonY / MultiPanY) - 4
                for i=1,AvilSpace do
                    Page:add(tostring(i+PageNum), function() MiningAreaPanel(i+PageNum) end, 2, ((i+1)*MultiPanY)+2, MultiPanX, (i+2)*MultiPanY, colors.red, colors.lime)
                end
                Page:add("Down", function() MiningAreasList(PageNum+1) end, 2, MonY-1, MultiPanX, MonY-1, colors.red, colors.lime)
                --# draw the buttons
                Page:draw()
                --sleep(1)
                Page:run()
                
            end
            function MiningStylesPanel()
                --# intialize button set on the monitor
                local Page = new(peripheral.getName(monitor))
                --# add buttons
                Page:add("Back", MiningPanel, 2, 2, math.floor((MonX)-1), math.floor((MonY/4)-1), colors.red, colors.lime)
                --Page:add("2", nil, math.floor((MonX/2)+1), 2, MonX-1, math.floor((MonY/2)-1), colors.red, colors.lime)
                Page:add("3", nil, 2, math.floor((MonY/2)+1), math.floor((MonX/2)-1), MonY-1, colors.red, colors.lime)
                Page:add("4", nil, math.floor((MonX/2)+1), math.floor((MonY/2)+1), MonX-1, MonY-1, colors.red, colors.lime)
                --# draw the buttons
                Page:draw()
                Page:run()
            end
            --# intialize a new button set on the monitor
            local Page = new(peripheral.getName(monitor))
            --# add two buttons
            Page:add("Back", LandingPanel, 2, 2, FourPanX, FourPanY, colors.red, colors.lime)
            Page:add("Mining Styles", MiningStylesPanel, FourPanX+2, 2, MonX-1, FourPanY, colors.red, colors.lime)
            Page:add("Mining Areas", MiningAreasList, 2, FourPanY+2, FourPanX, MonY-1, colors.red, colors.lime)
            --Page:add("", nil, FourPanX+2, FourPanY+2, MonX-1, MonY-1, colors.red, colors.lime)
            --# draw the buttons
            Page:draw()
            Page:run()
        end
        LandingPanel()
    end
    
    


    SD.Draw()












    -- while true do
    --     --# handleEvents will convert monitor_touch events to button_click if it was on a button
    --     local event, p1 = t:handleEvents(os.pullEvent())
    --     if event == "button_click" then
    --         --# p1 will be "left" or "right", since those are the button labels
    --         --# toggle the button that was clicked.
    --         t:flash(p1)
    --     end
    -- end





    
else -- Standard
    term.setCursorPos(1, 1)
    term.write("Requires Advanced Moniators")



end
return SD