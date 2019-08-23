local WEAPONBAR = {}
local weapon
local weaponIcons = {}

function WEAPONBAR:Init()
    self.panel = vgui.Create("Panel", self)
    self.ammoBar = vgui.Create("JailbreakAmmoBar", self.panel)
end

function WEAPONBAR:Think()
    -- ik i hate doing this
    if targetPlayer:Alive() and targetPlayer:GetActiveWeapon():IsValid() and weapon ~= targetPlayer:GetActiveWeapon():GetClass() then
        weapon = targetPlayer:GetActiveWeapon():GetClass()
        self:AddWeapon(weapon)
        self.ammoBar:SetWeapon(targetPlayer:GetActiveWeapon())
    elseif not targetPlayer:Alive() and #weaponIcons > 0 then
        while #weaponIcons > 0 do
            weaponIcons[1]:Remove()
            table.remove(weaponIcons, 1)
        end
    end
end

function WEAPONBAR:AddWeapon(wep)
    local icon = vgui.Create("DImage", self.panel)
    icon:SetSize(self.panel:GetTall() - 24, self.panel:GetTall() - 24)
    icon:SetPos(self.panel:GetWide() - icon:GetWide(), -32)
    icon:SetImage("jailbreak/vgui/weapons/" .. tostring(wep) .. ".png")
    table.insert(weaponIcons, icon)

    LerpFloat(0, 1, 0.2, function(interpolation)
        if icon:IsValid() then
            icon:SetImageColor(Color(255, 255, 255, 150 * interpolation))
            icon:SetPos(self.panel:GetWide() - icon:GetWide(), 0 - 16 * (1 - interpolation))
        end
    end, INTERPOLATION.SmoothStep)

    while #weaponIcons > 1 do
        weaponIcons[1]:Remove()
        table.remove(weaponIcons, 1)
    end
end

function WEAPONBAR:PerformLayout(width, height)
    self.panel:Dock(FILL)
    self.ammoBar:Dock(FILL)
    local tall = 24
    self.ammoBar:DockMargin(0, self.panel:GetTall() / 2 - tall, 0, self.panel:GetTall() / 2 - tall)
    -- self.icon:DockMargin(0,  self.panel:GetTall() / 2, 0, 0)
    -- self.icon:SizeToContents()
end

function WEAPONBAR:PAINT(width, height)
 





end

vgui.Register("JailbreakWeaponBar", WEAPONBAR)