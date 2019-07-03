local MUTEBUTTON = {}

local mats = {
    MUTED = Material("jailbreak/vgui/muted.png", "smooth"),
    UNMUTED = Material("jailbreak/vgui/unmuted.png", "smooth")
}

function MUTEBUTTON:PerformLayout(width, height)
    self.panel:SetSize(width, height)
    self.panel:SetPos(0, 0)
    self.panel:SetTextColor(Color(0, 0, 0, 0))
    self.panel:AlignBottom()
end

function MUTEBUTTON:MutePlayer(plytoMute)
    if plytoMute:IsMuted() then
        plytoMute:SetMuted(false)
    else
        plytoMute:SetMuted(true)
    end
end

function MUTEBUTTON:Player(pl)
    if pl then
        self.ply = pl
        self:DrawSkin()
    else
        return pl
    end
end

function MUTEBUTTON:DrawSkin()
    self.panel = vgui.Create("DButton", self)

    function self.panel:Paint()
        return
    end

    self.panel.DoClick = function()
        self:MutePlayer(self.ply)
    end

    function self:Paint(width, height)
        if not IsValid(self.ply) and not self.ply then return end
        draw.DrawRect(width * 0.1, height * 0.1, width - width * 0.1 * 2, height - height * 0.1 * 2, self.ply:IsMuted() and Color(255, 0, 0, 255) or Color(255, 255, 255, 255), self.ply:IsMuted() and mats.MUTED or mats.UNMUTED)
    end
end

vgui.Register("MuteButton", MUTEBUTTON)