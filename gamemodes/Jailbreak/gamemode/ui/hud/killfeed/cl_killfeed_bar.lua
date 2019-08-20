local KILLFEEDBAR = {}

function KILLFEEDBAR:Init()
    self.progress = 0
    self.victimIcon = vgui.Create("JailbreakPlayerIcon", self)
    self.murdererIcon = vgui.Create("JailbreakPlayerIcon", self)
end

function KILLFEEDBAR:Paint(width, height)
end

function KILLFEEDBAR:StartEntryAnimation()
end

function KILLFEEDBAR:AssignPlayers(victim, murderer)
    self.victim = victim
    self.murderer = murderer
    self.victimIcon:SetPlayer(self.victim)
    self.murdererIcon:SetPlayer(self.murderer)
end

vgui.Register("JailbreakKillFeedBar", KILLFEEDBAR)