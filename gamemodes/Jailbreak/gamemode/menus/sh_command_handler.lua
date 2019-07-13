if CLIENT then
    JB.commandMenu = {}

    function JB.commandMenu:Show()
        self.menu = vgui.Create("JailbreakOptionMenu")
        self.menu:SetSize(w, h)
        self.menu:SetPos(0, 0)

        for k, v in ipairs(commandType) do
            if v == "waypoint" then
                self.menu:AddSlot(v, function()
                    JB:SendWaypoint(0)
                end, Color(255, 200, 0, 255), true)
            elseif v == "calendar" then
                self.menu:AddSlot(v, function()
                    JB:OpenDayMenu()
                end, Color(255, 200, 0), true)
            else
                self.menu:AddSlot(v, function()
                    JB:SendCommand(v)
                end, Color(200, 200, 200))
            end
        end

        JB.commandMenu.Hide = function()
            if self.menu:IsValid() then
                self.menu:Exit()
            end
        end
    end

    -- implement if player is warden
    function GM:OnContextMenuOpen()
        JB.commandMenu:Show()
    end

    function GM:OnContextMenuClose()
        JB.commandMenu:Hide()
    end

    function JB:SendCommand(command)
        net.Start("SendWardenCommand")
        net.WriteInt(table.KeyFromValue(commandType, command), 32)
        net.SendToServer()
    end

    function JB:SendWaypoint(waypoint)
        net.Start("SendWardenWaypoint")
        --net.WriteInt(table.KeyFromValue(commandType, command), 32)
        net.SendToServer()
    end

    function JB:SendChosenDay(chosenDay)
        net.Start("SendChosenDay")
        net.WriteInt(table.KeyFromValue(calendar, chosenDay), 32)
        net.SendToServer()
    end
end