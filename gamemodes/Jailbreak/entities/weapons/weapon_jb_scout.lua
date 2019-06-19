AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "Scout"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 3
    SWEP.SlotPos = 1
    SWEP.IconLetter = "A"
    killicon.AddFont("weapon_scout", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.HoldType = "ar2"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_Scout.Single")
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Damage = 80
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 1.25
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "css_762mm"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(-6, -5, 3)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.ZoomDelay = 0.25