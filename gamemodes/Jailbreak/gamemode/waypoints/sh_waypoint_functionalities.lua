if SERVER then
    util.AddNetworkString("SendWardenWaypoint")
    util.AddNetworkString("UpdateWaypoint")
    util.AddNetworkString("PlaceWaypoint")
    util.AddNetworkString("CancelWaypoint")
    util.AddNetworkString("SetWaypoint")

    net.Receive("SendWardenWaypoint", function(ln, ply)
        if not ply:IsWarden() then return end
        JB:SetWaypoint(net.ReadString())
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
    local prog = 1
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

            self:HandleWaypoint()
        end
    end
    function JB:HandleWaypoint(tr)
        if currentWaypoint == "waypoint" then
            self:DrawWaypoint(tr or trace, prog, waypointPlaced)
        elseif currentWaypoint == "line" then
            self:DrawLineuppoint(trace, prog, waypointPlaced)
        elseif currentWaypoint == "avoid" then
            self:DrawAvoidpoint(tr or trace, prog, waypointPlaced)
        elseif currentWaypoint == "question" then
            self:DrawQuestionPoint(tr or trace, prog, waypointPlaced)
        elseif currentWaypoint == "warning" then
            self:DrawWarningPoint(tr or trace, prog, waypointPlaced)
        else
            self:DrawWaypoint(tr or trace, prog, waypointPlaced)
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

        self:HandleWaypoint(tr)
    end

    net.Receive("PlaceWaypoint", function()
        currentWaypoint = net.ReadString()
        print(currentWaypoint)

        enabled = true
        waypointPlaced = false
    end)

    net.Receive("UpdateWaypoint", function()
        waypointPlaced = true
        LerpFloat(0, 1, 1, function(progress) prog = progress end, INTERPOLATION.SinLerp)
        trace = net.ReadTable()
    end)
end