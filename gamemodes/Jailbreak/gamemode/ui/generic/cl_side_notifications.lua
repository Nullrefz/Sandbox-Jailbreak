function JB:DrawNotification(notify)
    self:StartNotification(notify.TIME, notify.COLOR, notify.TEXT, notify.TEXTCOLOR, notify.CALLBACK)
end

function JB:StartNotification(time, color, text, textColor, callback)
    local notification = vgui.Create("JailbreakNotification")
    notification:SetSize(258, 42)
    notification:SetPos(w - 258, h - 512)
    notification:SetTime(time or 3)
    notification:SetColor(color or Color(255, 255, 255))
    notification:SetText(text or "Notification")
    notification:SetTextColor(textColor or Color(255, 255, 255))
    notification:SetCallBack(callback)
end

local JAILBREAKNOTIFICATION = {}

surface.CreateFont("Jailbreak_Font_42", {
    font = "Optimus",
    extended = false,
    size = 42,
    weight = 5,
    blursize = 0,
    scanlines = 0,
    antialias = false,
    underline = false,
    italic = true,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = true
})

function JAILBREAKNOTIFICATION:Init()
    self.panel = vgui.Create("Panel", self)
    self.panel.progress = 0
    self.panel.activeProgress = 0
    self.panel.devisions = 2
    self.panel.padding = 5
    self.panel.color = Color(255, 255, 255, 255)
    self.panel.text = ""
    self.panel.textColor = Color(0, 0, 0)
    self.panel.skew = toHRatio(7)
    self.time = 3

    function self.panel:Paint(width, height)
        local wid = 0
        local widPos =  width * (1 - self.progress) + self.skew * 2 + toHRatio(self.padding * self.devisions) * (1 - self.activeProgress)

        for i = 1, self.devisions do
            draw.DrawSkewedRect(wid + widPos, 0, toHRatio(16), height, self.skew, self.color)
            wid = wid + toHRatio(9) + toHRatio(self.padding) * self.activeProgress
        end

        draw.DrawSkewedRect(wid + widPos, 0, width - toHRatio(16) * 3, height, self.skew, self.color)
        draw.DrawText(self.text, "Jailbreak_Font_42",wid + widPos, 0, self.textColor, TEXT_ALIGN_LEFT)
    end

    self:DoEntryAnimation()
end

function JAILBREAKNOTIFICATION:PerformLayout(width, height)
    self.panel:Dock(FILL)
end

function JAILBREAKNOTIFICATION:DoEntryAnimation()
    LerpFloat(0, 1, 0.2, function(prog)
        self.panel.progress = prog
    end, INTERPOLATION.SinLerp, function()
        self:DoActiveAnimation()
    end)
end

function JAILBREAKNOTIFICATION:DoActiveAnimation()
    LerpFloat(0, 1, self.time * 0.1, function(activeProg)
        self.panel.activeProgress = activeProg
    end, INTERPOLATION.SinLerp, function()
        self:DoEndingAnimation()
    end)
end

function JAILBREAKNOTIFICATION:DoEndingAnimation()
    LerpFloat(1, 0, self.time * 0.8, function(activeProg)
        self.panel.activeProgress = activeProg
    end, INTERPOLATION.CosLerp, function()
        self:DoExitAnimation()
    end)
end

function JAILBREAKNOTIFICATION:DoExitAnimation()
    LerpFloat(1, 0, 0.2, function(prog)
        self.panel.progress = prog
    end, INTERPOLATION.CosLerp, function()
        if self.callback then
            self.callback()
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
end

function JAILBREAKNOTIFICATION:SetText(text)
    self.panel.text = text
end

function JAILBREAKNOTIFICATION:SetTextColor(color)
    self.panel.textColor = color
end

function JAILBREAKNOTIFICATION:SetCallBack(callback)
    self.panel.callback = callback
end

vgui.Register("JailbreakNotification", JAILBREAKNOTIFICATION)

concommand.Add("jb_notify", function()
    local notifyTable = {
        TIME = 3,
        COLOR = Color(255, 255, 255),
        TEXT = "Hello",
        TEXTCOLOR = Color(0, 0, 0)
    }

    JB:DrawNotification(notifyTable)
end)