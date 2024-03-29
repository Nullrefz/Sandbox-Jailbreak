local SPECTATORCARD = {}

local mats = {
    ICON = Material("jailbreak/vgui/icon.png", "smooth")
}

function SPECTATORCARD:Init()
    self.color = Color(255, 220, 70)
end

function SPECTATORCARD:PerformLayout(width, height)
    -- Background
    self.background:SetSize(69, 69)
    self.background:Center()
    self.spectatorIcon:SetSize(51, 51)
    self.spectatorIcon:Center()
end

function SPECTATORCARD:Player(pl)
    if pl then
        self.ply = pl
        self:DrawSkin()
    else
        return self.ply
    end
end

function SPECTATORCARD:DrawSkin()
    self.background = vgui.Create("DImage", self)
    self.spectatorIcon = vgui.Create("CircularAvatar", self.background)
    self.spectatorIcon:Player(self.ply)
    self.background:SetImageColor(self.color)
    self.background:SetImage("jailbreak/vgui/Grey_Icon_small.png")
end

function SPECTATORCARD:SetColor(color)
    self.color = color
end
vgui.Register("SpectatorCard", SPECTATORCARD)