util.AddNetworkString("SendWardenCommand")
util.AddNetworkString("UpdateCommands")
util.AddNetworkString("ToggleCommand")
util.AddNetworkString("RequestCommands")
util.AddNetworkString("PlaceWaypoint")
util.AddNetworkString("SetWaypoint")
util.AddNetworkString("UpdateWaypoint")
local activeCommands = {}

function JB:ParseCommand(command)
    -- I wish switch cases exists
    if command == commandType.WAYPOINT then
        self:SetWaypoint(waypointType.POINT)
    elseif command == commandType.LINEUP then
        self:SetWaypoint(waypointType.LINE)
    else
        self:ToggleCommand(command)
    end
end

function JB:ToggleCommand(type)
    if table.HasValue(activeCommands, type) then
        table.RemoveByValue(activeCommands, type)
    else
        table.insert(activeCommands, type)
    end

    self:UpdateCommands()
end

function JB:SetWaypoint(type)
    self.warden:GiveWeapon("weapon_radio")
    self.warden:SetActiveWeapon("weapon_radio")
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

net.Receive("SendWardenCommand", function(ln, ply)
    if not ply:IsWarden() then return end
    JB:ParseCommand(net.ReadInt(32))
end)

net.Receive("RequestCommands", function(ln, ply)
    JB:UpdateCommands(ply)
end)

net.Receive("SetWaypoint", function()
    net.Start("UpdateWaypoint")
    net.WriteTable(net.ReadTable())
    net.Broadcast()
end)