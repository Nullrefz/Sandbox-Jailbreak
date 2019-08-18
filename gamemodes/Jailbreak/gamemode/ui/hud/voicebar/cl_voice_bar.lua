local VOICEBAR = {}

function VOICEBAR:Init()
    self.progress = 0
    self.active = true
    self.panel = vgui.Create("DPanel", self)
end

function VOICEBAR:PerformLayout(width, height)
    self.panel:SetSize(width, height)
end

function VOICEBAR:StartEntryAnimation()
    self.active = true
end

function VOICEBAR:AssignPlayer(ply)
    self.player = ply
end

function VOICEBAR:StartExitAnimation()
    self.active = false
    print("removing " .. self.player:Name() .. "'s voice panel")
end

vgui.Register("JailbreakVoiceBar", VOICEBAR)