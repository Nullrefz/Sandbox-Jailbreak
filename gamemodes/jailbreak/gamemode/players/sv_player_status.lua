PLAYER_REBELLING = "Rebelling"
PLAYER_NEUTRAL = "Neutral"
PLAYER_CAUGHT = "Caught"
PLAYER_WARDEN = "Warden"

local ply = FindMetaTable("Player")

function ply:SetStatus(status)
    self.status = status
    hook.Run("PlayerStatusChanged", self)
end

function ply:GetStatus()
    if not self.status then
        self:SetStatus(PLAYER_NEUTRAL)
    end
    return self.status
end

hook.Add("jb_round_active", "SetWArdenStatus", function()
    for k, v in pairs(player.GetAll()) do
        if v:Team() == TEAM_PRISONERS then
            for i, w in pairs(v:GetWeapons()) do
                if w:GetClass() ~= "weapon_jb_hands" and w:GetClass() ~= "weapon_jb_empty" then
                    v:SetStatus(PLAYER_REBELLING)
                end
            end

        end
    end

    if not JB.warden then
        return
    end
    JB.warden:SetStatus(PLAYER_WARDEN)
end)

hook.Add("PlayerSpawn", "ResetPlayerStatus", function(ply)
    ply.status = PLAYER_NEUTRAL
end)
