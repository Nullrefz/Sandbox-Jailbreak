AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "Empty"
    SWEP.Author = "Nullrefz"
    SWEP.Slot = 0
    SWEP.SlotPos = 0
    SWEP.IconLetter = "L"
    SWEP.ViewModelFlip = false
    killicon.AddFont("weapon_empty", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 0
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = 100
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "normal"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = "models/weapons/c_arms.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}
SWEP.CanDrop = false

function SWEP:ShouldDropOnDie()
    return false
end
