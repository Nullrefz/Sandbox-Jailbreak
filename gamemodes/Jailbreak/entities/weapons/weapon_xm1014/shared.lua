if CLIENT then
	killicon.AddFont( "weapon_cs_xm1014", "csd", "B", Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/gfx/vgui/xm1014")
end

SWEP.Category				= "Counter-Strike"
SWEP.PrintName				= "XM1014"
SWEP.Base					= "weapon_cs_base"
SWEP.WeaponType				= "Primary"

SWEP.Cost					= 3000
SWEP.CSSMoveSpeed				= 240

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 2
SWEP.SlotPos				= 1

SWEP.ViewModel 				= "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel				= "models/weapons/w_shot_xm1014.mdl"
SWEP.VModelFlip 			= false
SWEP.HoldType				= "ar2"

SWEP.Primary.Damage			= 22 * 0.8
SWEP.Primary.NumShots		= 6
SWEP.Primary.Sound			= Sound("Weapon_XM1014.Single")
SWEP.Primary.Cone			= 0.0325
SWEP.Primary.ClipSize		= 7
SWEP.Primary.SpareClip		= 32
SWEP.Primary.Delay			= 0.25 --1/(240/60)
SWEP.Primary.Ammo			= "css_12gauge"
SWEP.Primary.Automatic 		= false

SWEP.RecoilMul				= 1
SWEP.SideRecoilMul			= 0.25
SWEP.VelConeMul				= 1
SWEP.HeatMul				= 1
SWEP.CoolMul				= 1

SWEP.HasScope 				= false
SWEP.ZoomAmount 			= 0.25
SWEP.HasCrosshair 			= true
SWEP.HasCSSZoom 			= false

SWEP.HasPumpAction 			= true
SWEP.HasBoltAction 			= false
SWEP.HasBurstFire 			= false
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= true
SWEP.HasDownRecoil			= false

SWEP.HasIronSights 			= true
SWEP.EnableIronCross		= true
SWEP.HasGoodSights			= true
SWEP.IronSightTime			= 0.125
SWEP.IronSightsPos 			= Vector(-6, 0, 1.5)
SWEP.IronSightsAng 			= Vector(0, -1, 0)

SWEP.DamageFalloff			= 200

SWEP.PenetrationLossScale	= 0.5