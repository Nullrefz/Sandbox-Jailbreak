local LOGINSPECTOR = {}

function LOGINSPECTOR:Init()
    self.active = false
    self.barHeight = 0
    self.timeHeight = 16
    self.minutes = 1
    self.boxes = {}
end

function LOGINSPECTOR:SetActive(enabled, callback)
    if self.active ~= enabled then
        LerpFloat(enabled and 0 or 1, enabled and 1 or 0, 0.2, function(progress)
            if not IsValid(self) then
                return
            end
            self:SetSize(self:GetWide(), self.barHeight * progress)
        end, INTERPOLATION.SinLerp, function()
            if callback then
                callback()
            end
        end)
    end

    self.active = enabled
end

function LOGINSPECTOR:SetInfo(barHeight, ind, plyInd, logs, minutes)
    if (self.plyInd == plyInd) then
        self.logs = logs
        self.minutes = minutes
        self.barHeight = barHeight
    end
    if not self.plyInd then
        self.plyInd = plyInd
    end

    if self.plyInd ~= plyInd or self.index == ind then
        self:SetActive(false, function()
            if ind and self.index == ind then
                self.index = -1
            end
            table.Empty(self.boxes)

        end)
    else
        self:SetActive(true)
        self.index = ind
        self:LayoutBoxes()
        if self.active then
            self:SetSize(self:GetWide(), self.barHeight)
        end

    end

end

function LOGINSPECTOR:SetInit(barheight, ind)
    self.index = ind
    self.barHeight = barHeight
    -- self.plyInd = -1
end

function LOGINSPECTOR:LayoutBoxes()
    self:Clear()
    if not self.logs or #self.logs == 0 then
        return
    end
    local tall = 64 - 16
    local boxWidth = 400
    local boxHeight = 64

    for k, v in pairs(self.logs) do
        if (v.Type ~= "Status") then
            local pos = ((v.Time - self.index * self.minutes) / self.minutes) * self:GetWide()
            local offset = 0

            if #self.boxes > 0 then
                for i = 1, #self.boxes do
                    if IsValid(self.boxes[i]) then
                        local x, y = self.boxes[i]:GetPos()

                        if self.boxes[i]:GetWide() / 2 + x + 16 > pos - boxWidth then
                            offset = offset + boxHeight + 4
                            tall = math.max(tall, 64 - 16 + offset)
                        end
                    end
                end
            end

            local box = vgui.Create("JailbreakLogBox", self)
            box:SetSize(boxWidth, boxHeight)
            box:SetPos(pos - box:GetWide() / 2, 64 - 16 + offset)
            box:SetInfo(v)
            table.insert(self.boxes, box)
            offset = 0
        end
    end

    self.barHeight = self.barHeight + tall + 20
end

function LOGINSPECTOR:Paint(width, height)
    if not self.minutes then
        self.minutes = 1
    end

    draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
    draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
    draw.DrawRect(0, 0, width, 2, Color(255, 255, 255, 20))
    draw.DrawRect(0, height - 2, width, 2, Color(255, 255, 255, 20))
    local posY = self.timeHeight

    for i = 1, self.minutes do
        self:DrawArrow((i - 1) * width / self.minutes - 10, posY, width / self.minutes + self.minutes, posY, 10,
            Color(200, 200, 200, 255 / 7 * i))
    end

    self:DrawRoundTimeline(0, height / 2 - 4 * 2 - self.timeHeight, width, 4)
    self:DrawPlayerTimeline(0, posY, width, height)

    for i = 1, self.minutes do
        draw.DrawText(SecondsToMinutes(self.index * self.minutes + i - 1), "Jailbreak_Font_14",
            (i - 1) * width / self.minutes + 8, posY, Color(0, 0, 0), TEXT_ALIGN_LEFT)
    end
end

function LOGINSPECTOR:DrawRoundTimeline(x, y, width, height)
    -- draw.DrawRect(x, y + height, width, height, Color(200, 200, 200, 30))
end

function LOGINSPECTOR:DrawPlayerTimeline(x, y, width, height)
    if not self.boxes or #self.boxes == 0 then
        return
    end
    local arrowWidth = 0

    for k, v in pairs(self.boxes) do
        if IsValid(v) then
            local posX, posY = v:GetPos()

            self:DrawArrow(posX + v:GetWide() / 2 - 32 - 4 - arrowWidth, y, 64 + 8 + arrowWidth, self.timeHeight, 10,
                Color(20, 20, 20, 255))
            self:DrawArrow(posX + v:GetWide() / 2 - 32 - arrowWidth, y, 64 + arrowWidth, self.timeHeight, 10,
                JB:GetLogColor(v.log.Type))

            draw.DrawRect(posX + v:GetWide() / 2, y + self.timeHeight, 1, y + 2 + posY - v:GetTall() / 2,
                JB:GetLogColor(v.log.Type))

        end
    end
end

function LOGINSPECTOR:DrawArrow(x, y, width, height, skew, color)
    draw.DrawSkewedRect(x + skew, y, width - skew * 2, height / 2, -skew, color)
    draw.DrawSkewedRect(x, y + height / 2, width, height / 2, skew, color)
    draw.DrawSkewedRect(x + skew, y, width - skew * 2, height / 2, -skew, Color(30, 30, 30, 75))
end

vgui.Register("JailbreakLogInspector", LOGINSPECTOR)
