include('sh_init.lua')
activeCommands = {}

net.Receive("UpdateCommands", function()
    activeCommands = net.ReadTable()
end)
local trace = LocalPlayer():GetEyeTrace()
local angle = trace.HitNormal:Angle()
hook.Add("PostDrawOpaqueRenderables", "example", function()

    cam.Start3D2D(trace.HitPos, angle + Angle(90, 0, 0), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    draw.DrawArc(0, 0, 8.5, 0, 360, 0, Color(255, 255, 255, 10))
    draw.DrawArc(0, 0, 8.5, 8.3, 360, 0, Color(255, 255, 255, 150))
    draw.DrawArc(0, 0, 6.7, 6.5, 360, 0, Color(255, 255, 255, 150))

    for i = 1, 10 do
        draw.DrawArc(0, 0, 8, 7, math.sin(CurTime()) * 36 / 8 + 30, 36 * i + CurTime() * 25, Color(255, 255, 255, 150))
    end

    draw.ChamferedBox(0, 0, 3, .2, 2, Color(255, 255, 255, 255))
    draw.ChamferedBox(0, 0, .2, 3, 2, Color(255, 255, 255, 255))
    draw.DrawArc(0, 0, 8.5 + CurTime() * -4 % 10, 8.4 + CurTime() * -4 % 10, 360, 0, Color(255, 255, 255, 16 * CurTime() % 40))
    cam.End3D2D()
    cam.Start3D2D(trace.HitPos, trace.HitNormal:Angle() + Angle(0 ,  (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y  , 0), math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100, 2, 15))
    local dist = math.Clamp(LocalPlayer():GetPos():Distance(trace.HitPos) / 100 - 1 , 0, 1)
    draw.ChamferedBox(0, 0, 21, .1, 2, Color(255, 255, 255, 222 * dist))
    draw.ChamferedBox(11, 0, 1, 1, 100, Color(255, 255, 255, 222 * dist))
    draw.DrawArc(0, 0, 6.7, 6.5, 360, 0, Color(255, 255, 255, 150 * dist))
 
    cam.End3D2D()
end)