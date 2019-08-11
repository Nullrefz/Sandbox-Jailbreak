commandType = {"walk", "mic", "crouch", "afk", "jumping", "sprinting", "freelook"}

if CLIENT then

    function GM:OnContextMenuOpen()
        JB:OpenMenu("commands")
    end

    function GM:OnContextMenuClose()
        JB:CloseMenu()
    end

    function JB:SendCommand(command)
        net.Start("SendWardenCommand")
        net.WriteInt(table.KeyFromValue(commandType, command), 32)
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

            slot.COLOR = Color(255, 255, 255, 100)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots, "commands", commandType)
    end

    hook.Add("JB_Initialize", "AddCommandMenu", function()
        JB:AddCommandMenu()
    end)
end

if SERVER then
    util.AddNetworkString("SendWardenCommand")
    util.AddNetworkString("UpdateCommands")
    util.AddNetworkString("ToggleCommand")
    util.AddNetworkString("RequestCommands")

    local activeCommands = {}

    function JB:ToggleCommand(type)
        if table.HasValue(activeCommands, type) then
            table.RemoveByValue(activeCommands, type)
        else
            table.insert(activeCommands, type)
        end

        self:UpdateCommands()
    end

    function JB:UpdateCommands(ply)
        net.Start("UpdateCommands")
        net.WriteTable(activeCommands)

        if ply then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    hook.Add("WardenRevoked", "ResetCommands", function()
        activeCommands = {}
        JB:UpdateCommands()
    end)

    net.Receive("SendWardenCommand", function(ln, ply)
        if not ply:IsWarden() then return end
        JB:ToggleCommand(net.ReadInt(32))
    end)

    net.Receive("RequestCommands", function(ln, ply)
        JB:UpdateCommands(ply)
    end)


end