local AMMOBAR = {}
local weapon
local mats = {
    BAR = Material("jailbreak/vgui/bar.png", "smooth")
}
surface.CreateFont("Jailbreak_Font_Ammo", {
    font = "Optimus",
    extended = false,
    size = 24,
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

function AMMOBAR:Init()
    self.curAmmo = 0
    self.maxAmmo = 0
    self.ply = targetPlayer

    function self:Paint(width, height)
        if not targetPlayer:Alive() or not weapon or not weapon:IsValid() or not targetPlayer:GetActiveWeapon():IsValid() then return end

        if (weapon:GetMaxClip1() > 0) then
            draw.DrawText(targetPlayer:GetActiveWeapon():Clip1() .. '/' .. weapon:GetMaxClip1(), "Jailbreak_Font_Ammo", width - 104, -4, Color(255, 255, 255, 200), TEXT_ALIGN_RIGHT)
        end

        self.maxAmmo = Lerp(FrameTime() * 40, self.maxAmmo, weapon:GetMaxClip1())
        self.curAmmo = Lerp(FrameTime() * 20, self.curAmmo, targetPlayer:GetActiveWeapon():Clip1() / self.maxAmmo)
        DrawBarInverse(5, 24, width - 5, height / 2, 5, self.maxAmmo, self.curAmmo, Color(255, 255, 255, 220), mats.BAR)
        DrawBarInverse(5, 24, width - 5, height / 2, 5, self.maxAmmo, 1, Color(255, 255, 255, 25), mats.BAR)
    end
end

function AMMOBAR:SetWeapon(wep)
    weapon = wep
end

vgui.Register("JailbreakAmmoBar", AMMOBAR)