local VOICEPANEL = {}
local totalHeight = 0

function VOICEPANEL:Init()
    self.voiceBars = {}

    hook.Add("PlayerStartVoice", "PlayerUsedMic", function(ply)
        self:AddVoiceBar(ply)
    end)

    hook.Add("PlayerEndVoice", "PlayerStoppedUsingMic", function(ply)
        self:RemoveVoiceBar(ply)
    end)
end

function VOICEPANEL:Paint(width, height)
    self:SetTall(Lerp(FrameTime() * 10, self:GetTall(), totalHeight))
end

function VOICEPANEL:AddVoiceBar(ply)
    local voiceBar

    if not self.voiceBars[ply] then
        voiceBar = vgui.Create("JailbreakVoiceBar", self)
        self.voiceBars[ply] = voiceBar
    else
        voiceBar = self.voiceBars[ply]
    end

    voiceBar:SetSize(toHRatio(512), toVRatio(64))
    voiceBar:StartEntryAnimation()
    voiceBar:AssignPlayer(ply)
    totalHeight = 0

    for k, v in pairs(self.voiceBars) do
        totalHeight = totalHeight + v:GetTall()
    end
end

function VOICEPANEL:RemoveVoiceBar(ply)
    if not self.voiceBars[ply] then return end
    self.voiceBars[ply]:StartExitAnimation()
end

vgui.Register("JailbreakVoicePanel", VOICEPANEL)