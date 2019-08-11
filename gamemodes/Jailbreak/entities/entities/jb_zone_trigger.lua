AddCSLuaFile()
ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.zone = {"none", "kos", "armory", "mainArea", "club", "pharmacy", "gamesRoom", "prison", "toilets", "pool", "simonSays", "fourSquars", "field", "roof", "basketball", "volley", "cafeteria"}

if SERVER then
    function ENT:Initialize()
        self.zoneName = "none"
        self.activeHandles = false
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

    function ENT:SpawnHandles()
        self.handle_min = ents.Create("jb_zone_builder")
        self.handle_min:SetPos(self:GetPos() + Vector(-100, -50, -100))
        self.handle_min:SetZoneEntity(self)
        self.handle_min:Spawn()
        self.handle_max = ents.Create("jb_zone_builder")
        self.handle_max:SetPos(self:GetPos() + Vector(100, 100, 100))
        self.handle_max:SetZoneEntity(self)
        self.handle_max:Spawn()
        self.lastMin = self.handle_min:GetPos()
        self.lastMax = self.handle_max:GetPos()
        self.activeHandles = true
    end

    function ENT:RemoveHandles()
        self.handle_min:Remove()
        self.handle_max:Remove()
        self.activeHandles = false
    end

    function ENT:SetBounds(min, max)
        self:PhysicsInitBox(min, max)
        self:SetCollisionBounds(min, max)
    end

    function ENT:SetType(type)
        self.zoneName = type
        local col = Color(0, 0, 0)

        -- for k, v in pairs(player.GetAll()) do
        --     v:ChatPrint(self.zoneName)
        -- end

        if self.zoneName == "none" then
            col = Color(0, 0, 0)
        elseif self.zoneName == "kos" then
            col = Color(255, 0, 0)
        elseif self.zoneName == "armory" then
            col = Color(255, 150, 0)
        elseif self.zoneName == "armory" then
            col = Color(0, 0, 255)
        elseif self.zoneName == "mainArea" then
            col = Color(255, 255, 255)
        elseif self.zoneName == "club" then
            col = Color(0, 0, 150)
        elseif self.zoneName == "pharmacy" then
            col = Color(0, 255, 0)
        elseif self.zoneName == "gamesRoom" then
            col = Color(25, 25, 25)
        elseif self.zoneName == "prison" then
            col = Color(255, 200, 200)
        elseif self.zoneName == "toilets" then
            col = Color(0, 50, 0)
        elseif self.zoneName == "pool" then
            col = Color(0, 150, 255)
        elseif self.zoneName == "simonSays" then
            col = Color(255, 0, 255)
        elseif self.zoneName == "fourSquars" then
            col = Color(150, 0, 150)
        elseif self.zoneName == "field" then
            col = Color(0, 255, 255)
        elseif self.zoneName == "roof" then
            col = Color(255, 255, 0)
        elseif self.zoneName == "basketball" then
            col = Color(255, 100, 0)
        elseif self.zoneName == "volley" then
            col = Color(255, 50, 0)
        elseif self.zoneName == "cafeteria" then
            col = Color(0, 50, 150)
        else
            col = Color(0, 0, 0)
        end

        self:SetColor(col)
    end

    function ENT:GetType()
        return self.zoneName
    end

    function ENT:CycleType()
        self:SetType(self.zone[(table.KeyFromValue(self.zone, self.zoneName) )  % #self.zone + 1])
    end

    function ENT:StartTouch(other)
        if IsValid(other) and other:IsPlayer() and other:Alive() then
            other:AddInZone(self.zoneName, self:EntIndex())
        end
    end

    function ENT:EndTouch(other)
        if IsValid(other) and other:IsPlayer() and other:Alive() then
            other:RemoveFromZone(self.zoneName, self:EntIndex())
        end
    end

    local a0 = Angle(0, 0, 0)
    local p0 = Vector(0, 0, 0)

    function ENT:Think()
        if self:GetAngles() ~= a0 or self:GetPos() ~= p0 then
            self:SetAngles(a0)
            self:SetPos(p0)
            local phys = self:GetPhysicsObject()

            if phys and phys:IsValid() then
                phys:Wake()
                phys:EnableMotion(false)
                phys:EnableGravity(false)
                phys:EnableDrag(false)
            end
        end

        if IsValid(self.handle_min) and IsValid(self.handle_max) and (self.lastMin ~= self.handle_min:GetPos() or self.lastMax ~= self.handle_max:GetPos()) then
            self:Resize(self.handle_min:GetPos(), self.handle_max:GetPos())
            self.lastMin = self.handle_min:GetPos()
            self.lastMax = self.handle_max:GetPos()
        end
    end

    function ENT:Resize(minWorld, maxWorld)
        local min = self:WorldToLocal(minWorld)
        local max = self:WorldToLocal(maxWorld)
        self:PhysicsInitBox(min, max)
        self:SetCollisionBounds(min, max)
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
        local col = self:GetColor()
        render.SetMaterial(tx)
        render.DrawBox(self:GetPos(), self:GetAngles(), mins, maxs, Color(col.r, col.g, col.b, col.a), true)
        render.DrawWireframeBox(self:GetPos(), self:GetAngles(), mins, maxs, Color(255, 255, 255), true)
    end
end