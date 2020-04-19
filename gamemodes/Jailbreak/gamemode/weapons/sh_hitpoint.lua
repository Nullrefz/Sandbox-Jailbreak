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

    local dmg = 0

    function JB:DrawHitPoint(trace)
        if not LocalPlayer():Alive() then return end
        local curTime = CurTime()

        timer.Simple(1, function()
            hook.Remove("PostDrawOpaqueRenderables", tostring(dmg .. curTime))
        end)

        hook.Add("PostDrawOpaqueRenderables", tostring(dmg .. curTime), function()
            cam.Start3D2D(trace.HitPos, Angle(0, -90, 90) + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0), 0.1)
            draw.DrawText(dmg, "Jailbreak_Font_72", 0, -100 * (CurTime() - curTime), Color(255, 255, 255, 255 * (1 - (CurTime() - curTime))), TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end)
    end

    net.Receive("PlayerGotHurt", function()
        dmg = net.ReadInt(64)
    end)

    hook.Add("PlayerTraceAttack", "ShowHitPoint", function(ply, dmgInfo, trace)
        local tr = dmgInfo:GetAttacker():GetEyeTrace()
        JB:DrawHitPoint(tr)
    end)
end

if SERVER then
    util.AddNetworkString("PlayerGotHurt")

    hook.Add("PlayerHurt", "ShowHitPoint", function(victim, attacker, remaining, dmg)
        net.Start("PlayerGotHurt")
        net.WriteInt(dmg, 64)
        net.Broadcast()
    end)
end