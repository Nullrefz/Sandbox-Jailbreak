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
local percent = 0 
function HEALTHTEXT:Init()
    -- self.panel = vgui.Create("DPanel", self)
end

function HEALTHTEXT:Paint(width, height)
    if not targetPlayer or not targetPlayer:Alive()  then
        percent = Lerp(FrameTime() * 5, percent, 0)
    else
        percent = Lerp(FrameTime() * 5, percent, 1)
    end
    draw.DrawText(tostring(math.Clamp(targetPlayer:Health() + (targetPlayer:Alive() and targetPlayer:Armor() or 0), 0, 1000000) .. "/" .. math.Clamp(targetPlayer:GetMaxHealth() + (targetPlayer:Alive() and targetPlayer:Armor() or 0), 0, 1000000)), "Jailbreak_Font_Health", toHRatio(5), 0, Color(255, 255, 255, 200 * percent), TEXT_ALIGN_LEFT)
end

vgui.Register("HealthText", HEALTHTEXT)