local mats = {
    ARROW = Material("jailbreak/vgui/arrow.png", "smooth"),
    ICON = Material("jailbreak/vgui/icons/avoid.png", "smooth"),
    AVOID =  Material("jailbreak/vgui/icons/avoid.png", "smooth"),
    QUESTION = Material("jailbreak/vgui/icons/question.png", "smooth"),
    WARNING = Material("jailbreak/vgui/icons/warning.png", "smooth")
}

function JB:DrawWaypoint(trace, prog, placed, color, mat)
    local wid = 2
    cam.Start3D2D(trace.HitPos, Angle(0, 90, 0), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    draw.DrawArc(0, 0, 8.5 * prog, 0, 360, 0, Color(255, 255, 255, 10))
    draw.DrawArc(0, 0, 8.5 * prog, 8.3 * prog, 360 * prog, 0, Color(255, 255, 255, 150))
    draw.DrawArc(0, 0, 6.7 * prog, 6.5 * prog, 360 * prog, 0, Color(255, 255, 255, 150))

    for i = 1, 10 * prog do
        draw.DrawArc(0, 0, 8 * prog, 7 * prog, (1.01 - math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos), 0, 1000) / 1000) * 36.0, 36 * i + CurTime() * 25, pointColor)
    end

    draw.ChamferedBox(0, 0, 3, .2, 2, Color(255, 255, 255, 150 * prog))
    draw.ChamferedBox(0, 0, .2, 3, 2, Color(255, 255, 255, 150 * prog))

    if pointColor ~= Color(0, 255, 0, 150) then
        draw.DrawArc(0, 0, 8.5 + CurTime() * -4 % 10, 8.4 + CurTime() * -4 % 10, 360, 0, Color(255, 255, 255, 16 * CurTime() % 40))
    end

    cam.End3D2D()
    cam.Start3D2D(trace.HitPos, trace.HitNormal:Angle() + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0) + Angle(90, -90, 90), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    local dist = math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100 - 1, 0, 1)

    if not placed then
        pointColor = Color(255, 150, 0, 150)
    else
        if LocalPlayer():GetPos():Distance(trace.HitPos) < 10 then
            pointColor = color or Color(0, 255, 0, 150)
        else
            pointColor = Color(255, 255, 255, 150)
        end
    end

    surface.SetDrawColor(255, 255, 255, 222 * dist * prog)

    if mat then
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(-wid * 2, -12 + math.sin(CurTime() * 2) * 2, wid * 4, wid * 4)
    else
        surface.SetMaterial(mats.ARROW)
        surface.DrawTexturedRect(-wid / 2, -8 + math.sin(CurTime() * 2) * 2, wid, wid * 2)
    end

    cam.End3D2D()
end

function JB:DrawAvoidpoint(trace, prog, placed)
    JB:DrawWaypoint(trace, prog, placed, Color(255, 0, 0), mats.AVOID)
end

function JB:DrawQuestionPoint(trace, prog, placed)
    JB:DrawWaypoint(trace, prog, placed, Color(0, 150, 225), mats.QUESTION)
end

function JB:DrawWarningPoint(trace, prog, placed)
    JB:DrawWaypoint(trace, prog, placed, Color(255, 200, 0), mats.WARNING)
end