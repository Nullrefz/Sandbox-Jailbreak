local ENTRYLOG = {}

surface.CreateFont("Jailbreak_Font_36", {
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

function ENTRYLOG:Init()
    self.playerName = vgui.Create("Panel", self)
    self.playerImage = vgui.Create("AvatarImage", self)
    self.log = vgui.Create("JailbreakLogBar", self)
    self.TeamColor = Color(255, 255, 255)
    self.playerText = "Player Name"
    local alpha = 0
    self.progress = 0
    self.id = 0

    LerpFloat(0, 1, 1, function(progress)
        if not IsValid(self) or not alpha then return end
        alpha = progress
        self.progress = alpha
    end, INTERPOLATION.SinLerp)

    local panel = self

    function self.playerName:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
        draw.DrawText(panel.playerText, "Jailbreak_Font_32", width - 8, height / 4, Color(255, 255, 255, 255 * alpha), TEXT_ALIGN_RIGHT)
        draw.DrawRect(0, 0, 4 * alpha, height, panel.TeamColor)
    end
end

function ENTRYLOG:PerformLayout(width, height)
    self.playerName:Dock(LEFT)
    self.playerName:DockMargin(0, 0, 2, 0)
    self.playerName:SetWide(1920 / 7 - 4 - height, 0, 2, 0)
    self.playerImage:Dock(LEFT)
    self.playerImage:DockMargin(0, 0, 2, 0)
    self.log:Dock(FILL)
end

function ENTRYLOG:SetInfo(steamID, plyTeam, name, logs, time, ind, inspector)
    self.ind = ind
    self.player = player.GetBySteamID(steamID)

    if player.GetBySteamID(steamID) then
        self.playerImage:SetPlayer(self.player, 184)
    end

    self.TeamColor = team.GetColor(plyTeam)
    self.playerText = name
    self.log:SetInfo(logs, time, self.ind, insepctor)
end

vgui.Register("JailbreakEntryLog", ENTRYLOG)