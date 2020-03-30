surface.CreateFont("Jailbreak_Font_Area", {
    font = "Optimus",
    extended = false,
    size = 18,
    weight = 1,
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

local AREAINDICATOR = {}
local percent = 0

local Areas = {
    kos = "In KOS Area",
    roof = "On Roof",
    pharmacy = "In Pharmacy",
    field = "On Field",
    armory = "In Armory",
    pool = "In Pool",
    kitchen = "In Kitchen",
    toilets = "In Toilets",
    cafeteria = "In Cafeteria",
    gameRoom = "In Games Room",
    mainArea = "In Main Area",
    simonSays = "In Simon Says Machine",
    volley = "In Volley",
    basketball = "In Basket Ball",
    prison = "In Cell",
    club = "In Club"
}

function AREAINDICATOR:Init()
    self.zone = ""
    self.danger = false
    self.zoneTable = {}

    net.Receive("SendZone", function()
        self.zoneTable = net.ReadTable()
        self:ParseTable(self.zoneTable)
    end)
end

function AREAINDICATOR:ParseTable(zones)
    local inArmory = false
    local inKos = false
    self.danger = false

    for k, v in pairs(zones) do

        if v == "armory" then
            inArmory = true
            self.danger = true
        end

        if v == "kos" then
            inKos = true
            self.danger = true
        end

        if v == "prison" then
            self.zone = Areas[v]

            return
        elseif inArmory and inKos then
            self.zone = Areas["armory"]

            return
        else
            self.zone = Areas[v]

            return
        end
    end

    self.zone = "In Neutral Area"
end

function AREAINDICATOR:Paint(width, height)
    if not targetPlayer or not targetPlayer:Alive() then
        percent = Lerp(FrameTime() * 5, percent, 0)
    else
        percent = Lerp(FrameTime() * 5, percent, 1)
    end

    draw.SkweredChamferedBox(0, 0, width, height + toVRatio(8), 0, 5, Color(255, 100, 0, 0 * percent))
    draw.DrawText(self.zone, "Jailbreak_Font_Area", toHRatio(0), -toVRatio(2),self.danger and Color(255, 0, 0, 200 * percent) or  Color(255, 255, 255, 200 * percent), TEXT_ALIGN_LEFT)
end

vgui.Register("AreaIndicator", AREAINDICATOR)