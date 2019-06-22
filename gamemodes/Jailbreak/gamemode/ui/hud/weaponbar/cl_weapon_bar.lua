local WEAPONBAR = {}
local weapon = "weapon_empty"
local weaponIcons = {}

function WEAPONBAR:Init()
    self.panel = vgui.Create("Panel", self)
end

function WEAPONBAR:Think()
    -- ik i hate doing this
    if LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid() and weapon ~= LocalPlayer():GetActiveWeapon():GetClass() then
        weapon = LocalPlayer():GetActiveWeapon():GetClass()
        self:AddWeapon(weapon)
    end
end

function WEAPONBAR:AddWeapon(wep)
    local icon = vgui.Create("DImage", self.panel)
    icon:SetSize(self.panel:GetTall(), self.panel:GetTall())
    icon:SetPos(self.panel:GetWide() - icon:GetWide(), -32)
    icon:SetImage("jailbreak/vgui/weapons/" .. tostring(wep) .. ".png")
    table.insert(weaponIcons, icon)
    local iconToRemove

    if #weaponIcons > 1 then
        iconToRemove = weaponIcons[1]
    end

    LerpFloat(0, 1, 0.2, function(interpolation)
        if icon then
            icon:SetImageColor(Color(255, 255, 255, 220 * interpolation))
            icon:SetPos(self.panel:GetWide() - icon:GetWide(), 0 - 32 * (1 - interpolation))
        end

        if iconToRemove and iconToRemove:IsValid() then
            iconToRemove:SetImageColor(Color(255, 255, 255, 220 * (1 - interpolation)))
            iconToRemove:SetPos(self.panel:GetWide() - icon:GetWide(), 0 + 32 * interpolation)
        end
    end, INTERPOLATION.SmoothStep, function()
        if iconToRemove then
            table.RemoveByValue(weaponIcons, iconToRemove)
            iconToRemove:Remove()
        end
    end)
end

function WEAPONBAR:PerformLayout(width, height)
    self.panel:Dock(FILL)
    -- self.icon:DockMargin(0,  self.panel:GetTall() / 2, 0, 0)
    --self.icon:SizeToContents()
end

function WEAPONBAR:PAINT(width, height)
    --killicon.Draw( 0, 0, "weapon_awp", 50 )
end

vgui.Register("JailbreakWeaponBar", WEAPONBAR)