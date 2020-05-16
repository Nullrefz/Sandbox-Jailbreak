local TIMESCALE = {}

surface.CreateFont("Jailbreak_Font_16", {
    font = "Optimus",
    extended = false,
    size = 16,
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

function TIMESCALE:Init()
    self.panel = vgui.Create("Panel", self)
end

function TIMESCALE:Paint(width, height)
    if not self.time then return end
    self.minutes = math.ceil(self.time / 60)
    self.splits = 60 / self.minutes
    self.divisions = 1

    if self.time <= 10 then
        self.divisions = 0
    elseif self.time <= 60 then
        self.divisions = 1
    elseif self.time <= 120 then
        self.divisions = 2
    elseif self.time <= 300 then
        self.divisions = 6
    else
        self.divisions = 12
    end

    self.subStep = math.Clamp(self.splits / 12 * self.divisions, 1, 1000)
    self.bars = math.ceil(self.time / 60 * self.splits) / self.subStep
    self.step = width / self.bars
    draw.DrawRect(0, 0, width, height, Color(25, 25, 25))
    self.center =   width / math.ceil(self.time / 60 * self.splits) / 2
    surface.SetDrawColor(255, 255, 255)

    for i = 0, self.bars do
        local offset = (self.step * i)
        surface.DrawLine(offset + self.center, height * 0.5, offset + self.center, height)

        for j = 1, self.subStep - 1 do
            local offset = (self.step * i + self.step * j / self.subStep)
            surface.DrawLine(offset + self.center, height * 0.6 + (height * 0.1) * (j % 2), offset + self.center, height)

            if (j % 2 == 0 or self.minutes <= 5) then
                draw.DrawText(math.ceil(j / self.subStep) * i * self.subStep + j, "Jailbreak_Font_16", offset + self.center, 0, Color(255, 255, 255, 25), TEXT_ALIGN_CENTER)
            end
        end

        draw.DrawText(SecondsToMinutes((i * self.minutes * self.subStep)), "Jailbreak_Font_16", offset + self.center, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function TIMESCALE:PerformLayout(width, height)
    -- self.step = width / self.minutes
    -- self.subStep = self.step / 12
    self.panel:Dock(FILL)
end

function TIMESCALE:SetMinutes(minutes)
    self.minutes = minutes
end

function TIMESCALE:SetTime(time)
    self.time = time
end

function TIMESCALE:GetMinute(normalizedValue)
    -- return SecondsToMinutes(math.floor(normalizedValue * 12 * self.minutes) * 5)
    return 1
end

function TIMESCALE:GetPos(value, scale)
    -- self.splits = 60 / self.minutes
    -- self.ticks = math.ceil(value / 60 * self.splits)
    -- local normalizedValue = math.floor(value / scale * 12 * self.minutes)
    -- return normalizedValue * scale / self.minutes / 12 + self.center
    return 0
end

vgui.Register("JailbreakTimeScale", TIMESCALE)