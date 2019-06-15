local WARDENBAR = {}

surface.CreateFont("Jailbreak_Font_WardenTitle", {
    font = "Optimus",
    extended = false,
    size = 14,
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

surface.CreateFont("Jailbreak_Font_WardenName", {
    font = "Optimus",
    extended = false,
    size = 30,
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

function WARDENBAR:Init()
    self.wardenIcon = vgui.Create("CircularAvatar", self)
    self.wardenInfo = vgui.Create("DPanel", self)
    net.Start("OnWardenRequest")
    net.SendToServer()

    function self:Think()
        if (warden and  self.wardenIcon:Player() ~= warden) then
            self.wardenIcon:Player(warden)
            self.warden = warden
        end
    end

    function self.wardenInfo:Paint(width, height)
        draw.DrawText("Warden", "Jailbreak_Font_WardenTitle", toHRatio(10), height / 2 - toVRatio(30) / 2 - toVRatio(18) / 2, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)

        if warden then
            draw.DrawText(warden:Name(), "Jailbreak_Font_WardenName", toHRatio(5), height / 2 - toVRatio(30) / 2, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
        else
            draw.DrawText("None", "Jailbreak_Font_WardenName", toHRatio(5), height / 2 - toVRatio(30) / 2, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
        end
    end
end

function WARDENBAR:PerformLayout(width, height)
    self.wardenIcon:SetSize(height - 10, height - 10)
    self.wardenInfo:SetPos(self.wardenIcon:GetWide(), 0)
    self.wardenInfo:SetSize(width - self.wardenIcon:GetWide(), height)
end

vgui.Register("JailbreakWardenBar", WARDENBAR)