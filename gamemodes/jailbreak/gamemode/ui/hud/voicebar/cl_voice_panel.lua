local VOICEPANEL = {}
local totalHeight = 0

function VOICEPANEL:Init()
    self.voiceBars = {}

    hook.Add("PlayerStartVoice", "PlayerUsedMic", function(ply)
        if ply:IsMuted() then return false end
        self:AddVoiceBar(ply)

        return false
    end)

    hook.Add("PlayerEndVoice", "PlayerStoppedUsingMic", function(ply)
        self:RemoveVoiceBar(ply)

        return false
    end)
end

function VOICEPANEL:Think(width, height)
    self:SetTall(Lerp(FrameTime() * 20, self:GetTall(), totalHeight))
    --    if not table.IsEmpty(self.voiceBars) then return end
    local i = 0

    for k, v in pairs(self.voiceBars) do
        if IsValid(v) then
            v:SetPos(self:GetWide() - v:GetWide(), i * (v:GetTall() + toVRatio(4)))
        end

        i = i + 1
    end
end

function VOICEPANEL:AddVoiceBar(ply)
    local voiceBar

    if self.voiceBars[ply:SteamID()] and IsValid(self.voiceBars[ply:SteamID()]) then
        voiceBar = self.voiceBars[ply:SteamID()]
    else
        voiceBar = vgui.Create("JailbreakVoiceBar", self)
        self.voiceBars[ply:SteamID()] = voiceBar
    end

    voiceBar:AssignPlayer(ply)
    local len = voiceBar.nameText:GetWide() + toHRatio(72 + voiceBar.skew * 6)
    voiceBar:SetSize(len, 45)
    voiceBar:StartEntryAnimation()
    totalHeight = 45

    for k, v in pairs(self.voiceBars) do
        if v and IsValid(v) then
            totalHeight = totalHeight + v:GetTall() + toVRatio(4)
        end
    end
end

function VOICEPANEL:RemoveVoiceBar(ply)
    if not self.voiceBars[ply:SteamID()] or not IsValid(self.voiceBars[ply:SteamID()]) then return end
    self.voiceBars[ply:SteamID()]:StartExitAnimation()
end

function VOICEPANEL:PerformLayout(width, height)
end

vgui.Register("JailbreakVoicePanel", VOICEPANEL)