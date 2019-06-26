local JOINBUTTON = {}

surface.CreateFont("Jailbreak_Font_ScoreboardJoin", {
    font = "Optimus",
    extended = false,
    size = 34,
    weight = 5,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = true,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

function JOINBUTTON:SetTeam(group)
    self.team = group
    self:DrawSkin()
end

function JOINBUTTON:DrawSkin()
    local plyTeam = self.team

    self.panel = vgui.Create("DButton", self)
    self.panel:SetText("Join")
    self.panel:SetFont("Jailbreak_Font_ScoreboardJoin")
    self.panel:SetColor(Color(255, 255, 255))
    self.panel:SetAutoStretchVertical(true)

    function self.panel:Paint()
        return
    end

    self.panel.DoClick = function()
       net.Start("ChangeTeam")
       net.WriteInt(plyTeam, 32)
       net.SendToServer()
    end

    function self:Paint(width, height)
        if not self.team then return end

        if self.team == 1 then
            draw.SkweredChamferedBox(0, height / 2, width, height, 2, toHRatio(7) / 2, Color(255, 153, 0))
            draw.DrawSkewedRect(toHRatio(2), toVRatio(2), width - toHRatio(4), height - toVRatio(4), toHRatio(7), Color(239, 105, 0))
        elseif self.team == 2 then
            draw.SkweredChamferedBox(0, height / 2, width, height, 2, toHRatio(7) / 2, Color(0, 174, 239))
            draw.DrawSkewedRect(toHRatio(2), toVRatio(2), width - toHRatio(4), height - toVRatio(4), toHRatio(7), Color(0, 144, 255))
        end
    end

    function self:PerformLayout(width, height)
        self.panel:SetSize(width, height)
    end
end

vgui.Register("JoinButton", JOINBUTTON)