if SERVER then
    util.AddNetworkString("SendWardenWaypoint")
    util.AddNetworkString("UpdateWaypoint")
    util.AddNetworkString("PlaceWaypoint")
    util.AddNetworkString("CancelWaypoint")
    util.AddNetworkString("SetWaypoint")

    net.Receive("SendWardenWaypoint", function(ln, ply)
        if not ply:IsWarden() then return end
        JB:SetWaypoint(net.ReadInt(32))
    end)

    function JB:SetWaypoint(type)
        self.warden:GiveWeapon("weapon_radio")
        self.warden:SelectWeapon("weapon_jb_radio")
        self:ToggleWardenWeaponSwitch(false)

        if type == "cancelWaypoint" then
            net.Start("CancelWaypoint")
        else
            net.Start("PlaceWaypoint")
            net.WriteString(type)
        end

        net.Broadcast()
    end

    net.Receive("SetWaypoint", function()
        net.Start("UpdateWaypoint")
        JB:ToggleWardenWeaponSwitch(true)
        net.WriteTable(net.ReadTable())
        net.Broadcast()
    end)
end

if CLIENT then
    JB.WardenWaypoint = {}
    local waypointPlaced = false
    local enabled = false
    local currentWaypoint

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
        net.WriteString(waypoint)
        net.SendToServer()
    end

    function JB:ClearWaypoints()
        enabled = false
        waypointPlaced = false
    end

    net.Receive("cancelWaypoint", function()
        JB:ClearWaypoints()
    end)

    local trace
    local pointColor = Color(255, 255, 255, 150)

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

            if "waypoint" then
                JB:DrawPoint()
            elseif "line" then
                JB:DrawLineuppoint()
            elseif "avoid" then
                JB:DrawAvoidpoint()
            elseif "question" then
                JB:DrawQuestionPoint()
            elseif "warning" then
                JB:DrawWarningPoint()
            else
                JB:DrawPoint()
            end
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
        currentWaypoint = net.ReadString()
        enabled = true
        waypointPlaced = false
    end)

    net.Receive("UpdateWaypoint", function()
        waypointPlaced = true
        trace = net.ReadTable()
    end)
end