include('sh_init.lua')
activeCommands = {}

net.Receive("UpdateCommands", function()
    activeCommands = net.ReadTable()
end)

hook.Add("PostDrawOpaqueRenderables", "example", function()
    local trace = LocalPlayer():GetEyeTrace()
    local angle = trace.HitNormal:Angle()
    cam.Start3D2D(trace.HitPos, angle + Angle(90, 0, 0), 2)
    draw.DrawArc(0, 0, 8.5, 0, 360, 0, Color(255, 255, 255, 10))
    draw.DrawArc(0, 0, 8.5, 8.3, 360, 0, Color(255, 255, 255, 150))

    for i = 1, 10 do
        draw.DrawArc(0, 0, 8, 7, math.sin(CurTime()) * 36 / 4 + 36 / 2, 36 * i, Color(255, 255, 255, 150))
    end

    draw.CapsuleBox(0, 0, 4, .2, 360, 45, 2, Color(255, 255, 255, 150))
    draw.CapsuleBox(0, 0, 4, .2, 360, 45 + 90, 2, Color(255, 255, 255, 150))
    draw.DrawArc(0, 0, 8.5 + CurTime() * -2 % 5, 8.4 + CurTime() * -2 % 5, 360, 0, Color(255, 255, 255, 2 * CurTime() % 5))
    cam.End3D2D()
end)