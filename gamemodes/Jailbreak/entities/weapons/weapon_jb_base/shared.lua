if (SERVER) then
    AddCSLuaFile("shared.lua")
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = false
    SWEP.AutoSwitchFrom = false
end

SWEP.Author = "Nullrefz"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 40
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = 0.15
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.UseHands = true
SWEP.DrawAmmo = true
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = true
SWEP.crosshairVisible = true
SWEP.DrawCrosshair = false
SWEP.TargetFOV = 75
SWEP.CurFOV = 75

AIM = {
    Normal = 1,
    Crouch = 2,
    Focus = 3,
    Sprint = 4
}

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "NWMode")
end

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
    self:SetNWBool("Ironsights", false)
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + 1)
    self:SetNWMode(AIM.Normal)
    --self:SetReloading(false)

    return true
end

function SWEP:SetCurFOV(fov)
    self.CurFOV = fov

    --print(self.CurFOV, self.TargetFOV)
    LerpFloat(self.CurFOV, self.TargetFOV, 0.5, function(val)
        self.CurFOV = val
    end, INTERPOLATION.SmoothStep)
end

function SWEP:Holster(newWeapon)
    if not IsFirstTimePredicted() then return false end
    newWeapon:SetCurFOV(self.CurFOV)

    return true
end

function SWEP:Reload()
    self:DefaultReload(ACT_VM_RELOAD)
    self:SetNWMode(AIM.Normal)
    self.Owner:SetAnimation(PLAYER_RELOAD)
    self:SetIronsights(false)
end

function SWEP:PrimaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    if (not self:CanPrimaryAttack()) then return end
    -- Play shoot sound
    self:EmitSound(self.Primary.Sound)
    -- Shoot the bullet
    self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
    -- Remove 1 bullet from our clip
    self:TakePrimaryAmmo(1)
    if (self.Owner:IsNPC()) then return end
    -- Punch the player's view
    self.Owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))

    if ((game.SinglePlayer() and SERVER) or CLIENT) then
        self:SetNWFloat("LastShootTime", CurTime())
    end
end

function SWEP:CSShootBullet(dmg, recoil, numbul, cone)
    numbul = numbul or 1
    cone = cone or 0.01
    local bullet = {}
    bullet.Num = numbul
    bullet.Src = self.Owner:GetShootPos() -- Source
    bullet.Dir = self.Owner:GetAimVector() -- Dir of bullet
    bullet.Spread = Vector(cone, cone, 0) -- Aim Cone
    bullet.Tracer = 4 -- Show a tracer on every x bullets 
    bullet.Force = 5 -- Amount of force to give to phys objects
    bullet.Damage = dmg
    self.Owner:FireBullets(bullet)
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK) -- View model animation
    self.Owner:MuzzleFlash() -- Crappy muzzle light
    self.Owner:SetAnimation(PLAYER_ATTACK1) -- 3rd Person Animation
    if (self.Owner:IsNPC()) then return end

    -- CUSTOM RECOIL !
    if ((game.SinglePlayer() and SERVER) or (not game.SinglePlayer() and CLIENT and IsFirstTimePredicted())) then
        local eyeang = self.Owner:EyeAngles()
        eyeang.pitch = eyeang.pitch - recoil
        self.Owner:SetEyeAngles(eyeang)
    end
end

--[[---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------]]
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
    draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)
    -- try to fool them into thinking they're playing a Tony Hawks game
    draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2 + math.Rand(-4, 4), y + tall * 0.2 + math.Rand(-14, 14), Color(255, 210, 0, math.Rand(10, 120)), TEXT_ALIGN_CENTER)
    draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2 + math.Rand(-4, 4), y + tall * 0.2 + math.Rand(-9, 9), Color(255, 210, 0, math.Rand(10, 120)), TEXT_ALIGN_CENTER)
end

local IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition(pos, ang)
    if (not self.IronSightsPos) then return pos, ang end
    local bIron = self:GetNWBool("Ironsights")

    if (bIron ~= self.bLastIron) then
        self.bLastIron = bIron
        self.fIronTime = CurTime()

        if (bIron) then
            self.SwayScale = 0.3
            self.BobScale = 0.1
        else
            self.SwayScale = 1.0
            self.BobScale = 1.0
        end
    end

    local fIronTime = self.fIronTime or 0
    if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then return pos, ang end
    local Mul = 1.0

    if (fIronTime > CurTime() - IRONSIGHT_TIME) then
        Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

        if (not bIron) then
            Mul = 1 - Mul
        end
    end

    local Offset = self.IronSightsPos

    if (self.IronSightsAng) then
        ang = ang * 1
        ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
        ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
        ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
    end

    local Right = ang:Right()
    local Up = ang:Up()
    local Forward = ang:Forward()
    pos = pos + Offset.x * Right * Mul
    pos = pos + Offset.y * Forward * Mul
    pos = pos + Offset.z * Up * Mul

    return pos, ang
end

function SWEP:SetIronsights(b)
    self:SetNWBool("Ironsights", b)
end

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()
    if (self:GetNWMode() == AIM.Normal) then
        self:SetNWMode(AIM.Focus)
    else
        self:SetNWMode(AIM.Normal)
    end
end

---------------------------------------------------------]]
function SWEP:DrawHUD()
    -- No crosshair when ironsights is on
    if self:GetNWBool("Ironsights") and not self.crossairVisible then return end
    local x, y

    -- If we're drawing the local player, draw the crosshair where they're aiming,
    -- instead of in the center of the screen.
    if (self.Owner == LocalPlayer() and self.Owner:ShouldDrawLocalPlayer()) then
        local tr = util.GetPlayerTrace(self.Owner)
        --		tr.mask = ( CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX )
        local trace = util.TraceLine(tr)
        local coords = trace.HitPos:ToScreen()
        x, y = coords.x, coords.y
    else
        x, y = ScrW() / 2.0, ScrH() / 2.0
    end

    local scale = 10 * self.Primary.Cone
    -- Scale the size of the crosshair according to how long ago we fired our weapon
    local LastShootTime = self:GetNWFloat("LastShootTime", 0)
    scale = scale * (2 - math.Clamp((CurTime() - LastShootTime) * 5, 0.0, 1.0))
    if not IsValid(LocalPlayer()) then return end
    local trace = LocalPlayer():GetEyeTrace()

    if trace.Entity:GetClass() == "player" then
        local bone = trace.HitBox

        if bone == 0 then
            surface.SetDrawColor(0, 220, 255, 255)
        else
            surface.SetDrawColor(255, 255, 255, 255)
        end
    else
        surface.SetDrawColor(255, 255, 255, 50)
    end

    -- Draw an awesome crosshair
    local gap = 40 * scale
    local length = gap + 10 * scale
    surface.DrawLine(x - length, y, x - gap, y)
    surface.DrawLine(x + length, y, x + gap, y)
    surface.DrawLine(x, y - length, x, y - gap)
    surface.DrawLine(x, y + length, x, y + gap)
end

function SWEP:TranslateFOV()
    return self.CurFOV
end
-- function SWEP:ShouldDropOnDie()
--     return true
-- end
-- function SWEP:OnDrop()
--     local phys = self:GetPhysicsObject()
--     if (phys:IsValid()) then
--         phys:Wake()
--     end
-- end