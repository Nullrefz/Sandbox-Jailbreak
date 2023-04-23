function GM:HUDDrawTargetID()
end

local plyCount = 0
local bar = Material("jailbreak/vgui/Bar.png", "smooth")

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
    hook.Add("PostDrawOpaqueRenderables", tostring("TargetInfoOf" .. ply:UserID()), function()
        if not IsValid(ply) then return end
        health = Lerp(FrameTime() * 10, health, ply:Health() + ply:Armor())

        if LocalPlayer():GetEyeTrace().Entity == ply then
            visibility = Lerp(FrameTime() * 2, visibility, 1)
        else
            visibility = Lerp(FrameTime() * 2, visibility, math.Clamp(1 - LocalPlayer():GetPos():Distance(ply:GetPos() + Vector(0, 0, 80)) / 800, 0, 1))
        end
        if visibility < 0.05 then return end
        if not ply:Alive() then return end
        cam.Start3D2D(ply:GetPos() + Vector(0, 0, 80), Angle(0, -90, 90) + Angle(0, (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetEyeTrace().StartPos):Angle().y, 0), 0.1)
        draw.DrawText(ply:Name(), "Jailbreak_Font_46", 0, 0, Color(team.GetColor(ply:Team()).r + 50, team.GetColor(ply:Team()).g + 50, team.GetColor(ply:Team()).b + 50, 220 * visibility), TEXT_ALIGN_CENTER)
        DrawCenterBar(-100, 46, 200, 6, 2, (ply:GetMaxHealth() + ply:Armor()) / 10, health / (ply:GetMaxHealth() + ply:Armor()), Color(
            health > 20 and 255 or 255,
            health > 20 and 255 or 0,
            health > 20 and 255 or 2, 255 * visibility), 
            bar)
        DrawCenterBar(-100, 46, 200, 6, 2, (ply:GetMaxHealth() + ply:Armor()) / 10, 1, Color(255, 255, 255, 25  * visibility), bar)
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