if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Clarion 5.56"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetterCSS		= "t"
	
	killicon.AddFont( "ptp_cs_famas", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "ptp_zoom_base"
SWEP.Category			= "Counter-Strike: PTP"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_famas_fm.mdl"
SWEP.UseHands			= true
SWEP.ViewModelFOV		= 65

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_famas.Single" )
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 26
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(-3.57, -6.375, 0)
SWEP.IronSightsAng = Vector(2.497, 0.05, 0.7)
SWEP.AimSightsPos = Vector(-3.57, -6.375, 0)
SWEP.AimSightsAng = Vector(2.497, 0.05, 0.7)
SWEP.DashArmPos = Vector(2.055, -4.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 37.062, -10.664)

--Extras
SWEP.ReloadHolster			= 3.3
SWEP.StockIronSightAnim		= true

--FireModes
SWEP.FiringMode			= true
SWEP.Burstable 			= true
SWEP.BurstShots 		= 3

-- Accuracy
SWEP.CrouchCone				= 0.01 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.02 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.015 -- Accuracy when we're standing still
SWEP.Delay				= 0.08
SWEP.Recoil				= 3
SWEP.RecoilZoom			= 0.7
SWEP.IronSightsCone			= 0.01

