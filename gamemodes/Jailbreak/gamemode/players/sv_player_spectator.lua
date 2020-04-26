util.AddNetworkString("SpectatePlayer")
JB.spectate = {}
local player = FindMetaTable("Player")

function JB:AddSpectatorAction(key, action)
    self.spectate[key] = action
end

function player:CycleSpectateMode(mode)
    if (mode) then
        self:SetObserverMode(mode)

        return
    end

    if self:GetObserverMode() == OBS_MODE_ROAMING then
        self:SetObserverMode(OBS_MODE_IN_EYE)
        hook.Run("SpectatorChanged", self:GetObserverTarget())
        self:UpdateHud(self:GetObserverTarget())
    elseif self:GetObserverMode() == OBS_MODE_IN_EYE then
        self:SetObserverMode(OBS_MODE_CHASE)
        hook.Run("SpectatorChanged", self:GetObserverTarget())
        self:UpdateHud(self:GetObserverTarget())
    elseif self:GetObserverMode() == OBS_MODE_CHASE then
        self:SetObserverMode(OBS_MODE_ROAMING)
        hook.Run("SpectatorChanged")
        self:UpdateHud()
    end
end

function player:SpectateNewTarget(forward)
    local currentTarget = self:GetObserverTarget()
    local direction = forward and 1 or -1
    local playersAlive = JB:GetAlivePlayers()

    if currentTarget.spectators and table.HasValue(currentTarget.spectators, self) then
        table.RemoveByValue(currentTarget.spectators, self)
    end

    if #playersAlive >= 1 then
        if not IsValid(currentTarget) or (currentTarget:IsPlayer() and not currentTarget:Alive()) then
            currentTarget = playersAlive[1]
        end

        for k, v in pairs(playersAlive) do
            if v == currentTarget then
                local cycle = (k + direction) % #playersAlive

                if cycle == 0 then
                    cycle = cycle + #playersAlive
                end

                currentTarget = playersAlive[cycle]
                break
            end
        end

        self:SpectateEntity(currentTarget)
    end

    if IsValid(currentTarget) then
        self:SpectateEntity(currentTarget)
        table.insert(currentTarget.spectators, self)

        if self:GetObserverMode() == OBS_MODE_ROAMING then
            hook.Run("SpectatorChanged")
            self:UpdateHud()
        else
            self:UpdateHud(currentTarget)
            hook.Run("SpectatorChanged", currentTarget)
        end

        return currentTarget
    end
end

function JB:SpectatorKeyPress(ply, key)
    if not IsValid(ply) or ply:Alive() then return end
    if ply:KeyDown(key) and self.spectate[key] then
        self.spectate[key](ply)
    end
end

hook.Add("PlayerDeath", "Holdspectate", function(ply)
    timer.Simple(2, function()
        ply:StartSpectating()
    end)
end)

hook.Add("KeyPress", "JailBreakSpectatorControls", function(ply, key)
    JB:SpectatorKeyPress(ply, key)
end) --timer.Simple(3, function() ply:StartSpectating() end)

function JB:SetupSpectators()
    self:AddSpectatorAction(IN_ATTACK, function(ply)
        ply:SpectateNewTarget(false)
    end)

    self:AddSpectatorAction(IN_ATTACK2, function(ply)
        ply:SpectateNewTarget(true)
    end)

    self:AddSpectatorAction(IN_JUMP, function(ply)
        if (ply:GetObserverMode() ~= OBS_MODE_ROAMING) then
            ply:CycleSpectateMode(OBS_MODE_ROAMING)
            ply:SetMoveType(MOVETYPE_NOCLIP)
        end
    end)

    self:AddSpectatorAction(IN_DUCK, function(ply)
        ply:CycleSpectateMode()
    end)
end

function player:StartSpectating()
    if not self:Alive() and self:GetObserverMode() ~= OBS_MODE_ROAMING then
        self:CycleSpectateMode(OBS_MODE_ROAMING)
        self:SetMoveType(MOVETYPE_NOCLIP)
    end
end

function player:UpdateHud(target)
    net.Start("SpectatePlayer")

    if target then
        net.WriteString(target:UniqueID())
    end

    net.Send(self)
end

hook.Add("JB_Initialize", "InitializeSpectators", function() JB:SetupSpectators() end)

hook.Add("PlayerDeathThink", "DisableSpectatorRespawns", function(ply)
    if ply:Team() > Team.GUARDS then return false end
end)

hook.Add("PlayerInitialSpawn", "AddSpectatorTable", function(ply)
    ply.spectators = {}
end)

hook.Add("PlayerSpawn", "AddSpectatorTable", function(ply)
    ply.spectators = {}
    ply:UpdateHud(ply)
end)