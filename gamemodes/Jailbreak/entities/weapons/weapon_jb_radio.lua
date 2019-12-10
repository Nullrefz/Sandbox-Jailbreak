AddCSLuaFile()

if (CLIENT) then
    SWEP.PrintName = "Radio"
    SWEP.Author = "Nullrefz"
    SWEP.Slot = 0
    SWEP.SlotPos = 2
    SWEP.IconLetter = "R"
    SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_jb_base"
SWEP.Category = "Nullrefz"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 67.336683417085
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/radio/c_radio.mdl"
SWEP.WorldModel = "models/radio/w_radio.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.ViewModelBoneMods = {
    ["ValveBiped.Bip01_Spine4"] = {
        scale = Vector(1, 1, 1),
        pos = Vector(-1.297, 0, 0),
        angle = Angle(0, 0, 0)
    }
}

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Sound = Sound("buttons/combine_button1.wav")
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.CanDrop = false
function SWEP:PrimaryAttack()
    self:SendWeaponAnim(ACT_VM_HOLSTER)
    self:EmitSound(self.Primary.Sound)

    timer.Simple(0.8, function()
        if IsValid(self) then
            self:Remove()
        end
    end)
end

function SWEP:Reload()
    return false
end

function SWEP:ShouldDropOnDie()
    return false
end