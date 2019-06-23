local JAILBREAKWARDENJOINER = {}

surface.CreateFont("Jailbreak_Font_WardenJoiner", {
    font = "Optimus",
    extended = false,
    size = 42,
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

local textToShow = ""

function JAILBREAKWARDENJOINER:Init()
    self.panel = vgui.Create("DLabel", self)
    self.panel:SetFont("Jailbreak_Font_WardenJoiner")
    self.panel:SetText(textToShow)
    self.panel:SetContentAlignment(5)
end

function JAILBREAKWARDENJOINER:PerformLayout(width, height)
    self.panel:Dock(FILL)
end

function JAILBREAKWARDENJOINER:Think()
    if LocalPlayer():Team() == Team.PRISONERS and #team.GetPlayers(Team.GUARDS) == 0 and #team.GetPlayers(Team.PRISONERS) > 1 then
        self.panel:SetText("Game Cannot Start Without Guards")
    elseif LocalPlayer():Team() == Team.GUARDS and #team.GetPlayers(Team.PRISONERS) == 0 and #team.GetPlayers(Team.GUARDS) > 1 then
        self.panel:SetText("Game Cannot Start Without Prisoners")
    elseif LocalPlayer():Team() == Team.GUARDS and not warden and roundPhase == "Preparing" then
        self.panel:SetText("Press F2 To Become Warden")
    else
        self.panel:SetText("")
    end
end

vgui.Register("JailbreakJoiner", JAILBREAKWARDENJOINER)
JB.joiner = {}

function JB.joiner:Show()
    self.joinPanel = vgui.Create("JailbreakJoiner")
    self.joinPanel:SetSize(w, h / 2)
    self.joinPanel:SetPos(0, 0)

    JB.joiner.hide = function()
        if not self.joinPanel and self.joinPanel:IsValid() then return end
        self.joinPanel:Clear()
        self.joinPanel:Remove()
    end
end

hook.Add("InitPostEntity", "Hook Notification After Init", function()
    JB.joiner:Show()
end)