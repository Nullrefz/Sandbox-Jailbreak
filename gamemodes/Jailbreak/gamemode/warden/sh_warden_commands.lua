commandType = {"walk", "mic", "crouch", "afk", "jumping", "sprinting", "waypoint", "freelook"}

waypointType = {
    POINT = 0,
    LINE = 1
}

if SERVER then
    util.AddNetworkString("SendWardenCommand")
    util.AddNetworkString("UpdateCommands")
    util.AddNetworkString("ToggleCommand")
    util.AddNetworkString("RequestCommands")
    util.AddNetworkString("PlaceWaypoint")
    util.AddNetworkString("SetWaypoint")
    util.AddNetworkString("UpdateWaypoint")
    util.AddNetworkString("SendWardenWaypoint")
    local activeCommands = {}

    function JB:ToggleCommand(type)
        print(type)
        if table.HasValue(activeCommands, type) then
            table.RemoveByValue(activeCommands, type)
        else
            table.insert(activeCommands, type)
        end

        self:UpdateCommands()
    end

    function JB:SetWaypoint(type)
        self.warden:GiveWeapon("weapon_radio")
        self.warden:SelectWeapon("weapon_jb_radio")
        net.Start("PlaceWaypoint")
        net.Broadcast()
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

    net.Receive("SendWardenWaypoint", function(ln, ply)
        if not ply:IsWarden() then return end
        JB:SetWaypoint(net.ReadInt(32))
    end)

    net.Receive("RequestCommands", function(ln, ply)
        JB:UpdateCommands(ply)
    end)

    net.Receive("SetWaypoint", function()
        net.Start("UpdateWaypoint")
        net.WriteTable(net.ReadTable())
        net.Broadcast()
    end)
end