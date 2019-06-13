if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Magnum Sniper Rifle"
	SWEP.ViewModelFOV		= 75
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetterCSS 		= "r"

	killicon.AddFont("ptp_cs_awp", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ))
end

/*-------------------------------------------------------*/


SWEP.Category			= "Counter-Strike: PTP"

SWEP.Base				= "ptp_scoped_base"

SWEP.HoldType 		= "ar2"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel 			= "models/weapons/w_snip_awp_fm.mdl"
SWEP.UseHands			= true
SWEP.ViewModelFOV		= 65
SWEP.Primary.Sound 		= Sound("Weapon_awp.Single")
SWEP.Primary.Damage 		= 95
SWEP.Primary.Recoil 		= 6
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0001
SWEP.Primary.ClipSize 		= 10
SWEP.Primary.Delay 		= 1.2
SWEP.Primary.DefaultClip 	= 40
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "smg1"

SWEP.Secondary.Automatic	= true

SWEP.IronSightsPos = Vector(-7.436, -5.051, 2.233)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.AimSightsPos = Vector(-7.436, -5.051, 2.233)
SWEP.AimSightsAng = Vector(0, 0, 0)
SWEP.DashArmPos = Vector(4.355, -7.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 47.062, -10.664)

--Extras
SWEP.ReloadHolster			= 3.5
SWEP.TracerShot				= 0
-- Weapon Variations
SWEP.UseScope				= true -- Use a scope instead of iron sights.
SWEP.ScopeScale 			= 0.55 -- The scale of the scope's reticle in relation to the player's screen size.
SWEP.ScopeZoom				= 4
--Only Select one... Only one.
SWEP.ScopeReddot		= false
SWEP.ScopeNormal		= true
SWEP.ScopeMs			= false
SWEP.BoltAction			= true --Self Explanatory
-- Accuracy
SWEP.CrouchCone				= 0.0001 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.2 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.2 -- Accuracy when we're walking
SWEP.AirCone				= 0.5 -- Accuracy when we're in air
SWEP.StandCone				= 0.0001 -- Accuracy when we're standing still