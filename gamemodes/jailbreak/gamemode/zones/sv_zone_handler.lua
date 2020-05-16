local ply = FindMetaTable("Player")
util.AddNetworkString("SendZone")

function ply:AddInZone(zone, ID)
    if not self.containmentZones then
        self.containmentZones = {}
    end

    self.containmentZones[ID] = zone
    self:SendZone(self.containmentZones)
end

function ply:RemoveFromZone(zone, ID)
    if not self.containmentZones then return end
    self.containmentZones[ID] = nil
    self:CheckRestrictions(zone, ID)
    self:SendZone(self.containmentZones)
end

function ply:SendZone(zone)
    net.Start("SendZone")
    net.WriteTable(zone)
    net.Send(self)
end

function ply:ClearZones()
    if not self.containmentZones then return end
    self.containmentZones = {}
    self.restrictedZones = {}
end

function ply:CheckRestrictions(zone, ID)
    if not self.restrictedZones then return end

    for k, v in pairs(self.restrictedZones) do
        if k == zone then
            self:SetPos(self:GetSpawnPos())

            local notification = {
                TEXT = v,
                TARGET = self,
                TYPE = 2
            }

            JB:SendNotification(notification)
        end
    end
end

function ply:RestrictZone(zoneName, message)
    if not self.restrictedZones then
        self.restrictedZones = {}
    end

    self.restrictedZones[zoneName] = message
end

function ply:ClearRestrictions()
    self.restrictedZones = {}
end

hook.Add("PlayerDeath", "ResetZones", function(ply)
    ply:ClearZones()
end)