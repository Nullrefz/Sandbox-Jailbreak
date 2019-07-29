local mats = {
    ARROW = Material("jailbreak/vgui/arrow.png", "smooth")
}

function JB:DrawLineuppoint(trace, prog, placed)
    local wid = 2
    local rot = trace.HitNormal:Angle() + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0)
    local rotation = 90 + (trace.Normal):Angle().y
    cam.Start3D2D(trace.HitPos, Angle(0, rotation, 0), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    local wide = 15 * #team.GetPlayers(Team.PRISONERS) + 10
    DrawBar(-wide / 2, wide, 1, 0.1, #team.GetPlayers(Team.PRISONERS) * 2, prog, pointColor)
    draw.CapsuleBox(-wide / 2 - 0.1, 1, wide * prog, 0.1, 360, 90, 0, Color(255, 255, 255, 150))
    draw.CapsuleBox(-wide / 2, -0.2, wide * prog, 0.1, 360, 90, 0, Color(255, 255, 255, 150))
    cam.End3D2D()
    cam.Start3D2D(trace.HitPos, rot, math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    local dist = math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100 - 1, 0, 1)
    local pos = trace.HitPos - LocalPlayer():GetPos()

    if not placed then
        pointColor = Color(255, 150, 0, 150)
    else
        if LocalPlayer():GetPos():Distance(trace.HitPos) < wide + 5 and math.abs(pos:Dot(trace.Normal)) < 3 then
            pointColor = Color(0, 255, 0, 150)
        else
            pointColor = Color(255, 255, 255, 150)
        end
    end

    draw.DrawRect(0 + 4 + math.sin(CurTime() * 2) * 2, -wid / 2, wid * 2, wid, Color(255, 255, 255, 222 * dist), mats.ARROW)
    cam.End3D2D()
end