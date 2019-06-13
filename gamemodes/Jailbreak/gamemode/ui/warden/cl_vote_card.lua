local JAILBREAKWARDENCARD = {}

local mats = {
    BAR = Material("jailbreak/vgui/Bar.png", "smooth"),
    WARDEN = Material("jailbreak/vgui/Blue_Icon_Slot.png", "smooth")
}

surface.CreateFont("Jailbreak_Font_WardenName", {
    font = "Optimus",
    extended = false,
    size = 32,
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

surface.CreateFont("Jailbreak_Font_VoteButton", {
    font = "Optimus",
    extended = false,
    size = 36,
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

function JAILBREAKWARDENCARD:DrawSkin()
    local ply = self.ply
    self.panel = vgui.Create("DPanel", self)

    function self.panel:Paint(width, height)
    end

    self.icon = vgui.Create("DPanel", self.panel)

    function self.icon:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(255, 255, 255), mats.WARDEN)
    end

    self.playerIcon = vgui.Create("CircularAvatar", self.icon)
    self.playerIcon:Player(ply)
    self.playerName = vgui.Create("DPanel", self.panel)

    function self.playerName:Paint(width, height)
        draw.DrawText(ply:Name(), "Jailbreak_Font_WardenName", width / 2, 0, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER)
    end

    self.voteBar = vgui.Create("VoteBar", self.panel)
    self.voteButton = vgui.Create("DButton", self.panel)
    self.voteButton:SetText("Vote")
    self.voteButton:SetFont("Jailbreak_Font_VoteButton")
    self.voteButton:SetTextColor(Color(255, 255, 255, 225))
    self.voteButton.voted = false

    function self.voteButton:Paint(wid, hei)
        draw.RoundedBox(5, 0, 0, wid, hei, Color(50, 50, 50))
        draw.RoundedBox(4, 2, 2, wid - 4, hei - 4, self.voted and Color(75, 75, 75) or ((ply:Team() == TEAM_REBELS) and Color(0, 225, 255, 255) or Color(255, 150, 50, 255)))
        -- draw.DrawSkewedRect(0, 0, 50, hei, 0, Color(255, 255, 255, 255))
    end

    function self:SetVoted()
        self.voteButton.voted = true
    end

    function self.voteButton:DoClick()
        if not self.voted then
            self.CastVote()
        end

        self.voted = true
    end

    function self.voteButton:CastVote()
        net.Start("SendWardenVote")
        net.WriteString(ply:SteamID())
        net.SendToServer()
    end

    function self:SetVoteValue(guards, prisoners)
        self.voteBar:SetVotePercentage(guards / math.Clamp(#team.GetPlayers(TEAM_GUARDS), 1, #team.GetPlayers(TEAM_GUARDS)), prisoners / math.Clamp(#team.GetPlayers(TEAM_PRISONERS), 1, #team.GetPlayers(TEAM_PRISONERS)))
    end

    self:Layout(self:GetWide(), self:GetTall())
end

function JAILBREAKWARDENCARD:Layout(width, height)
    self.panel:SetSize(width, width)
    self.panel:Center()
    self.icon:Dock(TOP)
    local iconSize = 142
    self.icon:DockMargin((width / 2) - (toHRatio(iconSize) / 2), 0, (width / 2) - (toHRatio(iconSize) / 2), 0)
    self.icon:SetTall(toVRatio(iconSize))
    local iconOutline = 21
    self.playerIcon:Dock(FILL)
    self.playerIcon:DockMargin(iconOutline, iconOutline, iconOutline, iconOutline)
    self.playerName:Dock(TOP)
    self.playerName:SetTall(toVRatio(32))
    self.voteBar:Dock(TOP)
    self.voteButton:Dock(TOP)
    self.voteButton:SetTall(toVRatio(46))
    local buttonWide = 128
    self.voteButton:DockMargin((width / 2) - (toHRatio(buttonWide) / 2), toVRatio(20), (width / 2) - (toHRatio(buttonWide) / 2), 0)
end

function JAILBREAKWARDENCARD:Player(pl)
    if pl then
        self.ply = pl
        self:DrawSkin()
    else
        return self.ply
    end
end

vgui.Register("JailbreakWardenCard", JAILBREAKWARDENCARD)