function JB:RegisterKillLog(victim, inflictor, culprit, type)
    killLog = {
        Type = type,
        Time = self:GetTimeElapsed(),
        Victim = self:GetUser(victim),
        Culprit = self:GetUser(culprit),
        Day = self.dayPhase,
        Location = victim.containmentZones and victim.containmentZones[#victim.containmentZones] or "Unknown"
    }

    if killLog.Type == "Kill" then
        self:RegisterLog(killLog.Culprit, killLog)
    elseif killLog.Type == "Death" then
        self:RegisterLog(killLog.Victim, killLog)
    end
end

hook.Add("PlayerDeath", "RegisterDeathLog", function(victim, inflictor, attacker)
    JB:RegisterKillLog(victim, inflictor, attacker, "Kill")
    JB:RegisterKillLog(victim, inflictor, attacker, "Death")
end)

function JB:SpawnLog(ply)
    spawnLog = {
        Type = "Spawn",
        Time = self:GetTimeElapsed(),
        pl = ply,
        Location = ply.containmentZones and ply.containmentZones[#ply.containmentZones] or "Unknown"
    }

    self:RegisterLog(self:GetUser(ply), spawnLog)
end

function JB:RegisterWeaponDropLog(weapon, culprit, type)
    dropLog = {
        Type = type,
        Time = self:GetTimeElapsed(),
        Culprit = not culprit:IsPlayer() and culprit:GetClass() or culprit:SteamID(),
        Weapon = weapon:GetClass(),
        Location = culprit.containmentZones and culprit.containmentZones[#culprit.containmentZones] or "Unknown"
    }

    self:RegisterLog(self:GetUser(culprit), dropLog)
end

function JB:GetUser(ply)
    return ply:IsBot() and ply:Name() or ply:SteamID()
end

hook.Add("PlayerDroppedWeapon", "RegisterDropWeaponLog", function(culprit, weapon)
    JB:RegisterWeaponDropLog(weapon, culprit, "Drop")
end)

hook.Add("WeaponEquip", "RegisterDropWeaponLog", function(weapon, culprit)
    JB:RegisterWeaponDropLog(weapon, culprit, "Pickup")
end)