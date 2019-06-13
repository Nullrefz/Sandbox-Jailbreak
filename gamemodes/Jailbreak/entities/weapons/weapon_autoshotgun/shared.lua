if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Leone YG1265 Auto Shotgun"			
	SWEP.Author				= "Fonix"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 3
	SWEP.IconLetterCSS		= "B"
	
	
	killicon.AddFont( "ptp_cs_autoshotgun", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "ptp_shotgun_base"
SWEP.Category			= "Counter-Strike: PTP"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_xm1014_fm.mdl"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 60

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_xm1014.Single" )
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 7
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.09
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.2
SWEP.Primary.DefaultClip	= 39
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.IronSightsPos = Vector(-6.96, -4.329, 2.7)
SWEP.IronSightsAng = Vector(-0.2, -0.8, 0)
SWEP.AimSightsPos = Vector(-6.96, -4.329, 2.7)
SWEP.AimSightsAng = Vector(-0.2, -0.8, 0)
SWEP.DashArmPos = Vector(4.355, -7.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 47.062, -10.664)

--Extras
SWEP.ReloadHolster			= 3
SWEP.StockIronSightAnim		= true

--Accuracy
SWEP.Delay					= 0.2
SWEP.Recoil					= 3
SWEP.RecoilZoom				= 2

