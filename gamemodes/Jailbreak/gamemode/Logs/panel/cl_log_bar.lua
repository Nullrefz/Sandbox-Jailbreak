local LOGBAR = {}

function LOGBAR:Init()
    self.bars = 60
    self.wide = 8
end

function LOGBAR:Paint(width, height)
    draw.DrawRect(0, 0, width, height, Color(20, 20, 20, 255))

    for i = 0, self.bars - 1 do
        local offset = (self.step * i)
        draw.DrawRect(offset + self.center, height * 0.2 / 2, self.wide, height * 0.8, Color(30, 30, 30))
    end
end

function LOGBAR:PerformLayout(width, height)
    self.center = width / self.bars / 2 - self.wide / 2
    self.step = width / self.bars
    self.subStep = self.step / 12
    self.wide = width / self.bars - 8
end

vgui.Register("JailbreakLogBar", LOGBAR)