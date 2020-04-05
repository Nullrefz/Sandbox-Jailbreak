function JB:RegisterKillLog(victim, culprit)
    killLog = {
        Type = "Kill",
        Time = self:GetTimeElapsed(),
        Victim = victim,
        Culprit = culprit,
        Day = day,
        Location = location
    }

    return killLog
end

function JB:RegisterDeathLog(victim, culprit)
    deathLog = {
        Type = "Death",
        Time = self:GetTimeElapsed(),
        Victim = victim,
        Culprit = culprit,
        Day = day,
        Location = location
    }

    return deathLog
end

function JB:RegisterWeaponDropLog(weapon, culprit)
    dropLog = {
        Type = "Drop",
        Time = self:GetTimeElapsed(),
        Culprit = culprit,
        Weapon = weapon,
        Location = location
    }

    return dropLog
end

function JB:RegisterWeaponDropLog(weapon, culprit)
    pickupLog = {
        Type = "Pickup",
        Time = self:GetTimeElapsed(),
        Culprit = culprit,
        Weapon = weapon,
        Location = location
    }

    return pickupLog
end