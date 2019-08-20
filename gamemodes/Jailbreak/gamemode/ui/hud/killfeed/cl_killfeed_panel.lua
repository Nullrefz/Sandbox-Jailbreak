local KILLFEEDPANEL = {}
local totalHeight = 0

function KILLFEEDPANEL:Init()
    self.noticePool = {}

    net.Receive("PlayerNoticeDied", function()
        local victim = net.ReadEntity()
        local killer = net.ReadEntity()
        self:AddDeathNotice(victim, killer)
    end)
end

function KILLFEEDPANEL:Think(width, height)
    self:SetTall(Lerp(FrameTime() * 10, self:GetTall(), totalHeight))

    for i = 1, #self.noticePool do
        if IsValid(v) then
            v:SetPos(0, (i - 1) * v:GetTall())
        end
    end
end

function KILLFEEDPANEL:AddDeathNotice(victim, killer)
    print(victim, killer)
    print(IsValid(victim), IsValid(killer))
    if not IsValid(victim) or not IsValid(killer) then return end
    local deathNotice = vgui.Create("JailbreakKillFeedBar", self)
    deathNotice:AssignPlayers(victim, killer)
    deathNotice:SetSize(toHRatio(256), toVRatio(45))
    deathNotice:StartEntryAnimation()
    table.insert(self.noticePool, deathNotice)
    totalHeight = toVRatio(45) * #self.noticePool
    print(totalHeight)
end

function KILLFEEDPANEL:PerformLayout(width, height)
end

vgui.Register("JailbreakKillFeedPanel", KILLFEEDPANEL)