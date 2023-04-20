LOG_DROP = "Drop"
LOG_PICKUP = "Pickup"
LOG_KILL = "Kill"
LOG_DEATH = "Death"
LOG_DAMAGE = "Damage"
LOG_DOORS = "Doors"
LOG_DISCONNECT = "Disconnect"
LOG_RDM = "RDM"

function JB:RegisterKillLog(victim, inflictor, instigator, type)
    killLog = {
        Type = type,
        Time = self:GetTimeElapsed(),
        Victim = self:GetUser(victim),
        Culprit = self:GetUser(instigator),
        Weapon = inflictor:GetClass(),
        Day = self.dayPhase,
        Location = victim.containmentZones and victim.containmentZones[#victim.containmentZones] or "Unknown"
    }

    self:RegisterLog(killLog.Type == LOG_KILL and killLog.Culprit or killLog.Victim, killLog)
end

function JB:SpawnLog(ply)
    spawnLog = {
        Type = "Spawn",
        Time = self:GetTimeElapsed(),
        pl = ply,
        Location = ply.containmentZones and ply.containmentZones[#ply.containmentZones] or "Unknown",
        PlayerStatus = ply:GetStatus()
    }

    self:RegisterLog(self:GetUser(ply), spawnLog)
end

function JB:RegisterWeaponLog(weapon, instigator, type)
    if not instigator:Alive() then return end
    dropLog = {
        Type = type,
        Time = self:GetTimeElapsed(),
        Culprit = self:GetUser(instigator),
        Weapon = weapon:GetClass(),
        PlayerStatus = instigator:GetStatus(),
        Location = instigator.containmentZones and instigator.containmentZones[#instigator.containmentZones] or
            "Unknown"
    }

    self:RegisterLog(self:GetUser(instigator), dropLog)
end

function JB:GetUser(ply)
    if not ply then
        return
    end
    return ply:IsBot() and ply:Name() or ply:SteamID()
end

function JB:RegisterDamageLog(victim, inflictor, instigator, damage,  type)
    dropLog = {
        Type = type,
        Time = self:GetTimeElapsed(),
        Victim = self:GetUser(victim),
        Culprit = self:GetUser(instigator),
        Weapon = inflictor:GetClass(),
        PlayerStatus = instigator:GetStatus(),
        Damage = damage,
        Day = self.dayPhase,
        Location = instigator.containmentZones and instigator.containmentZones[#instigator.containmentZones] or
            "Unknown"
    }

    self:RegisterLog(self:GetUser(instigator), dropLog)
end

function JB:RegisterDoorsLog(ply)
    doorLog = {
        Type = LOG_DOORS,
        Time = self:GetTimeElapsed(),
        Instigator = ply and self:GetUser(ply) or self:GetUser(self.warden)
    }
    self:RegisterLog(doorLog.Instigator, doorLog)
end

function JB:RegisterDisconnectLog(ply)
    disconnectLog = {
        Type = LOG_DISCONNECT,
        Time = self:GetTimeElapsed(),
        Instigator = self:GetUser(ply)
    }
    self:RegisterLog(disconnectLog.Instigator, disconnectLog)
end

function JB:RegisterRDMLog(culprit, inflictor, instigator)
    rdmLog = {
        Type = LOG_RDM,
        Time = self:GetTimeElapsed(),
        Victim = self:GetUser(victim),
        Culprit = self:GetUser(instigator),
        Weapon = inflictor:GetClass(),
        Day = self.dayPhase,
        Location = victim.containmentZones and victim.containmentZones[#victim.containmentZones] or "Unknown"
    }

    self:RegisterLog(rdmLog.Culprit, rdmLog)
end

hook.Add("PlayerDroppedWeapon", "RegisterDropWeaponLog", function(instigator, weapon)
    JB:RegisterWeaponLog(weapon, instigator, LOG_DROP)
end)

hook.Add("WeaponEquip", "RegisterDropWeaponLog", function(weapon, instigator)

    if instigator:Team() == TEAM_PRISONERS and not instigator:GetStatus() == PLAYER_CAUGHT then
        for k, v in pairs(teams.GetPlayers(TEAM_GUARDS)) do
            if v:Alive() and v:Visible(instigator) then
                instigator:SetStatus(PLAYER_CAUGHT)
            end
        end
    end

    JB:RegisterWeaponLog(weapon, instigator, LOG_PICKUP)

end)

hook.Add("EntityTakeDamage", "RegisterDamageLog", function(target, dmginfo)
    local victim = target
    if victim:IsPlayer() then
        local culprit = dmginfo:GetAttacker()
        local inflictor = culprit:GetActiveWeapon()
        local health = target:Health() - dmginfo:GetDamage()
        local damage = dmginfo:GetDamage()
        if target:Team() == TEAM_GUARDS and culprit:Team() == TEAM_PRISONERS and
            not culprit:GetStatus() == PLAYER_CAUGHT then
                culprit:SetStatus(PLAYER_REBELLING)
            for k, v in pairs(teams.GetPlayers(TEAM_GUARDS)) do
                if v:Alive() and v:Visible(culprit) then
                    culprit:SetStatus(PLAYER_CAUGHT)
                end
            end
        end
        
        if health > 0 then 
        JB:RegisterDamageLog(target, inflictor, culprit, damage, LOG_DAMAGE)
        else
        JB:RegisterKillLog(target, inflictor , culprit, LOG_KILL)
        JB:RegisterKillLog(target, inflictor , culprit, LOG_DEATH)
        --TODO Implement RDM Check
        end
    end
end)

hook.Add("CellDoorsOpened", "RegisterDoorsLog", function(ply)
    JB:RegisterDoorsLog(ply)
end)

hook.Add("PlayerDisconnected", "RegisterDisconnectLog", function(ply)
    JB:RegisterDisconnectLog(ply)
end)
