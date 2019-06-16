if (SERVER) then
  
	AddCSLuaFile ("shared.lua")
	SWEP.Weight 			= 5
	SWEP.AutoSwitchTo 		= false
	SWEP.AutoSwitchFrom 		= false
end

if (CLIENT) then

	SWEP.PrintName 			= "Grenade"
	SWEP.Slot 				= 4
	SWEP.SlotPos 			= 1
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV			= 80
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes		= false

	SWEP.IconLetter 			= "O"
	killicon.AddFont("ent_explosivegrenade", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.Category			= "Counter-Strike: PTP"

SWEP.HoldType				= "grenade"


SWEP.Spawnable 				= true
SWEP.AdminSpawnable 			= true
SWEP.UseHands				= true

SWEP.ViewModel 				= "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel 				= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.ViewModelFlip 				= false
SWEP.ViewModelFOV				= 60
SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 10
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 			= "grenade"

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= -1
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= "none"

SWEP.Primed 				= 0
SWEP.Throw 					= CurTime()
SWEP.PrimaryThrow				= true

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()
	self.Primed = 0
	self.Throw = CurTime()
	self.Owner:DrawViewModel(true)
	return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Reload()
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) and self.PrimaryThrow then
		if self.Throw < CurTime() then
			self.Primed = 2
			self.Throw = CurTime() + 1.5

			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple( 0.35, function()
				if (!self or !IsValid(self)) then return end
				self:ThrowFar()
			end)
		end

	elseif self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK2) and not self.PrimaryThrow then
		if self.Throw < CurTime() then
			self.Primed = 2
			self.Throw = CurTime() + 1.5

			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple( 0.35, function()
				if (!self or !IsValid(self)) then return end
				self:ThrowShort()
			end)
		end
	end
end

/*---------------------------------------------------------
ThrowFar
---------------------------------------------------------*/
function SWEP:ThrowFar()

	
	if self.Primed != 2 then return end

	local tr = self.Owner:GetEyeTrace()

	if (!SERVER) then return end

	local ent = ents.Create ("ent_explosivegrenade")

			local v = self.Owner:GetShootPos()
				v = v + self.Owner:GetForward() * 20
				v = v + self.Owner:GetRight() * 10
				v = v + self.Owner:GetUp() * 10
			ent:SetPos( v )

	ent:SetAngles(Angle(math.random(1,100),math.random(1,100),math.random(1,100)))
	ent.GrenadeOwner = self.Owner
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if !IsValid(phys) then self.Weapon:SendWeaponAnim(ACT_VM_DRAW) self.Primed = 0 return end

	if self.Owner:KeyDown( IN_FORWARD ) then
		self.Force = 2000
	elseif self.Owner:KeyDown( IN_BACK ) then
		self.Force = 2000
	elseif self.Owner:KeyDown( IN_MOVELEFT ) then
		self.Force = 2000
	elseif self.Owner:KeyDown( IN_MOVERIGHT ) then
		self.Force = 2000
	else
		self.Force = 2000
	end

	phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 2 + Vector(0, 0, 0))
	phys:AddAngleVelocity(Vector(math.random(-500,500),math.random(-500,500),math.random(-500,500)))

	self:TakePrimaryAmmo(1)
	-- self:Reload()

	timer.Simple(0.6,
	function()

			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Primed = 0
		--	self.Weapon:Remove()
		--	self.Owner:ConCommand("lastinv")
	end)
end

/*---------------------------------------------------------
ThrowShort
---------------------------------------------------------*/
function SWEP:ThrowShort()

	if self.Primed != 2 then return end

	local tr = self.Owner:GetEyeTrace()

	if (!SERVER) then return end

	local ent = ents.Create ("ent_explosivegrenade")

			local v = self.Owner:GetShootPos()
				v = v + self.Owner:GetForward() * 2
				v = v + self.Owner:GetRight() * 3
				v = v + self.Owner:GetUp() * -3
			ent:SetPos( v )

	ent:SetAngles(Angle(math.random(1,100),math.random(1,100),math.random(1,100)))
	ent.GrenadeOwner = self.Owner
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if !IsValid(phys) then self.Weapon:SendWeaponAnim(ACT_VM_DRAW) self.Primed = 0 return end

	if self.Owner:KeyDown( IN_FORWARD ) then
		self.Force = 500
	elseif self.Owner:KeyDown( IN_BACK ) then
		self.Force = 500
	elseif self.Owner:KeyDown( IN_MOVELEFT ) then
		self.Force = 500
	elseif self.Owner:KeyDown( IN_MOVERIGHT ) then
		self.Force = 500
	else
		self.Force = 500
	end

	phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 2 + Vector(0, 0, 0))
	phys:AddAngleVelocity(Vector(math.random(-500,500),math.random(-500,500),math.random(-500,500)))

	self:TakePrimaryAmmo(1)
	-- self:Reload()

	timer.Simple(0.6,
	function()

			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Primed = 0
		--	self.Weapon:Remove()
		--	self.Owner:ConCommand("lastinv")
	end)
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if (self.Owner:GetAmmoCount( "grenade" ) == 0) then return end
	if self.Throw < CurTime() and self.Primed == 0 then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Primed = 1
		self.Throw = CurTime() + 1
		self.PrimaryThrow = true
	end
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if (self.Owner:GetAmmoCount( "grenade" ) == 0) then return end
	if self.Throw < CurTime() and self.Primed == 0 then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Primed = 1
		self.Throw = CurTime() + 1
		self.PrimaryThrow = false
	end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()

		self.Throw = CurTime() + 0.75
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		self.Owner:DrawViewModel(true)

	-- return true
end

/*---------------------------------------------------------
DrawWeaponSelection
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)

	draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)
	-- Draw a CS:S select icon
end

/*---------------------------------------------------------
	Draw a CrossHair! 
---------------------------------------------------------*/

//Ripped from LeErOy NeWmAn, Don't tell him shhh

SWEP.CrosshairScale = 1
function SWEP:DrawHUD()
	
	local Hl2CrossHair = true
	
		if GetConVar("cl_ptp_hl2crosshair_enable") == nil then
		Hl2CrossHair = true
		else
		Hl2CrossHair = GetConVar("cl_ptp_hl2crosshair_enable"):GetBool()
		end

	if not(Hl2CrossHair) then
	
	self.DrawCrosshair = false
	// Make Sure this shit goes away
	
	local DisableDashing = false
	
		if GetConVar("sv_ptp_dashing_disable") == nil then
		DisableDashing = false
		else
		DisableDashing = GetConVar("sv_ptp_dashing_disable"):GetBool()
		end 
	
	local DrawCrossHair = false
	
	if GetConVar("cl_ptp_crosshair_disable") == nil then
		DrawCrossHair = false
	else
		DrawCrossHair = GetConVar("cl_ptp_crosshair_disable"):GetBool()
	end
	
	if DrawCrossHair then return end
	
	//Remove on IronSights
	
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = (ScrW() / 1024) * 5

	local scale = 2
	local canscale = true


scale = scalebywidth * 0.01

	surface.SetDrawColor(8, 255, 0, 255)

local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))

	local dist = math.abs(self.CrosshairScale - scale)
	self.CrosshairScale = math.Approach(self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05)

	local gap = 30 * self.CrosshairScale
	local length = gap + 25 * self.CrosshairScale
	surface.DrawLine(x - length, y, x - gap, y)
	surface.DrawLine(x + length, y, x + gap, y)
	surface.DrawLine(x, y - length, x, y - gap)
	surface.DrawLine(x, y + length, x, y + gap)

	//surface.DrawLine(x-2, y, x+2, y)
	//surface.DrawLine(x, y-2, x, y+2)
	else
	
	if self.Weapon:GetNetworkedBool( "Ironsights" , true) then 
		self.DrawCrosshair = false
		else
		self.DrawCrosshair = true
	end
	end
end