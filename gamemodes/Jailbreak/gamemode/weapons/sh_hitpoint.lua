if SERVER then
    util.AddNetworkString("PlayerDamaged")

    hook.Add("EntityTakeDamage", "SendPlayerDamage", function(target, dmginfo)
        if (target:IsPlayer()) then
            net.Start("PlayerDamaged", true)
            net.WriteFloat(dmginfo:GetDamage())
            net.WriteVector(dmginfo:GetDamagePosition())
            net.Broadcast()
        end
    end)
end

if CLIENT then
    surface.CreateFont("Jailbreak_Font_72", {
        font = "Optimus",
        extended = false,
        size = 72,
        weight = 5,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = true,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    })

    function JB:DrawHitPoint(dmg, trace)
        local curTime = CurTime()

        timer.Simple(1, function()
            hook.Remove("PostDrawOpaqueRenderables", tostring(dmg .. curTime))
        end)

        print(dmg)

        hook.Add("PostDrawOpaqueRenderables", tostring(dmg .. curTime), function()
            cam.Start3D2D(trace.HitPos, Angle(0, -90, 90) + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0), 0.1)
            draw.DrawText(dmg, "Jailbreak_Font_72", -72 / 2, -72 / 2 - 100 * (CurTime() - curTime), Color(255, 255, 255, 255 * (1 - (CurTime() - curTime))), TEXT_ALIGN_LEFT)
            render.SetStencilEnable(false)
            cam.End3D2D()
        end)
    end

    net.Receive("PlayerDamaged", function()
        local dmg = net.ReadFloat()
        local playerPos = LocalPlayer():GetPos()
        local endPos = net.ReadVector()

        local trace = util.TraceLine({
            start = playerPos,
            endpos = endPos
        })

        JB:DrawHitPoint(dmg, trace)
    end)
    --JB:DrawHitPoint(dmg, pos)
end