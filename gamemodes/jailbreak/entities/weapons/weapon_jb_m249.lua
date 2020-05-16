AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "M249"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 4
    SWEP.SlotPos = 1
    SWEP.IconLetter = "z"
    SWEP.ViewModelFlip = false

end

SWEP.HoldType = "smg"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_M249.Single")
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 26
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.045
SWEP.Primary.ClipSize = 50
SWEP.Primary.Delay = 0.07
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(0, 0, 2.5)
SWEP.IronSightsAng = Vector(0, 0, 0)