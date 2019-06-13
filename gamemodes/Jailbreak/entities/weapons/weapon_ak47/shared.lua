if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "CV-47"			
	SWEP.Author				= "Fonix"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetterCSS		= "b"
	
	killicon.AddFont( "ptp_cs_ak47", "CSKillIcons", SWEP.IconLetterCSS, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType			= "ar2"
SWEP.Base				= "ptp_weapon_base"
SWEP.Category			= "Counter-Strike: PTP"
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 60

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47_fm.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.Primary.Sound			= Sound( "weapon_ak47.single" )
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 34
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(-6.614, -11.551, 2.648)
SWEP.IronSightsAng = Vector(2.275, 0, 0)
SWEP.AimSightsPos = Vector(-6.614, -11.551, 2.648)
SWEP.AimSightsAng = Vector(2.275, 0, 0)
SWEP.DashArmPos = Vector(4.355, -7.206, -0.681)
SWEP.DashArmAng = Vector(-10.965, 37.062, -10.664)


--Extras
SWEP.ReloadHolster		= 2.4
SWEP.StockIronSightAnim		= false

-- Accuracy
SWEP.CrouchCone				= 0.01 -- Accuracy when we're crouching
SWEP.CrouchWalkCone			= 0.02 -- Accuracy when we're crouching and walking
SWEP.WalkCone				= 0.025 -- Accuracy when we're walking
SWEP.AirCone				= 0.1 -- Accuracy when we're in air
SWEP.StandCone				= 0.015 -- Accuracy when we're standing still
SWEP.Delay					= 0.1
SWEP.Recoil					= 3
SWEP.RecoilZoom				= 1
SWEP.IronSightsCone			= 0.01

/*---------------------------------------------------------
SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights(b)

	
	if self.Owner:KeyDown(IN_USE) then return end
	
	if self.Owner:KeyDown(IN_SPEED) then return end
	
	if !self.Owner:OnGround() then return end
	
	self.Weapon:SetNetworkedBool("Ironsights", b)
	
		if self.Weapon:GetNetworkedBool( "Ironsights", true) then
			--self.Primary.Recoil = self.RecoilZoom
			self.IronSightsPos = self.AimSightsPos
			self.IronSightsAng = self.AimSightsAng
			self.Weapon:EmitSound("weapons/universal/iron_in.wav")
			self.Owner:SetFOV(self.ZoomFOV, 0.15)
				if self.CSSZoom then
					self.Primary.Recoil = self.RecoilZoom
					self.Primary.Delay  = self.DelayZoom
				end
		else
				self.Primary.Recoil = self.Recoil
				self.Owner:SetFOV(0, 0.15)
				if self.CSSZoom then
						self.Primary.Recoil = self.Recoil
						self.Primary.Delay  = self.Delay
				end
				self.Weapon:EmitSound("weapons/universal/iron_out.wav")
		end
		
end
