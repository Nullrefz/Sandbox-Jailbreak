util.AddNetworkString("OnWardenSet")
util.AddNetworkString("OnWardenRequest")
local ply = FindMetaTable("Player")

function ply:IsWarden()
    if JB.warden == self then return true end

    return false
end

function JB:SetWarden(guard)
    if guard:Team() == TEAM_GUARDS then
        self.warden = guard
        print(self.warden)
        self:BroadcastWarden()
    end
end

function JB:RevokeWarden()
    if self.warden then
        self.warden = nil
    end
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

function GM:ShowTeam(ply)
    -- and not JB.warden then -- and JB:GetActivePhase() == ROUND_PREPARING then
    if ply:Team() == TEAM_GUARDS then
        JB:SetWarden(ply)
    end
end

net.Receive("OnWardenRequest", function(ln, ply)
    JB:BroadcastWarden(ply)
end)