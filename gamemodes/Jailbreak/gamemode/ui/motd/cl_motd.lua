local MOTD = {}

function MOTD:Init()
    self:MakePopup()
    self.background = vgui.Create("Panel", self)

    function self.background:Paint()
        Derma_DrawBackgroundBlur(self, 0)
    end

    self.header = vgui.Create("DPanel", self)
    self.body = vgui.Create("DPanel", self)
    self.footer = vgui.Create("DPanel", self)
end

function MOTD:PerformLayout(width, height)
    self.background:SetSize(width, height)
    self.header:Dock(TOP)
    self.body:Dock(FILL)
    self.footer:Dock(BOTTOM)
end

function MOTD:Paint(width, height)
end

function MOTD:Close()
    self:Clear()
    self:Remove()
end

vgui.Register("JailbreakMOTD", MOTD)
JB.motd = {}

function JB.motd:Show()
    self.motdPanel = vgui.Create("JailbreakMOTD")
    self.motdPanel:SetSize(w, h)

    JB.motd.Hide = function()
        self.motdPanel:Remove()
        self.motdPanel:Clear()
    end
end

function GM:ScoreboardShow()
    JB.motd:Show()
    RestoreCursorPosition()
end

function GM:ScoreboardHide()
    JB.motd:Hide()
    RememberCursorPosition()
end