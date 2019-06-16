

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "KM UMP45"			
	SWEP.Author				= "Fonix"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetterCSS		= "q"
	
	killicon.AddFont( "ptp_cs_ump45", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "smg"
SWEP.Base				= "ptp_weapon_base"
SWEP.Category			= "Counter-Strike: PTP"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45_fm.mdl"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 60

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_ump45.Single" )
SWEP.Primary.Recoil			= 2.3
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025	
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 500
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(-8.745, -8.629, 4.123)
SWEP.IronSightsAng = Vector(-1.265, -0.327, -2.704)
SWEP.AimSightsPos = Vector(-8.745, -8.629, 4.123)
SWEP.AimSightsAng = Vector(-1.265, -0.327, -2.704)
SWEP.DashArmPos = Vector(2.055, -4.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 37.062, -10.664)

--Extras
SWEP.ReloadHolster			= 3.4
SWEP.ZoomFOV				= 80
SWEP.StockIronSightAnim		= false

-- Accuracy
SWEP.CrouchCone				= 0.02 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.022 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.025 -- Accuracy when we're standing still
SWEP.Recoil					= 2.3
SWEP.RecoilZoom				= 0.7
SWEP.Delay					= 0.1
SWEP.DelayZoom				= 0.1
SWEP.IronSightsCone			= 0.015