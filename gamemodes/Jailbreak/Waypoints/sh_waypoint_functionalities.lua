if SERVER then
    util.AddNetworkString("SendWardenWaypoint")
    util.AddNetworkString("UpdateWaypoint")
    util.AddNetworkString("PlaceWaypoint")
    util.AddNetworkString("SetWaypoint")

    net.Receive("SendWardenWaypoint", function(ln, ply)
        if not ply:IsWarden() then return end
        JB:SetWaypoint(net.ReadInt(32))
    end)

    function JB:SetWaypoint(type)
        self.warden:GiveWeapon("weapon_radio")
        self.warden:SelectWeapon("weapon_jb_radio")
        self:ToggleWardenWeaponSwitch(false)
        net.Start("PlaceWaypoint")
        net.Broadcast()
    end

    net.Receive("SetWaypoint", function()
        net.Start("UpdateWaypoint")
        net:ToggleWardenWeaponSwitch(true)
        net.WriteTable(net.ReadTable())
        net.Broadcast()
    end)
end

if CLIENT then
    JB.WardenWaypoint = {}
    local waypointPlaced = false

    hook.Add("PostDrawOpaqueRenderables", "drawWaypoint", function()
        if enabled then
            if not waypointPlaced then
                JB:PlaceWaypoint()
            else
                JB:SetWaypoint()
            end
        end
    end)

    function JB:SetWaypoint()
        JB:DrawPoint()
    end    
    
    function JB:SendWaypoint(waypoint)
        net.Start("SendWardenWaypoint")
        --net.WriteInt(table.KeyFromValue(commandType, command), 32)
        net.SendToServer()
    end

    function JB:ClearWaypoints()
        enabled = false
        waypointPlaced = false
    end

    local trace
    local pointColor = Color(255, 255, 255, 150)
    local enabled = false

    function JB:PlaceWaypoint()
        if warden and LocalPlayer() == warden then
            pointColor = Color(255, 190, 0, 150)
            trace = LocalPlayer():GetEyeTrace()

            if input.IsMouseDown(MOUSE_LEFT) then
                pointColor = Color(255, 255, 255, 150)
                net.Start("SetWaypoint")
                net.WriteTable(trace)
                net.SendToServer()
            end

            JB:DrawPoint()
        end
    end

    function JB:DrawPoint()
        if not warden then
            enabled = false

            return
        end

        local tr = util.TraceLine({
            start = trace.HitPos,
            endpos = trace.HitPos + Vector(0, 0, -10000)
        })

        self:DrawWaypoint(tr)
    end

    net.Receive("PlaceWaypoint", function()
        enabled = true
        waypointPlaced = false
    end)

    net.Receive("UpdateWaypoint", function()
        waypointPlaced = true
        trace = net.ReadTable()
    end)


end