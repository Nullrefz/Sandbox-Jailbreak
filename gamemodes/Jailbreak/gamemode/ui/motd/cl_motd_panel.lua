local MOTDPANEL = {}

function MOTDPANEL:Init()
    self.panel = vgui.Create("DButton", self)
end
function MOTDPANEL:PerformLayout(width, height)
    self.panel:SetSize(width, height)
end
vgui.Register("MOTDPanel", MOTDPANEL)