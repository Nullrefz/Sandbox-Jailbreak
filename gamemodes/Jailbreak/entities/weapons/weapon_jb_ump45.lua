AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "UMP"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 2
    SWEP.SlotPos = 1
    SWEP.IconLetter = "d"
    killicon.AddFont("weapon_tmp", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.HoldType = "smg"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_UMP45.Single")
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.004
SWEP.Primary.ClipSize = 25
SWEP.Primary.Delay = 0.09
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "css_45acp"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(-5.921, 0, 1.679)
SWEP.IronSightsAng = Vector(0, 0, 0)