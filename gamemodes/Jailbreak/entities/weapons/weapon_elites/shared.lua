

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= ".40 Dual Elites"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 5
	SWEP.IconLetterCSS		= "s"
	
	killicon.AddFont( "ptp_cs_elites", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "duel"
SWEP.Base				= "ptp_zoom_base"
SWEP.Category			= "Counter-Strike: PTP"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_elite_fm.mdl"
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 60

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_elite.Single" )
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.AimSightsPos = Vector(0, 0, 0)
SWEP.AimSightsAng = Vector(0, 0, 0)
SWEP.DashArmPos = Vector(0, 0, 0)
SWEP.DashArmAng = Vector(-10, 0, 0)

--Extras
SWEP.ReloadHolster			= 3.6
SWEP.StockIronSightAnim		= true

-- Accuracy
SWEP.CrouchCone				= 0.02 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.025 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.03 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.02 -- Accuracy when we're standing still
SWEP.Recoil 				= 2.5
SWEP.RecoilZoom				= 0.8
SWEP.Delay					= 0.08