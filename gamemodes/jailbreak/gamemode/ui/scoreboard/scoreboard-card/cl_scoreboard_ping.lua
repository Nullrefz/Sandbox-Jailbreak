local PINGPANEL = {}

surface.CreateFont("Jailbreak_Font_Ping", {
    font = "Optimus",
    extended = false,
    size = 27,
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

local mats = {
    BAR1 = Material("jailbreak/vgui/bar1.png", "smooth"),
    BAR2 = Material("jailbreak/vgui/bar2.png", "smooth"),
    BAR3 = Material("jailbreak/vgui/bar3.png", "smooth"),
    BAR4 = Material("jailbreak/vgui/bar4.png", "smooth")
}

local padding = 0.65

function PINGPANEL:PerformLayout(width, height)
    self.pingBar:SetSize(height, height)
    self.pingBar:AlignRight()
end

function PINGPANEL:Player(pl)
    if pl then
        self.ply = pl
        self:DrawSkin()
    else
        return pl
    end
end

function PINGPANEL:DrawSkin()
    self.pingBar = vgui.Create("DPanel", self)
    self.ping = 0
    self.pingBar.strengh = 1
    self.pingBar.pingColor = Color(255, 0, 0, 255)

    function self.pingBar:Paint(width, height)
        draw.DrawRect(toHRatio(12), toVRatio(10), width * padding, height * padding - toVRatio(4), Color(150, 150, 150, 255), mats.BAR4)
        draw.DrawRect(toHRatio(12), toVRatio(10), width * padding, height * padding - toVRatio(4), self.pingColor, mats[tostring("BAR" .. self.strengh)])
    end

    function self:Paint(width, height)
        if IsValid(self.ply) then return end
        self.ping = self.ply:Ping()
        draw.DrawText(self.ping, "Jailbreak_Font_Ping", width / 2 - toHRatio(6) + toHRatio(15), height / 4 + toVRatio(-1), self.pingBar.pingColor, TEXT_ALIGN_RIGHT)

        if self.ping > PING["BEST"] and self.ping < PING["GOOD"] then
            self.pingBar.strengh = 4
            self.pingBar.pingColor = Color(0, 200, 0, 255)
        elseif self.ping > PING["GOOD"] and self.ping <= PING["MID"] then
            self.pingBar.strengh = 3
            self.pingBar.pingColor = Color(255, 184, 0, 255)
        elseif self.ping > PING["MID"] and self.ping <= PING["BAD"] then
            self.pingBar.strengh = 2
            self.pingBar.pingColor = Color(255, 120, 0, 255)
        end
    end
end

vgui.Register("PingPanel", PINGPANEL)