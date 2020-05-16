local KILLFEEDBAR = {}

local mats = {
    ARROW = Material("jailbreak/vgui/icons/arrow.png")
}

surface.CreateFont("Jailbreak_Font_28", {
    font = "Optimus",
    extended = false,
    size = 22,
    weight = 5,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = true,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false
})

function KILLFEEDBAR:Init()
    self.progress = 0
    self.panel = vgui.Create("Panel", self)
    self.murdererName = vgui.Create("DLabel", self.panel)
    self.murdererContainer = vgui.Create("DPanel", self.panel)
    self.murdererIcon = vgui.Create("JailbreakPlayerIcon", self.murdererContainer)
    self.arrow = vgui.Create("DPanel", self.panel)
    self.victimContainer = vgui.Create("DPanel", self.panel)
    self.victimIcon = vgui.Create("JailbreakPlayerIcon", self.victimContainer)
    self.victimName = vgui.Create("DLabel", self.panel)
    self.victimName:SetFont("Jailbreak_Font_28")
    self.murdererName:SetFont("Jailbreak_Font_28")

    function self.arrow:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(255, 255, 255), mats.ARROW)
    end
end

function KILLFEEDBAR:StartEntryAnimation()
    LerpFloat(1, 0, 0.2, function(prog)
        self.panel:SetPos(0, -self:GetTall() * prog)
    end, INTERPOLATION.SinLerp, function()
        timer.Simple(5, function()
            self:StartExitAnimation()
        end)
    end)
end

function KILLFEEDBAR:StartExitAnimation()
    LerpFloat(0, 1, 0.5, function(prog)
        self.panel:SetPos(self:GetWide() * prog, 0)
    end, INTERPOLATION.CosLerp, function()
        self:Remove()
    end)
end

function KILLFEEDBAR:PerformLayout(width, height)
    self.victimContainer:Dock(LEFT)
    self.victimContainer:SetSize(52, height)
    self.victimName:Dock(LEFT)
    self.victimName:DockMargin(8, 0, 0, 0)
    self.arrow:SetSize(52, height)
    self.arrow:Dock(LEFT)
    self.panel:SetSize(width, height)
    self.murdererName:Dock(LEFT)
    self.murdererContainer:Dock(LEFT)
    self.murdererContainer:DockMargin(8, 0, 0, 0)
    self.murdererContainer:SetSize(52, height)
end

function KILLFEEDBAR:AssignPlayers(victim, murderer)
    self.victim = victim
    self.murderer = murderer
    self.victimIcon:SetPlayer(self.victim)
    self.murdererIcon:SetPlayer(self.murderer)
    self.victimName:SetText(self.victim:GetName())
    self.murdererName:SetText(self.murderer:GetName())
    self.victimName:SetColor(team.GetColor(victim:Team()))
    self.murdererName:SetColor(team.GetColor(murderer:Team()))
    self.victimName:SizeToContentsX(3)
    self.murdererName:SizeToContentsX(3)
    local murdererColor = team.GetColor(murderer:Team())
    local victimColor = team.GetColor(victim:Team())

    function self.victimContainer:Paint(width, height)
        draw.SkweredChamferedBox(0, height / 2, width, height, 2, 3.5, victimColor)
    end

    function self.victimContainer:PerformLayout(width, height)
        self:GetParent():GetParent().victimIcon:SetSize(width - 4, height - 4)
        self:GetParent():GetParent().victimIcon:SetPos(2, 2)
    end

    if self.victim == self.murderer then
        self.murdererContainer:AlphaTo( 0, 0, 0 )
        self.murdererName:AlphaTo( 0, 0, 0 )
      
    end

    function self.murdererContainer:Paint(width, height)
        draw.SkweredChamferedBox(0, height / 2, width, height, 2, 3.5, murdererColor)
    end

    function self.murdererContainer:PerformLayout(width, height)
        self:GetParent():GetParent().murdererIcon:SetSize(width - 4, height - 4)
        self:GetParent():GetParent().murdererIcon:SetPos(2, 2)
    end
end

vgui.Register("JailbreakKillFeedBar", KILLFEEDBAR)