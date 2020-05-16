local ETIQUETTE = {}

function ETIQUETTE:Init()
    self.icon = vgui.Create("JailbreakPlayerIcon", self)
    self.skew = 14
    self.selected = false
    self.button = vgui.Create("DButton", self)
    self.button:SetText("")

    function self.button:Paint(width, height)
    end
end

function ETIQUETTE:Paint(width, height)
    if (self.selected) then
        draw.DrawSkewedRect(0, 0, width, height, self.skew, Color(0, 255, 150, 255))
    else
        draw.DrawSkewedRect(0, 0, width, height, self.skew, IsValid(self.player) and team.GetColor(self.player:Team()) or Color(0, 0, 0, 255))
    end

    draw.DrawSkewedRect(0, 0, width, height, self.skew, Color(0, 0, 0, 50))
    draw.DrawSkewedRect( self.icon:GetWide() - self.skew + 4, 2, width - 4 - self.icon:GetWide() + self.skew - 2, height - 4, self.skew, Color(0, 0, 0, 220))

    if self.button:IsHovered() then
        draw.DrawSkewedRect(0, 0, width, height, self.skew, Color(255, 255, 255, 10))
    end

    draw.DrawText(IsValid(self.player) and self.player:Name() or "", "Jailbreak_Font_46", self.icon:GetWide() , 0.1 * height, Color(255, 255, 255), TEXT_ALIGN_LEFT)
end

function ETIQUETTE:PerformLayout(width, height)
    self.button:SetSize(width, height)
    local layoutWid = 0
    self.icon:SetPos(layoutWid + 2, 2)
    self.icon:SetSize(height + self.skew - 4, height - 4)
    self.icon.skew = self.skew
    layoutWid = layoutWid + self.icon:GetWide()
end

function ETIQUETTE:SetPlayer(ply)
    self.player = ply
    self.icon:SetPlayer(ply)
end

vgui.Register("PlayerEtiquette", ETIQUETTE)