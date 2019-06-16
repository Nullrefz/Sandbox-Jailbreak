if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Shotteh"			
	SWEP.Author				= "Fonix"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= ""
	SWEP.IconLetterCSS		= ""
	
	killicon.AddFont( "weapon_cs_ak47", "TextKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	surface.CreateFont("TextKillIcons", { font="Roboto-Medium", weight="500", size=ScreenScale(13),antialiasing=true,additive=true })
	surface.CreateFont("TextSelectIcons", { font="Roboto-Medium", weight="500", size=ScreenScale(20),antialiasing=true,additive=true })
	surface.CreateFont("CSKillIcons", { font="csd", weight="500", size=ScreenScale(30),antialiasing=true,additive=true })
	surface.CreateFont("CSSelectIcons", { font="csd", weight="500", size=ScreenScale(60),antialiasing=true,additive=true })
end


SWEP.HoldType			= "shotgun"
SWEP.Base				= "ptp_weapon_base"
SWEP.Category			= "PTP: Heavy"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_shot_war_md.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_war_md.mdl"
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 70

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.Primary.Sound			= Sound( "sound_fire.single" )
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 10
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 64
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( 2.03, -5, 0.7 )
SWEP.IronSightsAng 		= Vector( 0, 0, 0 )

--Extras
SWEP.MuzzleEffect			= "lee_muzzle_rifle"
SWEP.MuzzleAttachment			= "1"
SWEP.MuzzleAttachmentTrue		= true
SWEP.TracerShot				= 3
SWEP.BulletForce			= 10
SWEP.Silenceable			= false
SWEP.SilenceTiming			= 2
SWEP.ZoomFOV				= 65
SWEP.CSSZoom				= false
SWEP.ShellTime			= 0.5
SWEP.StockIronSightAnim		= true -- This is used for multiplayer, check out the ak. Do we want to use the animation or the scripted animation?

-- Accuracy
SWEP.Delay				= 0.4	-- Delay For Not Zoom
SWEP.Recoil				= 4	-- Recoil For not Aimed
SWEP.RecoilZoom				= 0.3	-- Recoil For Zoom

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()	

	local DisableDashing = false
	
		if GetConVar("sv_ptp_dashing_disable") == nil then
		DisableDashing = false
		else
		DisableDashing = GetConVar("sv_ptp_dashing_disable"):GetBool()
		end
		
	if self.Owner:KeyPressed(IN_ATTACK) and self.Owner:KeyDown(IN_RELOAD) then return end 
	
	if self.Owner:KeyDown(IN_SPEED) and not DisableDashing then return end

	

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if ( !self:CanPrimaryAttack() ) then return end
	// If Swep Data is Silenced Play Silenced else Unsilenced
	if self.Weapon:GetNetworkedBool("Silenced") == true then
		self.Weapon:EmitSound( self.SilencedSound )
		self:CSShootBullet( self.Primary.Damage * 0.8, self.Recoil * 0.75, self.Primary.NumShots, self.Primary.Cone, self.MuzzleEffect )
	end
	if self.Weapon:GetNetworkedBool("pap") == true then
		self.Weapon:EmitSound( self.PackAPunchSound )
		self:CSShootBullet( self.Primary.Damage * 2, self.Recoil * 0.4, self.Primary.NumShots, self.Primary.Cone, "lee_muzzle_rifle_pap" )
	end	
	if ((self.Weapon:GetNetworkedBool("pap") ==  false) and (self.Weapon:GetNetworkedBool("Silenced") == false)) then
		self.Weapon:EmitSound( self.Primary.Sound ) 
		self:CSShootBullet( self.Primary.Damage , self.Recoil , self.Primary.NumShots, self.Primary.Cone, self.MuzzleEffect )
	end
	//If Swep Data is Silenced Play Silenced else Unsilenced
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( self.TakeAmmoOnShot )
	
	if ( self.Owner:IsNPC() ) then return end
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil * 10, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	
	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (game.SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end
/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	if ( self.Weapon:Clip1() < 1) and self.Owner:KeyPressed(IN_ATTACK) or ( self.Weapon:Clip1() == self.Primary.ClipSize )then return end
		self:SetIronsights(false)
	//Set the ironsight mode to false
		
		
		self.Owner:SetFOV(0, 0.15)
		self.Primary.Recoil = self:GetNWInt("recoil")
	
	// Already reloading
	self.Weapon:SetVar( "reloadtimer",0 )
	

	
	// Start reloading if we can
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetNetworkedBool("Ironsights", false)
		self.Weapon:SetNetworkedFloat( "reloadtimer", CurTime() + self.ShellTime + 0.3 )
		
	end
end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()

	self:FlipTheViewModel()

	self:ShottyReload()

	self:DashingPos() //Dont to be confused with doshing 
	
	--Recoil on Zoom/UnZoomed
	if self.Weapon:GetNetworkedBool( "Ironsights" ) then
		self.Primary.Recoil = self:GetNWInt("recoilzoom")
	else
		self.Primary.Recoil = self:GetNWInt("recoil")
	end
	
	local DisableDashing = false		//Garanties on disable that ironsights stay the aimsights
	
		if GetConVar("sv_ptp_dashing_disable") == nil then
		DisableDashing = false
		else
		DisableDashing = GetConVar("sv_ptp_dashing_disable"):GetBool()
		end
	
	if DisableDashing then 
	self.IronSightsPos = self.AimSightsPos
	self.IronSightsAng = self.AimSightsAng
	end
	
	if self.Owner:KeyPressed(IN_SPEED) or self.Owner:KeyPressed(IN_JUMP) and not self.Owner:KeyDown(IN_SPEED) then
	self.Weapon:SetNetworkedBool("Ironsights", false)
	self.Owner:SetFOV(0, 0.15)
	self.Primary.Recoil = self:GetNWInt("recoil")
	end
end

/*---------------------------------------------------------
Shotty Reload
---------------------------------------------------------*/
function SWEP:ShottyReload()

		
		if self.Owner:KeyPressed(IN_ATTACK) then 
			self.Weapon:SetNetworkedBool( "reloading", false )
		end
	
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
	
		if ( self.Weapon:GetNetworkedFloat( "reloadtimer" ) < CurTime()) then
			
			// Finsished reload 
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNetworkedBool( "reloading", false )
				return
			end
			
			self.Weapon:SetNetworkedFloat( "reloadtimer", CurTime() + self.ShellTime )
			if not ( self.Weapon:Clip1() == self.Primary.ClipSize) then 
			
			vm = self.Owner:GetViewModel()-- its a messy way to do it, but holy shit, it works!
			vm:ResetSequence(vm:LookupSequence("after_reload")) -- Fuck you, garry, why the hell can't I reset a sequence in multiplayer?
			vm:SetPlaybackRate(.01)
			
				timer.Simple(0.01, function ()
					self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
				end)
			end
			
			// Add ammo
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			// Finish filling, final pump. Current Clip is = to ClipSize or No more ammo in the reserve
			if ( self.Weapon:Clip1() == self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0) then
				self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
				timer.Simple( 0.5, function() 
					if self.Weapon == nil then return end
					self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
					self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
						timer.Simple( 1, function() 
							if self.Weapon == nil then return end
							self.Weapon:SetNetworkedBool( "reloading", false )
						end)
			end ) 
			
		end
	end
end
end
/*---------------------------------------------------------
DashingPos
---------------------------------------------------------*/
function SWEP:DashingPos()

		
	if self.Weapon:GetNetworkedBool("reloading", true) then return end
		
		local DisableDashing = false
	
		if GetConVar("sv_ptp_dashing_disable") == nil then
		DisableDashing = false
		else
		DisableDashing = GetConVar("sv_ptp_dashing_disable"):GetBool()
		end
	
	if DisableDashing then return end
	
		if self.Owner:KeyDown(IN_SPEED) then 
			self.IronSightsPos	= self.DashArmPos
			self.IronSightsAng	= self.DashArmAng
			self.Weapon:SetNetworkedBool("Ironsights", true)
			self.SwayScale 	= 1.0
			self.BobScale 	= 2.0
			if not (self.Pistol) then
			self:SetWeaponHoldType("passive") 
			else
			self:SetWeaponHoldType("normal")
			end 
		end
		
		if self.Owner:KeyReleased(IN_SPEED) then
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
			self.Weapon:SetNetworkedBool("Ironsights", false)
			self:SetWeaponHoldType( self.HoldType )
		end
		
		if self.Owner:KeyDown(IN_SPEED) then return end
		
		if self.Owner:KeyPressed(IN_ATTACK2) then
		self.IronSightsPos = self.AimSightsPos
		self.IronSightsAng = self.AimSightsAng
		end
end

local IRONSIGHT_TIME = 0.15
/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if (bIron != self.bLastIron) then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if (bIron) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.01
		else 
			self.SwayScale 	= ptp_viewmodel_sway:GetInt()
			self.BobScale 	= ptp_viewmodel_bob:GetInt()
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if (!bIron && fIronTime < CurTime() - IRONSIGHT_TIME) then 
		return pos, ang
	end
	
	local Mul = 1.0
	
	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if (!bIron) then Mul = 1 - Mul end
	end

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 	self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 	self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	pos = pos + self.IronSightsPos.x * Right * Mul
	pos = pos + self.IronSightsPos.y * Forward * Mul
	pos = pos + self.IronSightsPos.z * Up * Mul
	
	return pos, ang
end