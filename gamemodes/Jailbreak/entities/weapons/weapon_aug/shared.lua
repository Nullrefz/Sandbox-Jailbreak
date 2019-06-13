if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Bullpup"			
	SWEP.Author				= "Fonix"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetterCSS		= "e"
	
	killicon.AddFont( "ptp_cs_aug", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "smg"
SWEP.Base				= "ptp_zoom_base"
SWEP.Category			= "Counter-Strike: PTP"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_aug_fm.mdl"
SWEP.ViewModelFOV		= 58
SWEP.ViewModelFlip		= false
SWEP.UseHands			= true

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "weapon_aug.Single" )
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.09
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.Automatic	= true

SWEP.IronSightsPos 		= Vector( 0, 0, 0 )
SWEP.IronSightsAng 		= Vector( 0, 0, 0 )
SWEP.AimSightsPos 		= Vector( 0, 0, 0 )
SWEP.AimSightsAng 		= Vector( 0, 0, 0 )
SWEP.DashArmPos = Vector(4.355, -7.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 47.062, -10.664)

--Extras
SWEP.ZoomFOV				= 55
SWEP.CSSZoom				= true
SWEP.ReloadHolster			= 3.7
SWEP.StockIronSightAnim		= true

-- Weapon Variations
SWEP.CrouchCone				= 0.01 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.02 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.015 -- Accuracy when we're standing still
SWEP.IronsightsCone			= 0.015
SWEP.Recoil				= 3	-- Recoil For not Aimed
SWEP.RecoilZoom				= 0.8	-- Recoil For Zoom
SWEP.Delay				= 0.09	-- Delay For Not Zoom
SWEP.DelayZoom				= 0.15	-- Delay For Zoom