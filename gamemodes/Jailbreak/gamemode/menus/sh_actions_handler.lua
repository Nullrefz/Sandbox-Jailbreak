actionsMenu = {"friendlyfire", "teamcollision", "guardmute", "opencelldoors"}

if CLIENT then
    function JB:AddActionsMenu()
        local slots = {}

        for k, v in pairs(actionsMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

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
        net.Send()
    end

    function JB:SendTeamCollision()
        net.Start("ToggleTeamCollision")
        net.Send()
    end

    function JB:SendGuardMute()
        net.Start("ToggleGuardMute")
        net.Send()
    end

    function JB:SendOpenDoors()
        net.Start("OpenCellDoors")
        net.Send()
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
    net.Receive("ToggleFriendlyFire", function(ln, ply) end)
    net.Receive("ToggleTeamCollision", function(ln, ply) end)
    net.Receive("ToggleGuardMute", function(ln, ply) end)
    net.Receive("OpenCellDoors", function(ln, ply) end)
end