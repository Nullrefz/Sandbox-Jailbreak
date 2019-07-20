actionsMenu = {"friendlyfire", "teamcollision", "guardmute", "opencelldoors"}

if CLIENT then
    function JB:AddActionsMenu()
        activeActions = {}
        local slots = {}

        for k, v in pairs(actionsMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = false

            if v == "friendlyfire" then
                slot.ACTION = function()
                    JB:SendFriendlyFire()
                end
            elseif v == "teamcollision" then
                slot.ACTION = function()
                    JB:SendTeamCollision()
                end
            elseif v == "guardmute" then
                slot.ACTION = function()
                    JB:SendGuardMute()
                end
            elseif v == "opencelldoors" then
                slot.ACTION = function()
                    JB:SendOpenDoors()
                end
            end

            slot.COLOR = Color(255, 255, 255, 150)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots, "actions", actionsMenu)
    end

    function JB:SendFriendlyFire()
        net.Start("ToggleFriendlyFire")
        net.SendToServer()
    end

    function JB:SendTeamCollision()
        net.Start("ToggleTeamCollision")
        net.SendToServer()
    end

    function JB:SendGuardMute()
        net.Start("ToggleGuardMute")
        net.SendToServer()
    end

    function JB:SendOpenDoors()
        net.Start("OpenCellDoors")
        net.SendToServer()
    end

    hook.Add("Initialize", "AddActionsMenu", function()
        JB:AddActionsMenu()
    end)

    net.Receive("SendActions", function()
        activeActions = net.ReadTable()
    end)
end

if SERVER then
    util.AddNetworkString("ToggleFriendlyFire")
    util.AddNetworkString("ToggleTeamCollision")
    util.AddNetworkString("ToggleGuardMute")
    util.AddNetworkString("OpenCellDoors")
    util.AddNetworkString("RequestActions")
    util.AddNetworkString("SendActions")
    JB.activeActions = {}

    net.Receive("ToggleFriendlyFire", function(ln, ply)
        local enabled = false

        if table.HasValue(JB.activeActions, "friendlyfire") then
            table.RemoveByValue(JB.activeActions, "friendlyfire")
        else
            table.insert(JB.activeActions, "friendlyfire")
            enabled = true
        end

        JB:SetFriendlyFire(enabled, Team.PRISONERS)
        JB:UpdateActions()
    end)

    net.Receive("ToggleTeamCollision", function(ln, ply)
        local enabled = true

        if table.HasValue(JB.activeActions, "teamcollision") then
            table.RemoveByValue(JB.activeActions, "teamcollision")
        else
            table.insert(JB.activeActions, "teamcollision")
            enabled = false
        end

        JB:SetNoSelfCollision(enabled, Team.PRISONERS)
        JB:UpdateActions()
    end)

    net.Receive("ToggleGuardMute", function(ln, ply)
        local enabled = false

        if table.HasValue(JB.activeActions, "guardmute") then
            table.RemoveByValue(JB.activeActions, "guardmute")
        else
            table.insert(JB.activeActions, "guardmute")
            enabled = true
        end

        JB:SetMicEnabled(enabled, Team.GUARDS)
        JB:UpdateActions()
    end)

    net.Receive("OpenCellDoors", function(ln, ply)
        if table.HasValue(JB.activeActions, "opencelldoors") then
            table.RemoveByValue(JB.activeActions, "opencelldoors")
        end

        JB:OpenCells(JB.warden)
        JB:UpdateActions()
    end)

    hook.Add("WardenRevoked", "ResetActions", function()
        JB.activeActions = {}
        JB:SetMicEnabled(true, Team.GUARDS)
        JB:SetNoSelfCollision(true, Team.PRISONERS)
        JB:SetFriendlyFire(false, Team.PRISONERS)
        JB:UpdateActions()
    end)

    --JB:UpdateActions()
    net.Receive("RequestActions", function(ln, ply)
        JB:UpdateActions(ply)
    end)

    hook.Add("CellDoorsOpened", "ValidateAction", function()
        if table.HasValue(JB.activeActions, "opencelldoors") then
            table.RemoveByValue(JB.activeActions, "opencelldoors")
        end
    end)

    function JB:UpdateActions(ply)
        net.Start("SendActions")
        net.WriteTable(JB.activeActions)

        if ply then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    function GM:PostCleanupMap()
        if table.HasValue(JB.activeActions, "opencelldoors") then return end
        table.insert(JB.activeActions, "opencelldoors")
    end
end