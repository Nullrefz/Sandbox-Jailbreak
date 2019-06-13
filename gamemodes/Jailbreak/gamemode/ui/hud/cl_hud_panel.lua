local JAILBREAKHUD = {}

function JAILBREAKHUD:Init()
    self.header = vgui.Create("Panel", self)
    self.container = vgui.Create("Panel", self)
    self.footer = vgui.Create("Panel", self)
    self.healthBar = vgui.Create("JailbreakHealthBar", self.footer)
    self.timerBar = vgui.Create("JailbreakTimerBar", self.footer)
    self.wardenBar = vgui.Create("JailbreakWardenBar", self.header)
end

function JAILBREAKHUD:PerformLayout(width, height)
    if self.header then
        self.header:Dock(TOP)
        self.header:SetTall(toVRatio(69 + 42))
    end

    if self.footer then
        self.footer:Dock(TOP)
        self.footer:SetTall(toVRatio(160))
        self.footer:Dock(BOTTOM)
    end

    if self.container then
        self.container:Dock(FILL)
    end

    if self.healthBar then
        self.healthBar:SetSize(toHRatio(400), toVRatio(200))
        self.healthBar:Dock(LEFT)
        self.healthBar:DockMargin(toHRatio(42), 0, 0, 0)
    end

    if self.timerBar then
        self.timerBar:SetSize(toHRatio(177), toVRatio(46))
        self.timerBar:Dock(LEFT)
        self.timerBar:DockMargin(0, self.footer:GetTall() / 2, 0, self.footer:GetTall() / 2 - toVRatio(46))
    end

    if self.wardenBar then
        self.wardenBar:Dock(LEFT)
        self.wardenBar:DockMargin(toHRatio(42), toVRatio(24), 0, toVRatio(16))
        self.wardenBar:SetSize(toHRatio(250), toVRatio(69))
        self.wardenBar:SetPos(toHRatio(42), toVRatio(24))
    end
end

vgui.Register("JailbreakHUD", JAILBREAKHUD)
JB.hud = {}

function JB.hud:Show()
    self.hudPanel = vgui.Create("JailbreakHUD")
    self.hudPanel:SetSize(w, h)
    self.hudPanel:SetPos(0, 0)
end

function JB.hud:UpdatePanels()
    if self.hudPanel then
        self.hudPanel:Remove()
        self.hudPanel = nil
    end

    JB.hud:Show()
end

hook.Add("InitPostEntity", "Hook Hud After Init", function()
    net.Receive("PlayerSpawned", function()
        JB.hud:Show()
    end)

    net.Receive("PlayerDied", function()
        JB.hud:UpdatePanels()
    end)
end)