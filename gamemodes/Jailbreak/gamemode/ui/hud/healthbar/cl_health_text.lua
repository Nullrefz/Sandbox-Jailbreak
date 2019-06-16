surface.CreateFont("Jailbreak_Font_Health", {
    font = "Optimus",
    extended = false,
    size = 20,
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

local HEALTHTEXT = {}

function HEALTHTEXT:Init()
    -- self.panel = vgui.Create("DPanel", self)
end

function HEALTHTEXT:Paint(width, height)
    draw.DrawText(tostring(math.Clamp(LocalPlayer():Health() + (LocalPlayer():Alive() and LocalPlayer():Armor() or 0), 0, 1000000) .. "/" .. math.Clamp(LocalPlayer():GetMaxHealth() +  (LocalPlayer():Alive() and LocalPlayer():Armor() or 0), 0, 1000000)), "Jailbreak_Font_Health", toHRatio(5), 0, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
end

vgui.Register("HealthText", HEALTHTEXT)