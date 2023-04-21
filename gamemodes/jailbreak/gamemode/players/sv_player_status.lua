PLAYER_REBELLING = "Rebelling"
PLAYER_NEUTRAL = "Neutral"
PLAYER_CAUGHT = "Caught in Action"
PLAYER_WARDEN = "Warden"

local ply = FindMetaTable("Player")

function ply:SetStatus(status)
    self.status = status
    hook.Run("PlayerStatusChanged", self)
end

function ply:GetStatus()
    if not self.status then self:SetStatus(PLAYER_NEUTRAL) end
    return self.status
end