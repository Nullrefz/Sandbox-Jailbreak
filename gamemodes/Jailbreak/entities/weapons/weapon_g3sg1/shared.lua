if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName 		= "D3/AU-1"
	SWEP.ViewModelFOV		= 65
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetterCSS		= "i"

	killicon.AddFont("ptp_cs_g3sg1", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
end

SWEP.Category			= "Counter-Strike: PTP"

SWEP.Base 				= "ptp_scoped_base"

SWEP.HoldType 		= "ar2"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/cstrike/c_snip_g3sg1.mdl"
SWEP.WorldModel 			= "models/weapons/w_snip_g3sg1_fm.mdl"
SWEP.UseHands			= true

SWEP.Primary.Sound 		= Sound("Weapon_G3SG1.Single")
SWEP.Primary.Damage 		= 45
SWEP.Primary.Recoil 		= 2
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.001
SWEP.Primary.ClipSize 		= 20
SWEP.Primary.Delay 		= 0.2
SWEP.Primary.DefaultClip 	= 110
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.Secondary.Automatic	= true

SWEP.IronSightsPos = Vector(-6.197, -10.495, 1.847)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.AimSightsPos = Vector(-6.197, -10.495, 1.847)
SWEP.AimSightsAng = Vector(0, 0, 0)
SWEP.DashArmPos = Vector(4.355, -7.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 47.062, -10.664)

--Extras
SWEP.ReloadHolster			= 4.7
-- Weapon Variations
SWEP.UseScope				= true -- Use a scope instead of iron sights.
SWEP.ScopeScale 			= 0.55 -- The scale of the scope's reticle in relation to the player's screen size.
SWEP.ScopeZoom				= 3
--Only Select one... Only one.
SWEP.ScopeReddot		= false
SWEP.ScopeNormal		= true
SWEP.ScopeMs			= false
SWEP.BoltAction			= false --Self Explanatory
-- Accuracy
SWEP.CrouchCone				= 0.001 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.005 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.001 -- Accuracy when we're standing still