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
    self.minutes = 5

end

function TIMESCALE:Paint(width, height)
    draw.DrawRect(0, 0, width, height, Color(25, 25, 25))
    surface.SetDrawColor(255, 255, 255)

    for i = 0, self.minutes - 1 do
        local offset = (self.step * i)
        surface.DrawLine(offset + self.center, height * 0.5, offset + self.center, height)

        for j = 1, 11 do
            surface.DrawLine(self.center + self.subStep * j + offset, height * 0.6 + (height * 0.1) * (j % 2), self.subStep * j + offset + self.center, height)

            if (j % 2 == 0 or self.minutes <= 5) then
                draw.DrawText(j * 5, "Jailbreak_Font_16", self.subStep * j + offset + self.center, 0, Color(255, 255, 255, 25), TEXT_ALIGN_CENTER)
            end
        end

        draw.DrawText(i .. ":00", "Jailbreak_Font_16", offset + self.center, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function TIMESCALE:PerformLayout(width, height)
    self.center = width / self.minutes / 12 / 2
    self.step = width / self.minutes
    self.subStep = self.step / 12
    self.panel:Dock(FILL)
end

function TIMESCALE:SetMinutes(minutes)
    self.minutes = minutes
end

vgui.Register("JailbreakTimeScale", TIMESCALE)