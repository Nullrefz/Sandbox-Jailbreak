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

surface.CreateFont("Jailbreak_Font_ScoreboardPlayerCount", {
    font = "Optimus",
    extended = false,
    size = 55,
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
    self.playerCards = {}
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

function SCOREBOARDGROUP:Think()
    if not self.group then return end

    if #team.GetPlayers(self.group) ~= #self.playerCards then
        self:ValidatePlayers()
    end
end

function SCOREBOARDGROUP:SetGroup(group)
    self.group = group
    self:DrawSkin()
end

function SCOREBOARDGROUP:CreatePlayer(ply)
    -- Players     
    local padding = toHRatio(145)
    local card = vgui.Create("PlayerCard", self.content)
    table.insert(self.playerCards, card)
    card:Player(ply)
    card:SetSize(toHRatio(200), toVRatio(230))
    card:SetPos(padding * (table.KeyFromValue(self.playerCards, card) - 1))
    -- LerpFloat(0, 1, 1, function(pos)
    --     if card and card:IsValid() then
    --         card:SetPos(padding * (table.KeyFromValue(self.playerCards, card) - 1) * pos    , 0)
    --     end
    -- end, INTERPOLATION.SmoothStep)
end

function SCOREBOARDGROUP:PositionCards()
    local padding = toHRatio(145)

    for k, v in pairs(self.playerCards) do
        v:SetPos(padding * k - 1)
    end
end

function SCOREBOARDGROUP:RemovePlayer(ply)
end

function SCOREBOARDGROUP:ValidatePlayers()
    for k, v in pairs(self.playerCards) do
        if not IsValid(v:Player()) or v:Player():Team() ~= self.group then
            v:Remove()
            table.remove(self.playerCards, k)
        end
    end
    self:PositionCards()
    for j, k in pairs(team.GetPlayers(self.group)) do
        for x, y in pairs(self.playerCards) do
            if IsValid(y:Player()) and y:Player() == k then break end
        end
        self:CreatePlayer(ply)
    end
end

function SCOREBOARDGROUP:DrawSkin()
    self.panel = vgui.Create("DPanel", self)
    self.panel:Dock(TOP)
    self.panel:DockMargin(0, 70, 0, 0)

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
    self.joinButton = vgui.Create("JoinButton", self.header)
    self.joinButton:SetTeam(self.group)
    self.joinButton:SetWide(toHRatio(100))
    self.joinButton:Dock(RIGHT)
    self.joinButton:DockMargin(-toHRatio(88), toVRatio(10), 0, toVRatio(5))
    self.teamCount = vgui.Create("DLabel", self.header)
    self.teamCount:SetFont("Jailbreak_Font_ScoreboardPlayerCount")
    self.teamCount:SetColor(Color(255, 255, 255, 255))
    self.teamCount:AlignRight()
    self.teamCount:SetWide(toHRatio(120))
    self.teamCount:SetPos(w - self.joinButton:GetWide() - self:GetWide() * 4, 0)
    self.teamCount:SetAutoStretchVertical(true)

    if self.group == TEAM_PRISONERS then
        self.titleText:SetText("Prisoners")
        self.teamCount:SetText(#team.GetPlayers(self.group) .. "/" .. game.MaxPlayers())
    elseif self.group == TEAM_GUARDS then
        self.titleText:SetText("Guards")
        self.teamCount:SetText(#team.GetPlayers(self.group) .. "/" .. allowedGuardCount)
    elseif self.group == TEAM_SPECTATORS then
        self.titleText:SetText("Spectators")
    end

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
        self:CreatePlayer(v)
    end

    -- Auto Size
    self.content:InvalidateLayout(true)
    self.content:SizeToChildren(false, true)
    self.panel:InvalidateLayout(true)
    self.panel:SizeToChildren(false, true)
end

vgui.Register("ScoreboardGroup", SCOREBOARDGROUP)