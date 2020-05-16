local HEALTHBAR = {}
targetPlayer = LocalPlayer()

function HEALTHBAR:Init()
    self.rightContainer = vgui.Create("Panel", self)
    self.leftContainer = vgui.Create("Panel", self)
    self.playerIcon = vgui.Create("PlayerModelPanel", self.leftContainer)
    self.areaIndicator = vgui.Create("AreaIndicator", self.rightContainer)
    self.healthText = vgui.Create("HealthText", self.rightContainer)
    self.healthMeter = vgui.Create("HealthMeter", self.rightContainer)
end

function HEALTHBAR:PerformLayout(width, height)
    self.leftContainer:SetSize(toHRatio(154), toVRatio(154))
    self.leftContainer:Dock(LEFT)
    self.leftContainer:DockMargin(0, height / 2 - toVRatio(154) / 2, 0, height / 2 - toVRatio(154) / 2)
    self.rightContainer:SetSize(width - self.leftContainer:GetWide(), height)
    self.rightContainer:SetPos(self.leftContainer:GetWide() + toHRatio(4), 0)
    self.rightContainer:Dock(RIGHT)
    self.rightContainer:DockMargin(0, height / 2 - toVRatio(20) + toVRatio(20), 0, height / 2 - toVRatio(46) - toVRatio(20))
    self.playerIcon:SetSize(self.leftContainer:GetWide(), self.leftContainer:GetTall())
    self.playerIcon:Center()
    self.healthText:Dock(TOP)
    self.healthText:DockMargin(toHRatio(8), 0, 0, toVRatio(-4))
    self.areaIndicator:Dock(BOTTOM)
    self.areaIndicator:DockMargin(toHRatio(2), toVRatio(2), 0, 0)

    self.healthMeter:Dock(FILL)
    self.healthMeter:DockMargin(toHRatio(2), 0, 0, 0)
end

vgui.Register("JailbreakHealthBar", HEALTHBAR)

net.Receive("SpectatePlayer", function()
    --chosenPlayer = player.GetBySteamID()
    local ply = player.GetByUniqueID(net.ReadString())

    if ply then
        targetPlayer = ply
    else
        targetPlayer = LocalPlayer()
    end
end)