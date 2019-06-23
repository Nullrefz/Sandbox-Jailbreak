local TIMERBAR = {}

local mats = {
    STOPWATCH = Material("jailbreak/vgui/stopwatch.png")
}

surface.CreateFont("Jailbreak_Font_Counter", {
    font = "Optimus",
    extended = false,
    size = 24,
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

surface.CreateFont("Jailbreak_Font_RoundPhase", {
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

local timeLeft = 0
local roundTime = 0

function TIMERBAR:Init()
    if roundPhase == "" then
        net.Start("RequestRound")
        net.SendToServer()
    end

    self.stopWatch = vgui.Create("DPanel", self)

    function self.stopWatch:Paint(width, height)
        if roundPhase == "" then return end
        draw.DrawRect(0, 0, width, height, Color(255, 255, 255), mats.STOPWATCH)
    end

    self.timeInfo = vgui.Create("DPanel", self)

    function self.timeInfo:Paint(width, height)
        if roundPhase == "Waiting" then
            draw.DrawText("∞", "Jailbreak_Font_Counter", toHRatio(5), -1, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
        else
            draw.DrawText(string.FormattedTime(math.Clamp(timeLeft - CurTime(), 0, timeLeft - CurTime()), "%02i:%02i"), "Jailbreak_Font_Counter", toHRatio(5), -1, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
        end

        draw.DrawSkewedRect(toHRatio(5), height / 2, width - toHRatio(5), toVRatio(6), toHRatio(2), Color(255, 255, 255, 50))
        draw.DrawSkewedRect(toHRatio(5), height / 2, ((timeLeft - CurTime()) / roundTime) * width - toHRatio(5), toVRatio(6), toHRatio(2), Color(255, 255, 255, 200))
        draw.DrawText(tostring(roundPhase), "Jailbreak_Font_RoundPhase", toHRatio(2), height - 16, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
    end
end

function TIMERBAR:PerformLayout(width, height)
    self.stopWatch:SetSize(42, 42)
    self.stopWatch:AlignBottom()
    self.timeInfo:SetPos(self.stopWatch:GetWide(), 0)
    self.timeInfo:SetSize(width - self.stopWatch:GetWide(), height)
end

vgui.Register("JailbreakTimerBar", TIMERBAR)

net.Receive("RoundChanged", function()
    roundPhase = net.ReadString()
    roundTime = net.ReadFloat()
    timeLeft = net.ReadFloat() + CurTime()
end)