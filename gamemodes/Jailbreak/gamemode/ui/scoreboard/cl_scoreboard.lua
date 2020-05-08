local SCOREBOARD = {}

function SCOREBOARD:Init()
    self:SetSize(w, h)
    self.panel = vgui.Create("Panel", self)
    self.panel:MakePopup()
    self.panel:Dock(FILL)

    function self.panel:Paint()
        Derma_DrawBackgroundBlur(self, 0)
    end

    self.group = {}

    for i = Team.PRISONERS, Team.SPECTATORS do
        if i == Team.SPECTATORS and #team.GetPlayers(1002) == 0 then return end
        local playerGroup = vgui.Create("ScoreboardGroup", self.panel)
        playerGroup:SetGroup(i)

        if i == Team.SPECTATORS then
            playerGroup:SetSize(w / 2, toVRatio(256))
            playerGroup:SetPos(w / 2, h - playerGroup:GetTall())
        else
            playerGroup:Dock(TOP)
            playerGroup:DockMargin(32, 0, 0, 0)
        end

        playerGroup:InvalidateLayout(true)
        playerGroup:SizeToChildren(false, true)
        table.insert(self.group, playerGroup)
    end
end

function SCOREBOARD:PerformLayout(width, height)
end

vgui.Register("JailbreakScoreboard", SCOREBOARD)
JB.scoreboard = {}

function JB.scoreboard:Show()
    if IsValid(self.scoreboardPanel) then
        self.scoreboardPanel:Show()

        return
    end

    self.scoreboardPanel = vgui.Create("JailbreakScoreboard")
    self.scoreboardPanel:SetSize(w, h)

    JB.scoreboard.Hide = function()
        self.scoreboardPanel:Hide()
    end
end

function GM:ScoreboardShow()
    JB.scoreboard:Show()
end

function GM:ScoreboardHide()
    JB.scoreboard:Hide()
end