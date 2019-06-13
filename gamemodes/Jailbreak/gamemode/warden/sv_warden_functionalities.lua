util.AddNetworkString("OnWardenSet")
util.AddNetworkString("OnWardenRequest")

function JB:SetWarden(guard)
    if guard:Team() == TEAM_GUARDS then
        self.warden = guard
        self:BroadcastWarden()
    end
end

function JB:RevokeWarden()
    if self.warden then
        self.warden = nil
    end
end

function GM:ShowTeam(ply)
    if ply:Team() == TEAM_GUARDS and not JB.warden and JB:GetActivePhase() == ROUND_PREPARING then
        JB:SetWarden(ply)
    end
end

net.Receive("OnWardenRequest", function(ln, ply)
    JB:BroadcastWarden(ply)
end)