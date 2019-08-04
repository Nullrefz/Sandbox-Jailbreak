local JAILBREAKHUD = {}

function JAILBREAKHUD:Init()
    self.header = vgui.Create("Panel", self)
    self.container = vgui.Create("Panel", self)
    self.footer = vgui.Create("Panel", self)
    self.healthBar = vgui.Create("JailbreakHealthBar", self.footer)
    self.timerBar = vgui.Create("JailbreakTimerBar", self.footer)
    self.weaponBar = vgui.Create("JailbreakWeaponBar", self.footer)
    self.commandBar = vgui.Create("JailbreakCommandBar", self.footer)
    self.wardenBar = vgui.Create("JailbreakWardenBar", self.header)
    self.actionBar = vgui.Create("JailbreakActionBar", self)
    self.notificationBar = vgui.Create("JailbreakNotificationBar", self.container)
end

function JAILBREAKHUD:PerformLayout(width, height)
    if self.header then
        self.header:Dock(TOP)
        self.header:SetTall(toVRatio(69 + 42 + 42))
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
        self.timerBar:SetWide(toHRatio(177))
        self.timerBar:Dock(LEFT)
        self.timerBar:DockMargin(0, self.footer:GetTall() / 2, 0, self.footer:GetTall() / 2 - toVRatio(50))
    end

    if self.wardenBar then
        self.wardenBar:Dock(LEFT)
        self.wardenBar:DockMargin(toHRatio(42), toVRatio(24), 0, toVRatio(16))
        self.wardenBar:SetSize(toHRatio(250), toVRatio(69))
        self.wardenBar:SetPos(toHRatio(42), toVRatio(24))
    end

    if self.commandBar then
        self.commandBar:Dock(LEFT)
        self.commandBar:SetWide(toHRatio(512))
        self.commandBar:DockMargin(50, self.footer:GetTall() / 2, 0, self.footer:GetTall() / 2 - toVRatio(50))
    end

    if self.actionBar then
        self.actionBar:Dock(LEFT)
        self.actionBar:SetWide(toHRatio(42))
        self.actionBar:DockMargin(16, 0, 0, 0)
    end

    if self.weaponBar then
        self.weaponBar:Dock(RIGHT)
        self.weaponBar:SetSize(toHRatio(250), toVRatio(100))
        self.weaponBar:DockMargin(0, toVRatio(42), toHRatio(42), 0)
    end

    if self.notificationBar then
         self.notificationBar:Dock(BOTTOM)
         self.notificationBar:SizeToContentsY()
    end
end

vgui.Register("JailbreakHUD", JAILBREAKHUD)
JB.hud = {}

function JB.hud:Show()
    self.hudPanel = vgui.Create("JailbreakHUD")
    self.hudPanel:SetSize(w, h)
    self.hudPanel:SetPos(0, 0)

    JB.hud.Hide = function()
        self.hudPanel:Remove()
        self.hudPanel:Clear()
    end
end

function JB.hud:UpdatePanels()
    if self.hudPanel and self.hudPanel:IsValid() then
        self.hudPanel:Remove()
        self.hudPanel = nil
    end

    JB.hud:Show()
end

hook.Add("InitPostEntity", "Hook Hud After Init", function()
    net.Receive("PlayerSpawned", function()
        JB.hud:UpdatePanels()
    end)

    net.Receive("PlayerDied", function() end) --JB.hud:UpdatePanels()
end)
-- function GM:ScoreboardShow()
--     JB.hud:Show()
-- end
-- function GM:ScoreboardHide()
--     JB.hud:Hide()
-- end