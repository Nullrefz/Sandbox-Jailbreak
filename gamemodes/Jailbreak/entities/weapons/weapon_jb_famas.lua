AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "Famas"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 3
    SWEP.SlotPos = 1
    SWEP.IconLetter = "t"
    SWEP.ViewModelFlip = false

end

SWEP.HoldType = "smg"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_famas.Single")
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.045
SWEP.Primary.ClipSize = 25
SWEP.Primary.Delay = 0.07
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(0, 0, 2.5)
SWEP.IronSightsAng = Vector(0, 0, 0)