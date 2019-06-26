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
        if not LocalPlayer():Alive() then return end
        local curTime = CurTime()

        timer.Simple(1, function()
            hook.Remove("PostDrawOpaqueRenderables", tostring(dmg .. curTime))
        end)

        hook.Add("PostDrawOpaqueRenderables", tostring(dmg .. curTime), function()
            print(dmg, trace)
            cam.Start3D2D(trace.HitPos, Angle(0, -90, 90) + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0), 0.1)
            draw.DrawText(dmg, "Jailbreak_Font_72", 0, -100 * (CurTime() - curTime), Color(255, 255, 255, 255 * (1 - (CurTime() - curTime))), TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end)
    end


    -- JB:DrawHitPoint(dmg, trace)
    hook.Add("PlayerTraceAttack", "ShowHitPoint", function(ply, dmgInfo, trace)
        local tr = util.TraceLine({
            start = ply:GetPos(),
            endpos = dmgInfo:GetDamagePosition()
        })

        JB:DrawHitPoint(dmgInfo:GetDamage(), tr)
    end)
end