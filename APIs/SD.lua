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
    tempx2 = 0
    tempz2 = 0
    Deltatemp = 1


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
                    Page:add("X1-", function() tempx = tempx - Deltatemp
                        MiningAreaPanel(ID) end , 4, 6, 8, 8, colors.red, colors.lime)
                    Page:add("X1+", function() tempx = tempx + Deltatemp
                        MiningAreaPanel(ID) end, 16, 6, 20, 8, colors.red, colors.lime)
                    --ZMin
                    Page:add("Z1-", function() tempz = tempz - Deltatemp
                        MiningAreaPanel(ID) end, 4, 10, 8, 12, colors.red, colors.lime)
                    Page:add("Z1+", function() tempz = tempz + Deltatemp
                        MiningAreaPanel(ID) end, 16, 10, 20, 12, colors.red, colors.lime)
                    --XMax
                    Page:add("X2-", function() tempx2 = tempx2 - Deltatemp
                        MiningAreaPanel(ID) end , 22, 6, 26, 8, colors.red, colors.lime)
                    Page:add("X2+", function() tempx2 = tempx2 + Deltatemp
                        MiningAreaPanel(ID) end, 34, 6, 38, 8, colors.red, colors.lime)
                    --ZMax
                    Page:add("Z2-", function() tempz2 = tempz2 - Deltatemp 
                        MiningAreaPanel(ID) end, 22, 10, 26, 12, colors.red, colors.lime)
                    Page:add("Z2+", function() tempz2 = tempz2 + Deltatemp 
                        MiningAreaPanel(ID) end, 34, 10, 38, 12, colors.red, colors.lime)

                    --ΔChange
                    Page:add("-1", function() Deltatemp = Deltatemp - 1
                        MiningAreaPanel(ID) end , 4, 14, 8, 16, colors.red, colors.lime)
                    Page:add("-10", function() Deltatemp = Deltatemp - 10
                        MiningAreaPanel(ID) end, 10, 14, 14, 16, colors.red, colors.lime)
                    Page:add("-100", function() Deltatemp = Deltatemp - 100
                        MiningAreaPanel(ID) end, 16, 14, 20, 16, colors.red, colors.lime)

                    Page:add("+100", function() Deltatemp = Deltatemp + 100
                        MiningAreaPanel(ID) end, 22, 14, 26, 16, colors.red, colors.lime)
                    Page:add("+10", function() Deltatemp = Deltatemp + 10
                        MiningAreaPanel(ID) end, 28, 14, 32, 16, colors.red, colors.lime)
                    Page:add("+1", function() Deltatemp = Deltatemp + 1
                        MiningAreaPanel(ID) end, 34, 14, 38, 16, colors.red, colors.lime)







                    Page:draw() --Draw seems to Clear term before drawing

                    term.setBackgroundColor(colors.black)
                    term.setTextColor(colors.white)
                    --Coord 1
                    term.setCursorPos(9, 4)
                    term.write("Coord 1")
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