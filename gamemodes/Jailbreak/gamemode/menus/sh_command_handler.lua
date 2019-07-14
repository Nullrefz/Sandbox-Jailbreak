commandType = {"walk", "mic", "crouch", "afk", "jumping", "sprinting", "freelook"}
----------------------
if CLIENT then
    -- implement if player is warden
    local commandMenu

    function GM:OnContextMenuOpen()
        if not commandMenu then
            commandMenu = JB:AddCommandMenu()
        end

        commandMenu:Show()
    end

    function GM:OnContextMenuClose()
        commandMenu:Hide()
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

    function JB:AddCommandMenu()
        local slots = {}

        for k, v in pairs(commandType) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = false

            slot.ACTION = function()
                JB:SendCommand(v)
            end

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots)
    end
end