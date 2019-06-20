local WEAPONBAR = {}

function WEAPONBAR:Init()
    self.panel = vgui.Create("Panel", self)
    self.icon = vgui.Create("DKillIcon", self.panel)
    self.icon:SetName(LocalPlayer():GetActiveWeapon():GetClass())

end

function WEAPONBAR:PerformLayout(width, height)
    self.panel:Dock(FILL)
    self.icon:Dock(RIGHT)
    self.icon:SetWide(self.icon:GetTall() + 250)
    self.icon:DockMargin(0,  self.panel:GetTall() / 2, 0, 0)
    self.icon:SizeToContents()
end

function WEAPONBAR:PAINT(width, height)
    --killicon.Draw( 0, 0, "weapon_awp", 50 )
end

vgui.Register("JailbreakWeaponBar", WEAPONBAR)