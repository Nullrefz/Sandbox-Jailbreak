if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "Schmidt Scout"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetterCSS	= "n"

	killicon.AddFont("ptp_cs_scout", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ))
end

SWEP.Category			= "Counter-Strike: PTP"

SWEP.Base				= "ptp_scoped_base"

SWEP.HoldType 		= "ar2"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 				= "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel 			= "models/weapons/w_snip_scout_fm.mdl"
SWEP.ViewModelFOV			= 60
SWEP.UseHands				= true
SWEP.ViewModelFlip			= false

SWEP.Primary.Sound 		= Sound("Weapon_SCOUT.Single")
SWEP.Primary.Damage 		= 45
SWEP.Primary.Recoil 		= 5
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0001
SWEP.Primary.ClipSize 		= 10
SWEP.Primary.Delay 		= 1.2
SWEP.Primary.DefaultClip 	= 90
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "smg1"

SWEP.Secondary.Automatic	= true
SWEP.IronSightsPos = Vector(-6.231, -14.127, 3.301)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.AimSightsPos = Vector(-6.231, -14.127, 3.301)
SWEP.AimSightsAng = Vector(0, 0, 0)
SWEP.DashArmPos = Vector(4.355, -7.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 43.062, -10.664)

--Extras
SWEP.ReloadHolster			= 2.8
SWEP.TracerShot				= 0
-- Weapon Variations
SWEP.UseScope				= true -- Use a scope instead of iron sights.
SWEP.ScopeScale 			= 0.55 -- The scale of the scope's reticle in relation to the player's screen size.
SWEP.ScopeZoom				= 8
--Only Select one... Only one.
SWEP.ScopeReddot		= false
SWEP.ScopeNormal		= true
SWEP.ScopeMs			= false
SWEP.BoltAction			= true --Self Explanatory
-- Accuracy
SWEP.CrouchCone				= 0.001 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.005 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.001 -- Accuracy when we're standing still