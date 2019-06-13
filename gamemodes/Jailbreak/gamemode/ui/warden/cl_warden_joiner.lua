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

function JAILBREAKWARDENJOINER:Init()
    self.panel = vgui.Create("DLabel", self)
    self.panel:SetFont("Jailbreak_Font_WardenJoiner")
    self.panel:SetText("Press F2 To Become Warden")
    self.panel:SetContentAlignment(5)
end

function JAILBREAKWARDENJOINER:PerformLayout(width, height)
    self.panel:Dock(FILL)
end

vgui.Register("JailbreakJoiner", JAILBREAKWARDENJOINER)
JB.joiner = {}

function JB.joiner:Show()
    self.hudPanel = vgui.Create("JailbreakJoiner")
    self.hudPanel:SetSize(w, h)
    self.hudPanel:SetPos(0, 0)

    JB.joiner.hide = function()
        self.hudPanel:Clear()
        self.hudPanel:Remove()
    end
end

-- hook.Add("InitPostEntity", "Hook Hud After Init", function()
--     JB.joiner:Show()

--     net.Receive("PlayerDied", function()
--         if (JB.joiner.hide) then
--             JB.joiner.hide()
--         end
--     end)
-- end)