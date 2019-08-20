local KILLFEEDPANEL = {}
local totalHeight = 0

function KILLFEEDPANEL:Init()
    self.noticePool = {}

    net.Receive("PlayerDied", function()
        self:AddDeathNotice(player.GetBySteamID(net.ReadString()), player.GetBySteamID64(net.ReadString()))
    end)
end

function VOICEPANEL:Think(width, height)
    self:SetTall(Lerp(FrameTime() * 20, self:GetTall(), totalHeight))

    --    if not table.IsEmpty(self.voiceBars) then return end
    for i = 1, #self.voiceBars do
        if IsValid(v) then
            v:SetPos(self:GetWide() - v:GetWide(), i * v:GetTall())
        end
    end
end

function VOICEPANEL:AddDeathNotice(victim, killer)
    local deathNotice = vgui.Create("JailbreakKillFeedBar", self)
    table.insert(self.noticePool, deathNotice)
    deathNotice:AssignPlayers(victim, killer)
    deathNotice:SetSize(self:GetWide(), 45)
    deathNotice:StartEntryAnimation()
    totalHeight = totalHeight + v:GetTall() * #self.noticePool
end

vgui.Register("JailbreakKillFeedPanel", KILLFEEDPANEL)