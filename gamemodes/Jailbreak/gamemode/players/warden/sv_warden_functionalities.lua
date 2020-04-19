util.AddNetworkString("OnWardenSet")
util.AddNetworkString("OnWardenRequest")
util.AddNetworkString("RequestPromotion")
local pl = FindMetaTable("Player")
JB.warden = nil

function pl:IsWarden()
    if JB.warden == self then return true end

    return false
end

function JB:SetWarden(guard)
    local oldWarden = self.warden
    self.warden = guard
    hook.Run("PlayerSetWarden", oldWarden, self.warden)
    self:BroadcastWarden()

    if oldWarden then
        oldWarden:ApplyModel()
    end

    if self.warden then
        self.warden:ApplyModel()
    end
end

function JB:RevokeWarden()
    hook.Run("WardenRevoked")
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
    if not IsValid(self.warden) or not self.warden:Alive() then
        self:RevokeWarden()
    end
end

function JB:ToggleWardenWeaponSwitch(active)
    hook.Add("PlayerSwitchWeapon", "WaypointSwitchWeapon", function(ply)
        if ply == JB.warden then
            return active
        else
            return true
        end
    end)
end

function JB:PromotePlayer(ply)
    if ply:Team() == Team.GUARDS and not JB.warden and ply:Alive() and JB:GetActivePhase() == ROUND_PREPARING then
        JB:SetWarden(ply)
    elseif JB.warden == ply then
        JB:RevokeWarden()
    end
end

hook.Add("PlayerDisconnected", "CheckWardenIsDisconnected", function(ply)
    JB:ValidateWarden()
end)

hook.Add("PlayerChangedTeam", "CheckWardenTeamHasChange", function(ply)
    JB:ValidateWarden()
end)

hook.Add("PostPlayerDeath", "CheckWardenHasDied", function(ply)
    JB:ValidateWarden()
end)

hook.Add("PlayerSilentDeath", "CheckWardenHasDiedSilently", function(ply)
    JB:ValidateWarden()
end)

net.Receive("OnWardenRequest", function(ln, ply)
    JB:BroadcastWarden(ply)
end)

net.Receive("RequestPromotion", function(ln, ply)
    JB:PromotePlayer(ply)
end)