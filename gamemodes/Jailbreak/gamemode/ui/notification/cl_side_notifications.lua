JB.messageType = {
    MESSAGE = 1,
    WARNING = 2,
    ERROR = 3
}

function JB:DrawNotification(notify)
    self:StartNotification(notify.TIME, notify.COLOR, notify.TEXT, notify.TEXTCOLOR, notify.CALLBACK, notify.TYPE)
end

local mats = {
    BAR = Material("jailbreak/vgui/Bar.png", "smooth")
}

function JB:StartNotification(time, color, text, textColor, callback, type)
    local notification = vgui.Create("JailbreakNotification")
    notification:SetTime(time or 3)
    notification:SetColor(color or Color(255, 255, 255))
    notification:SetText(text or "Notification")
    notification:SetTextColor(textColor or Color(255, 255, 255))
    notification:SetCallBack(callback)
    notification:SetType(type)
    local len = notification.text:GetWide() + toHRatio(72)
    notification:SetSize(len, 32)
    notification:SetPos(w - len, h - 512)
end

local JAILBREAKNOTIFICATION = {}

surface.CreateFont("Jailbreak_Font_32", {
    font = "Optimus",
    extended = true,
    size = 32,
    weight = 0,
    blursize = 0,
    scanlines = 1,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false
})

function JAILBREAKNOTIFICATION:Init()
    self.panel = vgui.Create("Panel", self)
    self.panel.progress = 0
    self.panel.activeProgress = 0
    self.panel.devisions = 2
    self.panel.padding = toHRatio(5)
    self.panel.color = Color(255, 255, 255, 255)
    self.panel.typeColor = Color(255, 255, 255)
    self.panel.text = ""
    self.panel.textColor = Color(0, 0, 0)
    self.panel.skew = toHRatio(7)
    self.time = 3
    self.text = vgui.Create("DLabel", self.panel)
    self.text:SetFont("Jailbreak_Font_32")

    function self.panel:Paint(width, height)
        local wid = self.skew * 2
        local widPos = width * (1 - self.progress) + self.skew * 2 + toHRatio(self.padding * self.devisions) * (1 - self.activeProgress)

        for i = 1, self.devisions do
            draw.DrawSkewedRect(wid + widPos, 0, toHRatio(16), height, self.skew, self.typeColor)
            wid = wid + toHRatio(9) + toHRatio(self.padding) * self.activeProgress
        end

        draw.DrawSkewedRect(wid + widPos, 0, width - toHRatio(16) * 3, height, self.skew, self.color)
        self:GetParent().text:SetPos(wid + widPos + 10, height / 4)
    end

    self:DoEntryAnimation()
end

function JAILBREAKNOTIFICATION:PerformLayout(width, height)
    self.panel:Dock(FILL)
    self.panel:SetWide(self.text:GetWide())
end

function JAILBREAKNOTIFICATION:DoEntryAnimation()
    LerpFloat(0, 1, 0.2, function(prog)
        if self:IsValid() then
            self.panel.progress = prog
        end
    end, INTERPOLATION.SinLerp, function()
        if not self:IsValid() then return end
        self:DoActiveAnimation()
    end)
end

function JAILBREAKNOTIFICATION:DoActiveAnimation()
    LerpFloat(0, 1, self.time * 0.8, function(activeProg)
        if not self:IsValid() then return end
        self.panel.activeProgress = activeProg
    end, INTERPOLATION.SinLerp, function()
        if not self:IsValid() then return end
        self:DoEndingAnimation()
    end)
end

function JAILBREAKNOTIFICATION:DoEndingAnimation()
    LerpFloat(1, 0, self.time * 0.2, function(activeProg)
        if not self:IsValid() then return end
        self.panel.activeProgress = activeProg
    end, INTERPOLATION.CosLerp, function()
        if not self:IsValid() then return end
        self:DoExitAnimation()
    end)
end

function JAILBREAKNOTIFICATION:DoExitAnimation()
    LerpFloat(1, 0, 0.2, function(prog)
        if not self:IsValid() then return end
        self.panel.progress = prog
    end, INTERPOLATION.CosLerp, function()
        if not self:IsValid() then return end

        if self.panel.callback then
            self.panel.callback()
        end

        self:Clear()
        self:Remove()
    end)
end

function JAILBREAKNOTIFICATION:SetColor(color)
    self.panel.color = color
end

function JAILBREAKNOTIFICATION:SetTime(time)
    self.time = time

    timer.Simple(time + 1, function()
        if not self.panel then return end
        self:Clear()
        self:Remove()
    end)
end

function JAILBREAKNOTIFICATION:SetType(type)
    if type == JB.messageType.MESSAGE then
        self.panel.typeColor = Color(0, 220, 255, 200)
    elseif type == JB.messageType.WARNING then
        self.panel.typeColor = Color(255, 175, 0, 255)
    elseif type == JB.messageType.ERROR then
        self.panel.typeColor = Color(255, 0, 0, 255)
    end
end

function JAILBREAKNOTIFICATION:SetText(text)
    self.text:SetText(text)
    self.text:SizeToContentsX(6)
end

function JAILBREAKNOTIFICATION:SetTextColor(color)
    self.text:SetTextColor(color)
end

function JAILBREAKNOTIFICATION:SetCallBack(callback)
    self.panel.callback = callback
end

vgui.Register("JailbreakNotification", JAILBREAKNOTIFICATION)