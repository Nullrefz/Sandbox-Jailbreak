local ply = FindMetaTable("Player")
util.AddNetworkString("SendKOSWarning")

function ply:AddInZone(zone, ID)
    if not self.containmentZones then
        self.containmentZones = {}
    end

    self.containmentZones[ID] = zone
    self:CheckWarns()
end

function ply:RemoveFromZone(zone, ID)
    if not self.containmentZones then return end
    self.containmentZones[ID] = nil
    self:CheckRestrictions(zone, ID)
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
                TEXT = "You must stay in the " .. zone,
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

function ply:WarnZone(zoneName, message)
    -- TODO: Implement Warn Zone
end

function ply:CheckWarns()
    -- TODO:Handle Warn Zone
end

hook.Add("PlayerDeath", "ResetZones", function(ply)
    ply:ClearZones()
end)