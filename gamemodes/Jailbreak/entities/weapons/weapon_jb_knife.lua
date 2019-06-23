AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "Knife"
    SWEP.Author = "Counter-Strike"
    SWEP.Slot = 0
    SWEP.SlotPos = 3
    SWEP.IconLetter = "j"
    killicon.AddFont("weapon_knife", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))
end

SWEP.HoldType = "melee"
SWEP.Base = "weapon_jb_base"
SWEP.Category = "Counter-Strike"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("weapons/knife/knife_slash1.wav")
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 25
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = 0.01
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronSightsPos = Vector(6.25, -4, 0.0)
SWEP.IronSightsAng = Vector(6, 2, 6)
SWEP.DrawCrosshair = false
SWEP.HitDistance = 50
SWEP.MissSound = Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound = Sound("weapons/knife/knife_hitwall1.wav")
SWEP.DeploySound = Sound("weapons/knife/knife_deploy1.wav")

--[[---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 50)
    tr.filter = self.Owner
    tr.mask = MASK_SHOT
    local trace = util.TraceLine(tr)
    self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
    self.Weapon:SetNextSecondaryFire(CurTime() + 0.7)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    if (trace.Hit) then
        if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(), "npc") or string.find(trace.Entity:GetClass(), "prop_ragdoll") then
            self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
            bullet = {}
            bullet.Num = 1
            bullet.Src = self.Owner:GetShootPos()
            bullet.Dir = self.Owner:GetAimVector()
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force = 1
            bullet.Damage = 50
            self.Owner:FireBullets(bullet)
            self.Weapon:EmitSound("weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav")
        else
            self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
            bullet = {}
            bullet.Num = 1
            bullet.Src = self.Owner:GetShootPos()
            bullet.Dir = self.Owner:GetAimVector()
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force = 1
            bullet.Damage = 50
            self.Owner:FireBullets(bullet)
            self.Weapon:EmitSound(self.WallSound)
            util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
        end
    else
        self.Weapon:EmitSound(self.MissSound, 100, math.random(90, 120))
        self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
    end
end

--[[---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------]]
function SWEP:SecondaryAttack()
    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 50)
    tr.filter = self.Owner
    tr.mask = MASK_SHOT
    local trace = util.TraceLine(tr)
    self.Weapon:SetNextPrimaryFire(CurTime() + 1)
    self.Weapon:SetNextSecondaryFire(CurTime() + 1)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    if (trace.Hit) then
        if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(), "npc") or string.find(trace.Entity:GetClass(), "prop_ragdoll") then
            self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
            bullet = {}
            bullet.Num = 1
            bullet.Src = self.Owner:GetShootPos()
            bullet.Dir = self.Owner:GetAimVector()
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force = 1
            bullet.Damage = 100
            self.Owner:FireBullets(bullet)
            self.Weapon:EmitSound("weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav")
        else
            self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
            bullet = {}
            bullet.Num = 1
            bullet.Src = self.Owner:GetShootPos()
            bullet.Dir = self.Owner:GetAimVector()
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force = 1
            bullet.Damage = 50
            self.Owner:FireBullets(bullet)
            self.Weapon:EmitSound(self.WallSound)
            util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
        end
    else
        self.Weapon:EmitSound(self.MissSound, 100, math.random(90, 120))
        self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
    end
end

--[[---------------------------------------------------------
Reload
---------------------------------------------------------]]
function SWEP:Reload()
    return false
end