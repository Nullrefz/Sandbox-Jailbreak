local LOGSWINDOW = {}
JB.RoundNumber = 1
local mats = {
    CLOSE = Material("jailbreak/vgui/icons/exit.png")
}

surface.CreateFont("Jailbreak_Font_64", {
    font = "Optimus",
    extended = false,
    size = 64,
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

function LOGSWINDOW:Init()
    hook.Add("CreateMove", "CloseOnEscape", function()
        if input.WasKeyPressed(KEY_ESCAPE) and IsValid(self) then
            self:Remove()
        end
    end)
    net.Start("LogRequest")

    net.WriteInt(JB.RoundNumber, 32)
    net.SendToServer()
    self:MakePopup()
    self.header = vgui.Create("Panel", self)

    function self.header:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(30, 30, 30))
        draw.DrawRect(0, height / 2, width, height / 2, Color(25, 25, 25))
        draw.DrawRect(0, height - height * 0.05, width, height * 0.05, Color(0, 150, 255))
        draw.DrawText("Logs", "Jailbreak_Font_64", width / 2 - 74 / 2, -toVRatio(4), Color(255, 255, 255),
            TEXT_ALIGN_CENTER)
    end

    self.closeButton = vgui.Create("DImageButton", self.header)
    self.closeButton:SetImage("jailbreak/vgui/icons/exit.png")
    local panel = self

    self.closeButton.DoClick = function()
        panel:Delete()
    end

    self.body = vgui.Create("Panel", self)

    function self.body:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(40, 40, 40))
    end

    hook.Add("OnLogsClosed", "ClosingLogs", function(round)
        panel:Delete()
        JB:OpenLogWindow(round)
    end)

    self.content = vgui.Create("JailbreakLogsList", self.body)

end

function LOGSWINDOW:PerformLayout(width, height)
    self.header:Dock(TOP)
    self.header:SetTall(toVRatio(64))
    self.closeButton:Dock(RIGHT)
    self.closeButton:SetWide(toVRatio(64))
    self.body:Dock(FILL)
    self.content:Dock(FILL)
end

function LOGSWINDOW:Think()
    if input.WasKeyPressed(KEY_ESCAPE) and IsValid(self) then
        self:Delete()
    end
end

function LOGSWINDOW:Delete()
    self:Clear()
    self:Remove()
    hook.Remove("CreateMove", "CloseOnEscape")
end

vgui.Register("JailbreakLogsWindow", LOGSWINDOW)
JB.logsWidow = {}

function JB.logsWidow:Show()
    self.logsPanel = vgui.Create("JailbreakLogsWindow")
    self.logsPanel:SetSize(w, h)
end

function JB:OpenLogWindow(roundNumber)
    if roundNumber then
        JB.RoundNumber = roundNumber
    else
        JB.RoundNumber = -1
    end
    self.logsWidow:Show()
end

net.Receive("OpenLogs", function()
    JB:OpenLogWindow()
end)
