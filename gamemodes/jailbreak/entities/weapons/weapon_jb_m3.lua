AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "Pump Shotgun"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 2
    SWEP.SlotPos = 3
    SWEP.IconLetter = "k"
end

SWEP.HoldType = "ar2"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.Recoil = 5
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 8
SWEP.Primary.Cone = 0.1
SWEP.Primary.ClipSize = 8
SWEP.Primary.Delay = 0.95
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(5.7, -3, 3)
SWEP.TargetFOV = 70
--[[---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------]]
function SWEP:Reload()
    --if ( CLIENT ) then return end
    self:SetIronsights(false)
    -- Already reloading
    if (self.Weapon:GetNWBool("reloading", false)) then return end

    -- Start reloading if we can
    if (self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
        self.Weapon:SetNWBool("reloading", true)
        self.Weapon:SetVar("reloadtimer", CurTime() + 0.3)
        self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
        self.Owner:DoReloadEvent()
    end
end

--[[---------------------------------------------------------
   Think does nothing
---------------------------------------------------------]]
function SWEP:Think()
    if not self:GetNWBool("reloading", false) then return end

    if (self:GetVar("reloadtimer", 0) < CurTime()) then
        -- Finsished reload -
        if (self:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
            self:SetNWBool("reloading", false)

            return
        end

        -- Next cycle
        self:SetVar("reloadtimer", CurTime() + 0.3)
        self:SendWeaponAnim(ACT_VM_RELOAD)
        self.Owner:DoReloadEvent()
        -- Add ammo
        self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
        self:SetClip1(self:Clip1() + 1)

        -- Finish filling, final pump
        if (self:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
            self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
            self.Owner:DoReloadEvent()
        end
    end
end