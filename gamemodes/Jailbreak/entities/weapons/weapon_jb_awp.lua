AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "AWP"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 3
    SWEP.SlotPos = 1
    SWEP.IconLetter = "r"
    killicon.AddFont("weapon_awp", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 150))
end

SWEP.HoldType = "ar2"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("Weapon_AWP.Single")
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Damage = 115
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 3
SWEP.Primary.Delay = 1.5
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

local inFocus = false

function SWEP:Think()
    if self:GetNWMode() == AIM.Focus and not inFocus then
        LerpFloat(self.CurFOV, 10, 0.5, function(val)
            self.CurFOV = val
        end, INTERPOLATION.SmoothStep)

        inFocus = true
    elseif self:GetNWMode() ~= AIM.Focus and inFocus then
        inFocus = false

        LerpFloat(self.CurFOV, self.TargetFOV, 0.5, function(val)
            self.CurFOV = val
        end, INTERPOLATION.SmoothStep)
    end
end

if CLIENT then
    function SWEP:AdjustMouseSensitivity()
        return self:GetNWMode() == AIM.Focus and .08 or 1
    end
end