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

local mats = {
    NextArrow = Material("jailbreak/vgui/nextArrow.png", "smooth"),
    PreviousArrow = Material("jailbreak/vgui/previousArrow.png", "smooth")
}

local currentRound
function LOGSLIST:Init()

    self.time = 300

    net.Receive("SendLog", function()
        -- Logs Info Receive
        local currentRound = net.ReadInt(32)
        JB.RoundNumber = net.ReadInt(32)

        self.time = net.ReadFloat()
        self.logs = net.ReadTable()
        -- Panel Creation
        if (not self.logs or table.IsEmpty(self.logs)) then
            self.noLogsPanel = vgui.Create("DPanel", self)
            self.noLogsPanel:Dock(FILL)
            function self.noLogsPanel:Paint(width, height)
                draw.DrawText("No Logs Registered", "Jailbreak_Font_32", width / 2, height / 2, Color(255, 255, 255),
                    TEXT_ALIGN_CENTER)
            end
            return
        end
        self.playerLog = vgui.Create("JailbreakPlayerLog", self)
        self.panel = vgui.Create("Panel", self)
        self.entries = vgui.Create("Panel", self)
        self.header = vgui.Create("Panel", self)
        self.footer = vgui.Create("Panel", self.header)
        self.timeScale = vgui.Create("JailbreakTimeScale", self.header)
        self.roundID = vgui.Create("DPanel", self.header)

        if (JB.RoundNumber > 1) then
            self.leftButton = vgui.Create("DButton", self.roundID)
            self.leftButton:SetSize(42, 42)
            self.leftButton:SetText("")
            function self.leftButton:Paint(width, height)
                draw.DrawRect(0, 0, width, height, Color(255, 255, 255, 255), mats.PreviousArrow)
            end

            self.leftButton.DoClick = function()
                hook.Run("OnLogsClosed", JB.RoundNumber - 1)
            end
        end

        if (JB.RoundNumber < currentRound) then
            self.rightButton = vgui.Create("DButton", self.roundID)
            self.rightButton:SetText("")
            self.rightButton:SetSize(42, 42)
            function self.rightButton:Paint(width, height)
                draw.DrawRect(0, 0, width, height, Color(255, 255, 255, 255), mats.NextArrow)
            end

            function self.rightButton:DoClick()
                hook.Run("OnLogsClosed", JB.RoundNumber + 1)
            end
        end
        function self.footer:Paint(width, height)
            draw.DrawRect(0, 0, width, height, Color(15, 15, 15))
        end

        function self.roundID:Paint(width, height)
            draw.DrawRect(0, 0, width, height, Color(40, 40, 40))
            draw.DrawRect(0, 0, width, height * 0.06, Color(15, 15, 15))
            draw.DrawRect(width - width * 0.005, 0, width * 0.005, height, Color(15, 15, 15))
            draw.DrawText("Round: " .. JB.RoundNumber, "Jailbreak_Font_32", width / 2, height / 6, Color(255, 255, 255),
                TEXT_ALIGN_CENTER)
        end

        self:LayoutEntries()
    end)
end

function LOGSLIST:LayoutEntries()
    local offset = 2
    local count = 0
    local barHeight = 64
    self.panels = {}
    local inspectors = {}
    for k, v in pairs(self.logs) do
        if istable(v) then
            local entryLog = vgui.Create("JailbreakEntryLog", self.entries)
            entryLog:SetSize(w, barHeight)
            table.insert(self.panels, entryLog)
            count = count + 1
            entryLog:SetPos(0, (k - 1) * (barHeight + offset))
            local inspector = vgui.Create("JailbreakLogInspector", self.entries)
            inspector.plyInd = k
            inspector:SetSize(w, 0)
            inspector:SetPos(0, (k - 1) * (barHeight + offset) + entryLog:GetTall())
            table.insert(self.panels, inspector)
            table.insert(inspectors, inspector)
            entryLog:SetInfo(v.User, v.UserTeam, v.UserName, v.Logs, self.time, k, inspector)
        end
    end

    self.timeScale:SetTime(self.time)
    hook.Add("LogClicked", "ToggleInspector", function(ind, plyInd, logs, minutes)
        for k, v in pairs(inspectors) do
            v:SetInfo(barHeight, ind, plyInd, logs, minutes)
        end
    end)
end

local totalPos = 0

function LOGSLIST:RepositionBars()
    if not self.panels then
        return
    end
    local x, y = self:LocalCursorPos()
    y = y - self.header:GetTall()
    y = math.Clamp(y - 64, 0, 99999)
    local pos = 0

    for k, v in pairs(self.panels) do
        if totalPos > self:GetTall() - self.header:GetTall() then
            v:SetPos(0, pos -
                ((y / (self:GetTall() - self.header:GetTall() - 64)) *
                    (totalPos - (self:GetTall() - self.header:GetTall()))))
        else
            v:SetPos(0, pos)
        end

        pos = pos + v:GetTall() + 2
    end

    totalPos = pos
end

function LOGSLIST:Think()
    self:RepositionBars()
end

function LOGSLIST:PerformLayout(width, height)
    if not self.logs or  table.IsEmpty(self.logs) then
        return
    end
    self.header:Dock(TOP)
    self.footer:Dock(BOTTOM)
    self.footer:SetTall(2)
    self.header:SetTall(toVRatio(44))

    self.timeScale:Dock(FILL)
    self.timeScale:DockMargin(0, 2, 0, 0)
    self.timeScale:SetTall(toVRatio(32))
    self.panel:SetSize(width, height)
    self.entries:Dock(FILL)
    self.playerLog:Dock(RIGHT)
    self.playerLog:SetWide(0)
    self.playerLog:DockMargin(2, 2, 0, 0)
    self.roundID:MoveToFront()
    self.roundID:Dock(LEFT)
    self.roundID:SetWide(width / 7)
    if self.rightButton then
        self.rightButton:Dock(RIGHT)
    end
    if self.leftButton then
        self.leftButton:Dock(LEFT)
    end
end

vgui.Register("JailbreakLogsList", LOGSLIST)
