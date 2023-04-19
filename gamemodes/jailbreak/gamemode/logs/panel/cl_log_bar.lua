local LOGBAR = {}

function LOGBAR:Init()
    self.bars = 0
    self.wide = 8
    self.spacing = 8
    self.barPool = vgui.Create("Panel", self)
    self.alpha = 0
    self.loga = {}
    self.ind = 0

    LerpFloat(0, 1, 1, function(progress)
        if not self.alpha then
            return
        end
        self.alpha = progress
    end, INTERPOLATION.SinLerp)
end

function LOGBAR:Paint(width, height)
    draw.DrawRect(0, 0, width * self.alpha, height, Color(20, 20, 20, 255 * self.alpha))
end

function LOGBAR:PerformLayout(width, height)
    self.center = width / self.bars / 2 - self.wide / 2
    self.step = width / self.bars
    self.subStep = self.step / 12

    if self.wide ~= width / self.bars - self.spacing then
        self.wide = width / self.bars - self.spacing
        self:LayoutBars(width, height)
    end
end

function LOGBAR:LayoutBars(width, height)
    self.barPool:Clear()

    for i = 0, self.bars - 1 do
        local bar = vgui.Create("JailbreakLogIndex", self.barPool)
        local offset = (self.step * i + self.spacing / 2)
        bar:SetPos(offset, height * 0.1)
        bar:SetSize(self.wide, height * 0.8)
        bar:SetInfo(self:GetIndexLog(i + 1), i, self.ind, self.inspector, self.minutes, self:GetPlayerAlive(i + 1))
    end

    self.barPool:Dock(FILL)
end

function LOGBAR:GetIndexLog(index)
    local logs = {}

    for k, v in pairs(self.logs) do
        if v.Time > ((index * self.minutes) - self.minutes) and v.Time < index * self.minutes then
            table.insert(logs, v)
        end
    end
    return logs
end

function LOGBAR:GetPlayerAlive(index)
    if (self.lifespanIndex == -1 or index <= self.lifespanIndex) then
        return true
    end
    return false
end

function LOGBAR:SetInfo(logs, time, lifespan, ind, inspector)
    self.logs = logs
    self.ind = ind
    self.minutes = math.ceil(time / 60)
    self.splits = 60 / self.minutes
    self.bars = math.ceil(time / 60 * self.splits)
    self.inspector = inspector
    self.lifespanIndex = lifespan == -1 and -1 or math.ceil(lifespan / 60 * self.splits)
end

vgui.Register("JailbreakLogBar", LOGBAR)
