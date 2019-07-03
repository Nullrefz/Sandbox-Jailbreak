function GM:HUDDrawTargetID()
end

local plyCount = 0

surface.CreateFont("Jailbreak_Font_42", {
    font = "Optimus",
    extended = false,
    size = 46,
    weight = 5,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = true,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false
})

function JB:DrawTargetInfo(ply, trace)
    local health = ply:Health() + ply:Armor()
    local visibility = 1
    local pos = ply:GetPos() + Vector(0, 0, 80)

    hook.Add("PostDrawOpaqueRenderables", tostring("TargetInfoOf" .. ply:Name()), function()
        if not IsValid(ply) then
            hook.Remove("PostDrawOpaqueRenderables", "TargetInfoOf" .. ply:Name())

            return
        end

        health = Lerp(FrameTime() * 10, health, ply:Health() + ply:Armor())

        if LocalPlayer():GetEyeTrace().Entity == ply then
            visibility = Lerp(FrameTime() * 2, visibility, 1)
        else
            visibility = Lerp(FrameTime() * 2, visibility, math.Clamp(1 - LocalPlayer():GetPos():Distance(ply:GetPos() + Vector(0, 0, 80)) / 800, 0, 1))
        end

        if not ply:Alive() then return end
        cam.Start3D2D(ply:GetPos() + Vector(0, 0, 80), Angle(0, -90, 90) + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0), 0.1)
        draw.DrawText(ply:Name(), "Jailbreak_Font_46", 0, 0, Color(255, 255, 255, 220 * visibility), TEXT_ALIGN_CENTER)
        DrawCenterBar(-100, 46, 200, 6, 2, (ply:GetMaxHealth() + ply:Armor()) / 10, health / (ply:GetMaxHealth() + ply:Armor()), Color(255, 255, 255, 220 * visibility), Material("jailbreak/vgui/Bar.png", "smooth"))
        DrawCenterBar(-100, 46, 200, 6, 2, (ply:GetMaxHealth() + ply:Armor()) / 10, 1, Color(255, 255, 255, 50 * visibility), Material("jailbreak/vgui/Bar.png", "smooth"))
        cam.End3D2D()
    end)
end

function JB:RefreshTargetInfo(ID)
    for k, v in pairs(player.GetAll()) do
        if v ~= LocalPlayer() then
            self:DrawTargetInfo(v)
        end
    end
end

hook.Add("Think", "EnableTargedInfo", function()
    if plyCount ~= #player.GetAll() then
        JB:RefreshTargetInfo()
        plyCount = #player.GetAll()
    end
end)