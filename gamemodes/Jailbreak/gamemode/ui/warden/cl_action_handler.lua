JB.ShowMenu = {}


function JB.ShowMenu:Show()
    self.menu = vgui.Create("JailbreakWardenMenu")
    self.menu:SetSize(w, h)
    self.menu:SetPos(0, 0)

    for k, v in ipairs(commandType) do 
        if v == "waypoint" then
            self.menu:AddSlot(function() JB:SendWaypoint(0) end, Color(255,200,0), true)
        else
        self.menu:AddSlot(function() JB:SendCommand(v) end, Color(200,200,200))
        end
    end

    JB.ShowMenu.Hide = function()
        if self.menu:IsValid() then
            self.menu:Exit()
        end
    end
end

-- implement if player is warden
function GM:OnContextMenuOpen()
    JB.ShowMenu:Show()
end

function GM:OnContextMenuClose()
    JB.ShowMenu:Hide()
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
