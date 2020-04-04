local LOGSLIST = {}

surface.CreateFont("Jailbreak_Font_14", {
    font = "Optimus",
    extended = false,
    size = 16,
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

function LOGSLIST:Init()
    self.playerLog = vgui.Create("JailbreakPlayerLog", self)
    self.header = vgui.Create("Panel", self)
    self.footer = vgui.Create("Panel", self.header)
    self.roundID = vgui.Create("DPanel", self.header)
    self.timeScale = vgui.Create("JailbreakTimeScale", self.header)
    self.playHead = vgui.Create("Panel", self.timeScale)
    self.panel = vgui.Create("Panel", self)
    self.entries = vgui.Create("DScrollPanel", self)
    local panel = self
    local curPos = 0

    function self.playHead:Paint(width, height)
        curPos = math.Clamp(self:LocalCursorPos(), 0, self:LocalCursorPos())
        if (curPos < 0 or curPos > self:GetWide()) then return end
        curPos = self:GetParent():GetPos(curPos, self:GetWide())
        draw.DrawSkewedRect(curPos - 13, 0, 32, height, 4, Color(255, 255, 255))
        draw.DrawText(self:GetParent():GetMinute(curPos / self:GetWide()), "Jailbreak_Font_14", curPos, 0, Color(0, 0, 0), TEXT_ALIGN_CENTER)
    end

    function self.panel:Paint(width, height)
        if (curPos < 0 or curPos > panel.playHead:GetWide()) then return end
        surface.SetDrawColor(255, 255, 255)
        surface.DrawLine(curPos + width / 7, 18, curPos + width / 7, panel:GetTall())
    end

    function self.footer:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(15, 15, 15))
    end

    function self.roundID:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(40, 40, 40))
        draw.DrawRect(0, 0, width, height * 0.06, Color(15, 15, 15))
        draw.DrawRect(width - width * 0.005, 0, width * 0.005, height, Color(15, 15, 15))
        draw.DrawText("Round: " .. curPos, "Jailbreak_Font_32", width / 2, height / 6, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end

    for k, v in pairs(player.GetAll()) do
        local entryLog = self.entries:Add("JailbreakEntryLog")
        entryLog:Dock(TOP)
        entryLog:SetTall(64)
        entryLog:DockMargin(0, 1, 0, 1)
        entryLog:SetPlayer(v)
    end

    self.panel:MoveToFront()
    self.entries:GetVBar():SetWide(0)
end

function LOGSLIST:PerformLayout(width, height)
    self.header:Dock(TOP)
    self.footer:Dock(BOTTOM)
    self.footer:SetTall(2)
    self.header:SetTall(toVRatio(44))
    self.roundID:Dock(LEFT)
    self.roundID:SetWide(width / 7)
    self.timeScale:Dock(FILL)
    self.timeScale:DockMargin(0, 2, 0, 0)
    self.timeScale:SetTall(toVRatio(32))
	self.panel:SetSize(width, height)
	self.playHead:SetSize(self.timeScale:GetWide(), 16)
    self.entries:Dock(FILL)
    self.playerLog:Dock(RIGHT)
    self.playerLog:SetWide(0)
    self.playerLog:DockMargin(2, 2, 0, 0)
end

vgui.Register("JailbreakLogsList", LOGSLIST)