function JB:RegisterKillLog(victim, culprit, inflictor, type)
    killLog = {
        Type = type,
        Time = self:GetTimeElapsed(),
        Victim = victim:IsBot() and victim:Name() or victim:SteamID(),
        Culprit = culprit:IsBot() and culprit:Name() or culprit:SteamID(),
        Day = self.dayPhase,
        Location = victim.containmentZones and victim.containmentZones[#victim.containmentZones] or "Unknown"
    }

    if killLog.Type == "Kill" then
        self:RegisterLog(culprit, killLog)
    elseif killLog.Type == "Death" then
        self:RegisterLog(victim, killLog)
    end
end

hook.Add("PlayerDeath", "RegisterDeathLog", function(victim, inflictor, attacker)
    JB:RegisterKillLog(victim, inflictor, attacker, "Kill")
    JB:RegisterKillLog(victim, inflictor, attacker, "Death")
end)

function JB:RegisterWeaponDropLog(weapon, culprit, type)
    dropLog = {
        Type = type,
        Time = self:GetTimeElapsed(),
        Culprit = culprit:IsBot() and culprit:Name() or culprit:SteamID(),
        Weapon = weapon:GetClass(),
        Location = culprit.containmentZones and culprit.containmentZones[#culprit.containmentZones] or "Unknown"
    }

    self:RegisterLog(culprit, dropLog)
end

hook.Add("PlayerDroppedWeapon", "RegisterDropWeaponLog", function(culprit, weapon)
    JB:RegisterWeaponDropLog(weapon, culprit, "Drop")
end)

hook.Add("WeaponEquip", "RegisterDropWeaponLog", function(weapon, culprit)
    JB:RegisterWeaponDropLog(weapon, culprit, "Pickup")
end)