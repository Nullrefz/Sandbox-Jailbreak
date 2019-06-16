util.AddNetworkString("OnWardenSet")
util.AddNetworkString("OnWardenRequest")
local ply = FindMetaTable("Player")

function ply:IsWarden()
    if JB.warden == self then return true end

    return false
end

function JB:SetWarden(guard)
    local oldWarden = self.warden
    self.warden = guard

    hook.Run("PlayerSetWarden", oldWarden, self.warden)
    self:BroadcastWarden()
end

function JB:RevokeWarden()
    self:SetWarden(nil)
end

function JB:BroadcastWarden(ply)
    net.Start("OnWardenSet")

    if self.warden then
        net.WriteString(self.warden:SteamID())
    end

    if ply then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function JB:ValidateWarden()
    local wardenValid = false

    for k, v in pairs(player.GetAll()) do
        if IsValid(v) and v == self.warden and v:Team() == Team.GUARDS and v:Alive() then
            wardenValid = true
            break
        end
    end

    if not wardenValid then
        self:RevokeWarden()
    end
end

function GM:ShowTeam(ply)
    -- and (JB:GetActivePhase() == ROUND_PREPARING or JB:GetActivePhase() == ROUND_WAITING) then
    if ply:Team() == Team.GUARDS and not JB.warden and ply:Alive() then
        JB:SetWarden(ply)
    elseif JB.warden == ply then
        JB:RevokeWarden()
    end
end

hook.Add("PlayerDisconnected", "CheckWardenIsDisconnected", function()
    JB:ValidateWarden()
end)

hook.Add("PlayerChangedTeam", "CheckWardenTeamHasChange", function()
    JB:ValidateWarden()
end)

hook.Add("PlayerDeath", "CheckWardenHasDied", function()
    JB:ValidateWarden()
end)

hook.Add("PlayerSilentDeath", "CheckWardenHasDiedSilently", function()
    JB:ValidateWarden()
end)

net.Receive("OnWardenRequest", function(ln, ply)
    JB:BroadcastWarden(ply)
end)