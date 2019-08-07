AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = 'base_anim'

if SERVER then
    ENT.zone = {
        None = "none",
        KOS = "kos",
        ARMORY = "armory"
    }

    function ENT:Initialize()
        self.type = self.zone.KOS
        self:SetModel('models/hunter/blocks/cube025x025x025.mdl')
        local min = self.min or Vector(-100, -50, -100)
        local max = self.max or Vector(100, 100, 100)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
        self:SetTrigger(true)
        self:PhysicsInitBox(min, max)
        self:SetCollisionBounds(min, max)
        local phys = self:GetPhysicsObject()

        if phys and phys:IsValid() then
            phys:Wake()
            phys:EnableMotion(false)
            phys:EnableGravity(false)
            phys:EnableDrag(false)
        end
    end

    function ENT:SetBounds(min, max)
        self:PhysicsInitBox(min, max)
        self:SetCollisionBounds(min, max)
    end

    function ENT:SetType(type)
        self.type(type)
    end

    function ENT:StartTouch(other)
        if IsValid(other) and other:IsPlayer() then
            ply:SetInKOSZone(self.type)
        end
    end

    function ENT:EndTouch(other)
        if IsValid(other) and other:IsPlayer() then
            ply:SetInKOSZone(self.zone.NONE)
        end
    end
end

if CLIENT then
    function ENT:Think()
        local mins, maxs = self:OBBMins(), self:OBBMaxs()
        self:SetRenderBoundsWS(mins, maxs)
    end

    local tx = Material("color")

    function ENT:Draw()
        local ply = LocalPlayer()
        local wep = ply:GetActiveWeapon()
        if not IsValid(ply) or not IsValid(wep) or wep:GetClass() ~= "weapon_physgun" then return end
        local mins, maxs = self:OBBMins(), self:OBBMaxs()
        render.SetMaterial(tx)
        render.DrawBox(self:GetPos(), self:GetAngles(), mins, maxs, JB.Color["#FF4411AA"], true)
        render.DrawWireframeBox(self:GetPos(), self:GetAngles(), mins, maxs, JB.Color["#FFCCAAFF"], true)
    end
end