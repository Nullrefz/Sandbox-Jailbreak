AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "AWP"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 3
    SWEP.SlotPos = 1
    SWEP.IconLetter = "A"
    killicon.AddFont("weapon_awp", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.HoldType = "ar2"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_AWP.Single")
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 115
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.005
SWEP.Primary.ClipSize = 10
SWEP.Primary.Delay = 1.5
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:TranslateFOV(fov)
    if self:GetNWMode() == AIM.Focus then
        self.Primary.Cone = 0.005
        return 10
    else
        self.Primary.Cone = 0.000
        return self.ViewModelFOV
    end
end

if CLIENT then
    function SWEP:AdjustMouseSensitivity()
        return self:GetNWMode() == AIM.Focus and .08 or 1
    end
end