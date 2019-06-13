

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "KM .45 Tactical"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 5
	SWEP.IconLetterCSS		= "a"
	
	killicon.AddFont( "ptp_cs_usp", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "pistol"
SWEP.Base				= "ptp_zoom_base"
SWEP.Category			= "Counter-Strike: PTP"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp_fm.mdl"
SWEP.ViewModelFlip		= false
SWEP.UseHands			= true
SWEP.ViewModelFOV		= 57

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_usp.Single" )
SWEP.SilencedSound			= Sound( "Weapon_usp.SilencedShot" )
SWEP.Primary.Recoil			= 2
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 12
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(-3.57, -6.375, 0)
SWEP.IronSightsAng = Vector(2.497, 0.05, 0.7)
SWEP.AimSightsPos = Vector(-3.57, -6.375, 0)
SWEP.AimSightsAng = Vector(2.497, 0.05, 0.7)
SWEP.DashArmPos = Vector(0, 0, 0)
SWEP.DashArmAng = Vector(-10, 0, 0)

--Extras
SWEP.ReloadHolster			= 2.4
SWEP.SilenceHolster			= 2.9
SWEP.StockIronSightAnim		= true

-- Accuracy
SWEP.CrouchCone				= 0.02 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.025 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.03 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.02 -- Accuracy when we're standing still
SWEP.Recoil					= 2
SWEP.Delay					= 0.08
SWEP.DelayZoom				= 0.08
SWEP.IronSightsCone			= 0.015
SWEP.Silenceable			= true
SWEP.SilenceTiming			= 2