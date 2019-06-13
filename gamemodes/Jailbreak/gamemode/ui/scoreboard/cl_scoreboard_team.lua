local SCOREBOARDGROUP = {}

surface.CreateFont("Jailbreak_Font_ScoreboardTitle", {
    font = "Optimus",
    extended = false,
    size = 72,
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

function SCOREBOARDGROUP:Init()
end

function SCOREBOARDGROUP:PerformLayout(width, height)
    -- To be continued
    -- self.panel:SetTall(toVRatio(90))
    -- self.header:SetTall(toVRatio(90))
    -- self.panel:InvalidateLayout(true)
    -- self.panel:SizeToChildren(false, true)
    -- self.header:InvalidateLayout(true)
    -- self.header:SizeToChildren(false, true)
end

function SCOREBOARDGROUP:SetGroup(group)
    self.group = group
    self:DrawSkin()
end

function SCOREBOARDGROUP:CreatePlayer(index, ply)
    -- Players     
    local padding = toHRatio(145)
    self.card = vgui.Create("PlayerCard", self.content)
    self.card:Player(ply)
    self.card:SetSize(toHRatio(200), toVRatio(230))
    self.card:SetPos(padding * (index - 1), 0)
end

function SCOREBOARDGROUP:DrawSkin()
    self.panel = vgui.Create("DPanel", self)
    self.panel:Dock(TOP)
    self.panel:DockMargin(0,70,0,0)
    function self.panel:Paint(width, height)
        --  draw.DrawRect(0, 0, width, height, Color(0, 50, 0, 0))
    end

    -- Header
    self.header = vgui.Create("DPanel", self.panel)
    self.header:Dock(TOP)
    self.header:DockMargin(toHRatio(61), 0, toHRatio(10), 0)

    function self.header:Paint(width, height)
        --   draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 0))
    end

    self.titleText = vgui.Create("DLabel", self.header)
    self.titleText:SetFont("Jailbreak_Font_ScoreboardTitle")
    self.titleText:SetColor(Color(255, 255, 255, 255))

    if self.group == TEAM_PRISONERS then
        self.titleText:SetText("Prisoners")
    elseif self.group == TEAM_GUARDS then
        self.titleText:SetText("Guards")
    elseif self.group == TEAM_SPECTATORS then
        self.titleText:SetText("Spectators")
    end

    self.joinButton = vgui.Create("JoinButton", self.header)
    self.joinButton:SetTeam(self.group)
    self.joinButton:SetWide(toHRatio(100))
    self.joinButton:Dock(RIGHT)
    self.joinButton:DockMargin(-toHRatio(88), toVRatio(10), 0, toVRatio(5))
    self.titleDash = vgui.Create("DPanel", self.header)
    self.titleText:SetWide(toHRatio(500))
    self.titleText:SetTall(toVRatio(48))
    self.titleDash:SetTall(toVRatio(2))
    self.titleDash:Dock(BOTTOM)

    function self.titleDash:Paint(width, height)
        draw.DrawSkewedRect(0, 0, width, height, toHRatio(8), Color(83, 83, 83, 255))
        draw.DrawSkewedRect(0, 0, width, height, toHRatio(1), Color(255, 255, 255, 255))
    end

    self.header:InvalidateLayout(true)
    self.header:SizeToChildren(false, true)
    -- Content
    self.content = vgui.Create("DPanel", self.panel)
    self.content:Dock(TOP)
    self.content:DockMargin(0, toVRatio(4), 0, 0)

    function self.content:Paint()
    end

    for k, v in pairs(team.GetPlayers(self.group)) do
        self:CreatePlayer(k, v)
    end

    -- Auto Size
    self.content:InvalidateLayout(true)
    self.content:SizeToChildren(false, true)
    self.panel:InvalidateLayout(true)
    self.panel:SizeToChildren(false, true)
end

vgui.Register("ScoreboardGroup", SCOREBOARDGROUP)