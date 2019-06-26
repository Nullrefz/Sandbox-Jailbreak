--[[---------------------------------------------------------
    Name: jailbreak:EnableRespawns()
    Desc: Enables player respawn
-----------------------------------------------------------]]
function JB:EnableRespawns()
    hook.Remove("PlayerDeathThink", "Disable Respawns")
end

--[[---------------------------------------------------------
    Name: jailbreak:DisableRespawns()
    Desc: Disables players respawn
-----------------------------------------------------------]]
function JB:DisableRespawns()
    hook.Add("PlayerDeathThink", "Disable Respawns", function() return false end)
end

--[[---------------------------------------------------------
    Name: jailbreak:SpawnAllPlayers()
    Desc: Spawns all players
-----------------------------------------------------------]]
function JB:SpawnAllPlayers()
    for k, v in pairs(player.GetAll()) do
        v:StripWeapons()
        v.spectatee = nil
        v:Spawn()
    end
end

--[[---------------------------------------------------------
    Name: jailbreak:KillAllPlayers()
    Desc: Kills all players
-----------------------------------------------------------]]
function JB:KillAllPlayers()
    for k, v in pairs(player.GetAll()) do
        v:Kill()
    end
end

--[[---------------------------------------------------------
    Name: jailbreak:SpawnDeadPlayers()
    Desc: Spawns dead players
-----------------------------------------------------------]]
function JB:SpawnDeadPlayers()
    for k, v in pairs(player.GetAll()) do
        if not v:Alive() then
            self:PlayerSpawn(v)
        end
    end
end

--[[---------------------------------------------------------
    Name: jailbreak:SpawnDeadPlayersByTeam()
    Desc: Spawns dead players by team
    Args: • team       -- chosen team
-----------------------------------------------------------]]
function JB:SpawnDeadPlayersByTeam(team)
    for k, v in pairs(team.GetPlayers(team)) do
        if not v:Alive() then
            self:PlayerSpawn(v)
        end
    end
end

--[[---------------------------------------------------------
    Name: jailbreak:FreezePlayers()
    Desc: Toggles freeze on all players
    Args: • enabled       -- freeze condition
-----------------------------------------------------------]]
function JB:FreezePlayers(enabled)
    for k, v in pairs(player.GetAll()) do
        v:Freeze(enabled)
    end
end

--[[---------------------------------------------------------
    Name: jailbreak:GetAlivePlayers()
    Desc: returns how many players are alive by team
-----------------------------------------------------------]]
function JB:GetAlivePlayers()
    local alivePlayers = {}

    for k, v in pairs(player.GetAll()) do
        if v:IsValid() and v:Alive() then
            table.insert(alivePlayers, v)
        end
    end

    return alivePlayers
end

--[[---------------------------------------------------------
    Name: jailbreak:GetAlivePlayersByTeam()
    Desc: returns how many players are alive by team
    Args: • teamIndex       -- chosen team
-----------------------------------------------------------]]
function JB:GetAlivePlayersByTeam(teamIndex)
    local alivePlayers = {}

    for k, v in pairs(team.GetPlayers(teamIndex)) do
        if v:IsValid() and v:Alive() then
            table.insert(alivePlayers, v)
        end
    end

    return alivePlayers
end

function JB:SetSelfCollision(enabled, playerTeam)
    if not playerTeam then
        for k, v in pairs(player.GetAll()) do
            v:SetNoCollideWithTeammates(enabled)
        end
    else
        for k, v in pairs(team.GetPlayers(playerTeam)) do
            v:SetNoCollideWithTeammates(enabled)
        end
    end
end