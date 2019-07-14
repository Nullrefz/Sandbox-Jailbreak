actionsMenu = {"friendlyfire", "teamcollision", "guardmute", "opencelldoors"}

if CLIENT then
    function JB:AddActionsMenu()
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

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots, "actions")
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
end

if SERVER then
    util.AddNetworkString("ToggleFriendlyFire")
    util.AddNetworkString("ToggleTeamCollision")
    util.AddNetworkString("ToggleGuardMute")
    util.AddNetworkString("OpenCellDoors")

    net.Receive("ToggleFriendlyFire", function(ln, ply)
        JB:SetFriendlyFire(enabled, Team.PRISONERS)
    end)
    net.Receive("ToggleTeamCollision", function(ln, ply)
        JB:SetNoSelfCollision(enabled, Team.PRISONERS) end)
    net.Receive("ToggleGuardMute", function(ln, ply)
        JB:SetMicEnabled(enabled, Team.GUARDS)
     end)
    net.Receive("OpenCellDoors", function(ln, ply)
        JB:OpenCells(JB.warden)
     end)

     hook.Add("WardenRevoked", "ResetActions", function()
        activeActions = {}
        JB:UpdateActions()
    end)

    net.Receive("RequestCommands", function(ln, ply)
        JB:UpdateActions(ply)
    end)

end