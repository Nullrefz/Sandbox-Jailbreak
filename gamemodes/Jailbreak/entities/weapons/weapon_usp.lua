AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "USP"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 3
    SWEP.SlotPos = 1
    SWEP.IconLetter = "A"
    killicon.AddFont("weapon_usp", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.HoldType = "revolver"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.ViewModel = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_USP.Single")
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 34
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.ClipSize = 12
SWEP.Primary.Delay = 0
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(-5, 0, 2)
SWEP.IronSightsAng = Vector(0, 1, 0)