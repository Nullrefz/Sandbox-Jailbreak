

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "KM Sub-Machine Gun"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetterCSS		= "x"
	
	killicon.AddFont( "ptp_cs_mp5", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "smg"
SWEP.Base				= "ptp_weapon_base"
SWEP.Category			= "Counter-Strike: PTP"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mp5_fm.mdl"
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 55
SWEP.UseHands 			= true

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.IronSightsPos = Vector(-5.33, -5.431, 2.1)
SWEP.IronSightsAng = Vector(0.886, 0, 0)
SWEP.AimSightsPos = Vector(-5.33, -5.431, 2.1)
SWEP.AimSightsAng = Vector(0.886, 0, 0)
SWEP.DashArmPos = Vector(4.355, -7.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 47.062, -10.664)

--Extras
SWEP.ReloadHolster			= 2.9
SWEP.StockIronSightAnim		= false


-- Accuracy
SWEP.CrouchCone				= 0.02 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.03 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.03 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.03 -- Accuracy when we're standing still
SWEP.Recoil					= 2.5
SWEP.RecoilZoom				= 0.8


