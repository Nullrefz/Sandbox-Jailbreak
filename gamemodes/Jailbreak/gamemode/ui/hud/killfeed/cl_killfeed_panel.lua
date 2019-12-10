local KILLFEEDPANEL = {}
local totalHeight = 0

function KILLFEEDPANEL:Init()
    self.noticePool = {}

    --self.panel = vgui.Create("DPanel", self)
    net.Receive("PlayerNoticeDied", function()
        local victim = net.ReadEntity()
        local killer = net.ReadEntity()
        self:AddDeathNotice(victim, killer)
    end)
end

function KILLFEEDPANEL:Think()
    self:SetTall(Lerp(FrameTime() * 5, self:GetTall(), totalHeight))

    for i = 1, #self.noticePool do
        if IsValid(self.noticePool[i]) then
            self.noticePool[i]:SetPos(self:GetWide() - self.noticePool[i]:GetWide(), self:GetTall() - (self.noticePool[i]:GetTall() + 8) * i)
        else
            table.remove(self.noticePool, i)
            totalHeight = toVRatio(45 + 8) * #self.noticePool
            self:SetTall(totalHeight)
        end
    end
end

function KILLFEEDPANEL:AddDeathNotice(victim, killer)
    if not IsValid(victim) or not IsValid(killer) then return end
    local deathNotice = vgui.Create("JailbreakKillFeedBar", self)
    deathNotice:AssignPlayers(victim, killer)
    deathNotice:SetSize(toHRatio(400), toVRatio(45))
    deathNotice:StartEntryAnimation()
    table.insert(self.noticePool, deathNotice)
    totalHeight = toVRatio(45 + 8) * #self.noticePool
    self:SetTall(totalHeight)
end

function KILLFEEDPANEL:PerformLayout(width, height)
    -- self.panel:SetSize(width, height)
end

vgui.Register("JailbreakKillFeedPanel", KILLFEEDPANEL)