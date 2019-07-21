local mats = {
    ARROW = Material("jailbreak/vgui/arrow.png", "smooth")
}

function JB:DrawWaypoint(trace)
    local wid = 2
    cam.Start3D2D(trace.HitPos, Angle(0, 90, 0), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    draw.DrawArc(0, 0, 8.5, 0, 360, 0, Color(255, 255, 255, 10))
    draw.DrawArc(0, 0, 8.5, 8.3, 360, 0, Color(255, 255, 255, 150))
    draw.DrawArc(0, 0, 6.7, 6.5, 360, 0, Color(255, 255, 255, 150))

    for i = 1, 10 do
        draw.DrawArc(0, 0, 8, 7, (1.01 - math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos), 0, 1000) / 1000) * 36.0, 36 * i + CurTime() * 25, pointColor)
    end

    draw.ChamferedBox(0, 0, 3, .2, 2, Color(255, 255, 255, 150))
    draw.ChamferedBox(0, 0, .2, 3, 2, Color(255, 255, 255, 150))
    draw.DrawArc(0, 0, 8.5 + CurTime() * -4 % 10, 8.4 + CurTime() * -4 % 10, 360, 0, Color(255, 255, 255, 16 * CurTime() % 40))
    cam.End3D2D()
    cam.Start3D2D(trace.HitPos, trace.HitNormal:Angle() + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    local dist = math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100 - 1, 0, 1)

    if LocalPlayer():GetPos():Distance(trace.HitPos) < 30 then
        pointColor = Color(0, 255, 0, 150)
    else
        pointColor = Color(255, 255, 255, 150)
    end

    draw.DrawRect(0 + 4 + math.sin(CurTime() * 2) * 2, -wid / 2, wid * 2, wid, Color(255, 255, 255, 222 * dist), mats.ARROW)
    cam.End3D2D()
end