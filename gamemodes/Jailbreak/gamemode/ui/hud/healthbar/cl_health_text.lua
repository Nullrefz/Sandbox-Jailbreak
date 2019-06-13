surface.CreateFont(
    "Jailbreak_Font_Health",
    {
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
    }
)

local HEALTHTEXT = {}

function HEALTHTEXT:Init()
   -- self.panel = vgui.Create("DPanel", self)
end

function HEALTHTEXT:Paint(width, height)
    draw.DrawText(tostring(LocalPlayer():Health() +  LocalPlayer():Armor() .. "/" .. LocalPlayer():GetMaxHealth() + LocalPlayer():Armor()), "Jailbreak_Font_Health", toHRatio(5), 0, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
end

vgui.Register("HealthText", HEALTHTEXT)
