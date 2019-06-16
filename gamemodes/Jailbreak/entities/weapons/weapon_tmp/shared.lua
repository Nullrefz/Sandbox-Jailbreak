

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then

	SWEP.PrintName			= "Schmidt Machine Pistol"			
	SWEP.Author				= "Counter-Strike: ADV"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.IconLetterCSS		= "d"
	
	killicon.AddFont( "ptp_cs_tmp", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "ptp_zoom_base"
SWEP.Category			= "Counter-Strike: PTP"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_smg_tmp.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_tmp_fm.mdl"
SWEP.ViewModelFOV		= 60
SWEP.UseHands			= true
SWEP.ViewModelFlip		= false

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_tmp.Single" )
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.075
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.IronSightsPos = Vector(-6.185, -7.106, 0.885)
SWEP.IronSightsAng = Vector(0.601, -5.383, -8.29)
SWEP.AimSightsPos = Vector(-6.185, -7.106, 0.885)
SWEP.AimSightsAng = Vector(0.601, -5.383, -8.29)
SWEP.DashArmPos = Vector(4.355, -7.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 40.062, -10.664)

--Extras
SWEP.ReloadHolster			= 2
SWEP.StockIronSightAnim		= true

-- Accuracy
SWEP.CrouchCone				= 0.025 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.03 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.04 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.04 -- Accuracy when we're standing still
SWEP.Delay				= 0.075
SWEP.Recoil				= 2.5
SWEP.RecoilZoom			= 0.7
SWEP.IronSightsCone		= 0.02
