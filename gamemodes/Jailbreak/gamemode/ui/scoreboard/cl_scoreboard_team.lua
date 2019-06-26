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

surface.CreateFont("Jailbreak_Font_46", {
    font = "Optimus",
    extended = false,
    size = 46,
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
    self.panelWidth = 0
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

    if #team.GetPlayers(self.group) ~= #self.playerCards and self.group ~= Team.SPECTATORS then
        self:ValidatePlayers()
    end

    if self:IsChildHovered() and self.panelWidth > self:GetWide() then
        self:AdjustScroll()
    end
end

function SCOREBOARDGROUP:AdjustScroll()
    self.container:SetPos(Lerp(FrameTime() * 5, self.container:GetPos(), (-self.panelWidth - 55 + (self:GetWide())) * (gui.MousePos() / (self:GetWide() - 50)) + 25, 0, 0, 0))
end

function SCOREBOARDGROUP:SetGroup(group)
    self.group = group
    self:DrawSkin()
end

function SCOREBOARDGROUP:CreateSpectator(ply)
    local card = vgui.Create("SpectatorCard", self.container)
    --table.insert(self.playerCards, card)
    card:Player(ply)
    card:Dock(LEFT)
    card:SetSize(128, 128)
end

function SCOREBOARDGROUP:CreatePlayer(ply)
    if ply:Team() == 1002 then
        self:CreateSpectator(ply)

        return
    end

    -- Players
    -- local padding = toHRatio(145)
    local card = vgui.Create("PlayerCard", self.container)
    table.insert(self.playerCards, card)
    card:Player(ply)
    card:SetSize(toHRatio(200), toVRatio(230))
    -- card:SetPos(padding * (table.KeyFromValue(self.playerCards, card) - 1))
    -- LerpFloat(0, 1, 1, function(pos)
    --     if card and card:IsValid() then
    --         card:SetPos(padding * (table.KeyFromValue(self.playerCards, card) - 1) * pos    , 0)
    --     end
    -- end, INTERPOLATION.SmoothStep)
end

function SCOREBOARDGROUP:PositionCards()
    local padding = toHRatio(55)
    self.panelWidth = 0

    table.sort(self.playerCards, function(a, b) return a:Player():Health() > b:Player():Health() end)
    -- self.container:SetWide(toHRatio(200 + 55) * #team.GetPlayers(self.group))
    -- self.container:SetTall(math.floor(#self.playerCards / 13 + 1) * toVRatio(235))
    for k, v in pairs(self.playerCards) do
        v:SetParent(self.container)
        --v:SetParent(nil)
        local wide = (v:GetWide() - padding)
        -- v:SetPos(wide * ((k % 13) - 1) + math.floor(k / 13) * wide, math.floor(k / 13) * v:GetTall() + math.floor(k / 13) * 5 )
        v:SetPos(wide * (k - 1), 0)
        self.panelWidth = self.panelWidth + wide
    end
end

function SCOREBOARDGROUP:ValidatePlayers()
    for k, v in pairs(self.playerCards) do
        if not IsValid(v:Player()) or v:Player():Team() ~= self.group then
            v:Remove()
            table.remove(self.playerCards, k)
        end
    end

    if #team.GetPlayers(self.group) ~= #self.playerCards then
        local players = team.GetPlayers(self.group)

        for k, v in pairs(self.playerCards) do
            if table.HasValue(players, v:Player()) then
                table.RemoveByValue(players, v:Player())
            end
        end

        for k, v in pairs(players) do
            self:CreatePlayer(v)
        end
    end

    self:PositionCards()
end

function SCOREBOARDGROUP:DrawSkin()
    self.panel = vgui.Create("Panel", self)
    self.panel:Dock(TOP)
    self.panel:DockMargin(0, 70, 0, 0)
    -- Header
    self.header = vgui.Create("DPanel", self.panel)
    self.header:Dock(TOP)
    self.header:DockMargin(toHRatio(61), 0, toHRatio(61), 0)

    function self.header:Paint(width, height)
        --   draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 0))
    end

    self.titleText = vgui.Create("DLabel", self.header)

    if self.group ~= Team.SPECTATORS then
        self.titleText:SetFont("Jailbreak_Font_ScoreboardTitle")
    else
        self.titleText:SetFont("Jailbreak_Font_46")
    end

    self.titleText:SetColor(Color(255, 255, 255, 255))

    if self.group ~= Team.SPECTATORS then
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
    end

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
    self.content = vgui.Create("Panel", self.panel)
    self.content:Dock(TOP)
    self.content:DockMargin(0, toVRatio(4), 0, 0)
    self.container = vgui.Create("Panel", self.content)
    local group = self.group == Team.SPECTATORS and 1002 or self.group

    for k, v in pairs(team.GetPlayers(group)) do
        self:CreatePlayer(v)
    end

    if self.group ~= Team.SPECTATORS then
        self.container:SetWide(toHRatio(200 + 55) * #team.GetPlayers(self.group))
        self.container:SetTall(toVRatio(235))
        self:PositionCards()
    else
        self.container:SetWide(toHRatio(128) * #team.GetPlayers(1002))
        self.container:SetTall(toVRatio(128))

        self.content:DockMargin(64, toVRatio(4), 0, 0)
    end

    -- Auto Size
    self.content:InvalidateLayout(true)
    self.content:SizeToChildren(false, true)
    self.container:InvalidateLayout(true)
    self.container:SizeToChildren(false, true)
    self.panel:InvalidateLayout(true)
    self.panel:SizeToChildren(false, true)
end

vgui.Register("ScoreboardGroup", SCOREBOARDGROUP)