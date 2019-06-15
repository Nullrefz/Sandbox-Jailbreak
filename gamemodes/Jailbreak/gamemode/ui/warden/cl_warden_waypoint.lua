local mats = {
    ARROW = Material("jailbreak/vgui/arrow.png", "smooth")
}

local trace
local pointColor = Color(255, 255, 255, 150)
local enabled = false
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
    JB:DrawWaypoint()
end

function JB:PlaceWaypoint()
    pointColor = Color(255, 190, 0, 150)
    trace = LocalPlayer():GetEyeTrace()

    if input.IsMouseDown(MOUSE_LEFT) then
        pointColor = Color(255, 255, 255, 150)
        net.Start("SetWaypoint")
        net.WriteTable(trace)
        net.SendToServer()
    end

    JB:DrawWaypoint()
end

function JB:DrawWaypoint()
    local wid = 2

    local tr = util.TraceLine({
        start = trace.HitPos,
        endpos = trace.HitPos + Vector(0, 0, -10000)
    })

    cam.Start3D2D(tr.HitPos, Angle(0, 90, 0), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    render.SetStencilEnable(true)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilZFailOperation(STENCIL_REPLACE)
    draw.DrawArc(0, 0, 8.5, 0, 360, 0, Color(255, 255, 255, 10))
    draw.DrawArc(0, 0, 8.5, 8.3, 360, 0, Color(255, 255, 255, 150))
    draw.DrawArc(0, 0, 6.7, 6.5, 360, 0, Color(255, 255, 255, 150))

    for i = 1, 10 do
        draw.DrawArc(0, 0, 8, 7, math.sin(CurTime()) * 36 / 8 + 30, 36 * i + CurTime() * 25, pointColor)
    end

    draw.ChamferedBox(0, 0, 3, .2, 2, Color(255, 255, 255, 150))
    draw.ChamferedBox(0, 0, .2, 3, 2, Color(255, 255, 255, 150))
    draw.DrawArc(0, 0, 8.5 + CurTime() * -4 % 10, 8.4 + CurTime() * -4 % 10, 360, 0, Color(255, 255, 255, 16 * CurTime() % 40))
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    -- render.ClearBuffersObeyStencil(50, 50, 0, 255, false)
    render.SetStencilEnable(false)
    cam.End3D2D()
    cam.Start3D2D(trace.HitPos, tr.HitNormal:Angle() + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    local dist = math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100 - 1, 0, 1)
    draw.DrawRect(0 + 4 + math.sin(CurTime() * 2) * 2, -wid / 2, wid * 2, wid, Color(255, 255, 255, 222 * dist), mats.ARROW)
    cam.End3D2D()
end

JB.WardenWaypoint = {}

function JB.WardenWaypoint:Show()
    self.VotePanel = vgui.Create("JailbreakWardenVote")
    self.VotePanel:SetSize(w, h)
    self.VotePanel:SetPos(0, 0)

    JB.WardenVote.Hide = function()
        self.VotePanel:Clear()
        self.VotePanel:Remove()
    end
end

net.Receive("PlaceWaypoint", function()
    enabled = true
    waypointPlaced = false
end)

net.Receive("UpdateWaypoint", function()
    waypointPlaced = true
    trace = net.ReadTable()
end)