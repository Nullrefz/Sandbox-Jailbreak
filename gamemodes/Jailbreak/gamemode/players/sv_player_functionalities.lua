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

--[[---------------------------------------------------------
    Name: jailbreak:SetNoSelfCollision()
    Desc: Sets if players should self collide 
    Args: • enabled         -- collision enabled
          • playerTeam      -- chosen team
-----------------------------------------------------------]]
function JB:SetNoSelfCollision(enabled, playerTeam)
    for k, v in pairs(playerTeam and team.GetPlayers(playerTeam) or player.GetAll()) do
        v:SetNoCollideWithTeammates(enabled)
    end
end

--[[---------------------------------------------------------
    Name: jailbreak:SetFriendlyFire()
    Desc: Sets if players can hurt team members
    Args: • enabled         -- friendly fire enabled
          • playerTeam      -- chosen team
-----------------------------------------------------------]]
function JB:SetFriendlyFire(enabled, chosenTeam)
    hook.Add("PlayerShouldTakeDamage", "FriendFire", function(ply, attacker)
        if attacker:IsPlayer() then
            if not chosenTeam and ply:Team() == attacker:Team() then return enabled end
            if ply:Team() == chosenTeam and attacker:Team() == chosenTeam then return enabled end
        end

        return true
    end)
end

--[[---------------------------------------------------------
    Name: jailbreak:SetMicEnabled()
    Desc: Sets if players can use mic
    Args: • enabled         -- mic enabled
          • playerTeam      -- chosen team
-----------------------------------------------------------]]
function JB:SetMicEnabled(enabled, chosenTeam)
    if chosenTeam == Team.PRISONERS then
        local notification = {
            TEXT = "prisonners are now " .. (enabled and "unmuted" or "muted")
        }

        self:SendNotification(notification)
    end

    hook.Add("PlayerCanHearPlayersVoice", "SetMicEnabled", function(listener, talker)
        if not talker:Alive() then return false end
        if talker == JB.warden then return true end

        if not chosenTeam then
            return enabled
        else
            if talker:Team() == chosenTeam then return enabled end

            return true
        end
    end)
end

util.AddNetworkString("SendHighlights")

function JB:HighlightPlayer(players, targets)
    net.Start("SendHighlights")

    if players then
        net.WriteTable(players)
    else
        net.WriteTable({})
    end

    if targets then
        for k, v in pairs(targets) do
            net.Send(v)
        end
    else
        net.Broadcast()
    end
end