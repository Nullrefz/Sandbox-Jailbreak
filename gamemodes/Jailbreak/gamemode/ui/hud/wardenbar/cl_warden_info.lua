local WARDENBAR = {}

surface.CreateFont("Jailbreak_Font_WardenTitle", {
    font = "Optimus",
    extended = false,
    size = 18,
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

local percent = 0

function WARDENBAR:Init()
    self.background = vgui.Create("DImage", self)
    self.wardenIcon = vgui.Create("CircularAvatar", self.background)
    self.wardenIcon:Player(warden)
    self.background:SetImage("jailbreak/vgui/DeepBlue_Icon_Slot.png")
    self.wardenInfo = vgui.Create("DPanel", self)
    self.warden = warden
    percent = 0
    net.Start("OnWardenRequest")
    net.SendToServer()

    function self:Think()
        self.background:SetImageColor(Color(255, 255, 255, 255 * percent))

        if self.warden ~= warden then
            self.warden = warden
            self.wardenIcon:Show()
            self.wardenIcon:Player(warden)
        elseif self.wardenIcon and not self.warden then
            self.wardenIcon:Hide()
        end
    end

    function self.wardenInfo:Paint(width, height)
        if warden then
            percent = Lerp(FrameTime() * 5, percent, 1)
        else
            percent = Lerp(FrameTime() * 5, percent, 0)
        end

        draw.DrawText("Warden", "Jailbreak_Font_WardenTitle", toHRatio(10), height / 2 - toVRatio(30) / 2 - toVRatio(18) / 2, Color(255, 255, 255, 150 * percent), TEXT_ALIGN_LEFT)

        if warden then
            draw.DrawText(warden:Name(), "Jailbreak_Font_WardenName", toHRatio(5), height / 2 - toVRatio(30) / 2, Color(255, 255, 255, 200 * percent), TEXT_ALIGN_LEFT)
        else
            draw.DrawText("None", "Jailbreak_Font_WardenName", toHRatio(5), height / 2 - toVRatio(30) / 2, Color(255, 255, 255, 50 * percent), TEXT_ALIGN_LEFT)
        end
    end
end

function WARDENBAR:PerformLayout(width, height)
    self.background:SetSize(height, height)
    local iconSizePadding = 32

    if self.wardenIcon then
        self.wardenIcon:SetSize(height - toHRatio(iconSizePadding), height - toVRatio(iconSizePadding))
        self.wardenIcon:Center()
    end

    self.wardenInfo:SetPos(self.background:GetWide(), 0)
    self.wardenInfo:SetSize(width - self.background:GetWide(), height)
end

vgui.Register("JailbreakWardenBar", WARDENBAR)