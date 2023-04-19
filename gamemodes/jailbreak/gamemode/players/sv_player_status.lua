PLAYER_REBELLING = "Rebelling"
PLAYER_NEUTRAL = "Neutral"
PLAYER_CAUGHT = "Caught in Action"
PLAYER_RDM = "RDM"

local ply = FindMetaTable("Player")

function ply:SetStatus(status)
    self.status = status
end

function ply:GetStatus()
    if not self.status then self:SetStatus(PLAYER_NEUTRAL) end
    return self.status
end