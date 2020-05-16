AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "Para"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 3
    SWEP.SlotPos = 1
    SWEP.IconLetter = "z"
    SWEP.ViewModelFlip = false
end

SWEP.HoldType = "ar2"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_m249.Single")
SWEP.Primary.Recoil = 2
SWEP.Primary.Damage = 60
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.05
SWEP.Primary.ClipSize = 100
SWEP.Primary.Delay = 0.09
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(-4.4, -3, 2)