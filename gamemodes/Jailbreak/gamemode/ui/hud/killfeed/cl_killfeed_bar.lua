local KILLFEEDBAR = {}

function KILLFEEDBAR:Init()
    self.progress = 0
    self.victimIcon = vgui.Create("JailbreakPlayerIcon", self)
    self.murdererIcon = vgui.Create("JailbreakPlayerIcon", self)
end

function KILLFEEDBAR:Paint(width, height)
end

function KILLFEEDBAR:StartEntryAnimation()
    timer.Simple(5, function()
        self:Remove()
    end)
end

function KILLFEEDBAR:PerformLayout(width, height)
    self.victimIcon:SetSize(width / 4, height)
    self.murdererIcon:SetSize(width / 4, height)
    self.murdererIcon:AlignRight()
end

function KILLFEEDBAR:AssignPlayers(victim, murderer)
    self.victim = victim
    self.murderer = murderer
    self.victimIcon:SetPlayer(self.victim)
    self.murdererIcon:SetPlayer(self.murderer)
end

vgui.Register("JailbreakKillFeedBar", KILLFEEDBAR)