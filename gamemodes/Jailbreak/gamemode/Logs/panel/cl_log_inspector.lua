local LOGINSPECTOR = {}

function LOGINSPECTOR:Init()
    self.active = false
    self.barHeight = 0
    self.timeHeight = 16
end

function LOGINSPECTOR:SetActive(enabled)
    if self.active ~= enabled then
        LerpFloat(enabled and 0 or 1, enabled and 1 or 0, 0.2, function(progress)
            if not IsValid(self) then return end
            self:SetSize(self:GetWide(), self.barHeight * progress)
        end, INTERPOLATION.SinLerp)
    end

    self.active = enabled
end

function LOGINSPECTOR:SetInfo(barHeight, ind, plyInd, logs)
    self.logs = logs
    self.barHeight = barHeight
    self:LayoutBoxes()

    if self.active then
        self:SetSize(self:GetWide(), self.barHeight)
    end

    if self.plyInd == plyInd and self.index == ind then
        self:SetActive(not self.active)
    elseif self.plyInd ~= plyInd then
        self:SetActive(false)
    else
        self:SetActive(true)
    end

    if not self.plyInd then
        self.plyInd = plyInd
    end

    self.index = ind
end

local boxes = {}

function LOGINSPECTOR:LayoutBoxes()
    self:Clear()
    if not self.logs or #self.logs == 0 then return end
    local tall = 64 - 16
    local boxWidth = 128
    local boxHeight = 64

    for k, v in pairs(self.logs) do
        local pos = ((v.Time - self.index * 5) / 5) * self:GetWide()
        local offset = 0

        if #boxes > 0 then
            for i = 1, #boxes do
                if IsValid(boxes[i]) then
                    local x, y = boxes[i]:GetPos()

                    if boxes[i]:GetWide() / 2 + x > pos - boxWidth then
                        offset = offset + boxWidth / 2 + 4
                        tall = math.max(tall, 64 - 16 + offset)
                    end
                end
            end
        end

        local box = vgui.Create("JailbreakLogBox", self)
        box:SetSize(boxWidth, boxHeight)
        box:SetPos(pos - box:GetWide() / 2, 64 - 16 + offset)
        box:SetInfo(v)
        table.insert(boxes, box)
    end

    self.barHeight = self.barHeight + tall + 8
end

function LOGINSPECTOR:Paint(width, height)
    draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
    draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
    draw.DrawRect(0, 0, width, 2, Color(255, 255, 255, 20))
    draw.DrawRect(0, height - 2, width, 2, Color(255, 255, 255, 20))
    local posY = self.timeHeight

    for i = 1, 5 do
        self:DrawArrow((i - 1) * width / 5 - 10, posY, width / 5 + 5, posY, 10, Color(200, 200, 200, 255 / 7 * i))
    end

    self:DrawRoundTimeline(0, height / 2 - 4 * 2 - self.timeHeight, width, 4)
    self:DrawPlayerTimeline(0, posY, width, height)

    for i = 1, 5 do
        draw.DrawText(SecondsToMinutes(self.index * 5 + i - 1), "Jailbreak_Font_14", (i - 1) * width / 5 + 8, posY, Color(0, 0, 0), TEXT_ALIGN_LEFT)
    end
end

function LOGINSPECTOR:DrawRoundTimeline(x, y, width, height)
    --draw.DrawRect(x, y + height, width, height, Color(200, 200, 200, 30))
end

function LOGINSPECTOR:DrawPlayerTimeline(x, y, width, height)
    if not boxes or #boxes == 0 then return end
    local arrowWidth = 0

    for k, v in pairs(boxes) do
        if IsValid(v) then
            local posX, posY = v:GetPos()

            if boxes[k + 1] and boxes[k + 1].log.Type == v.log.Type then
                arrowWidth = arrowWidth + boxes[k + 1]:GetPos() - posX
            else
                self:DrawArrow(posX + v:GetWide() / 2 - 32 - 4 - arrowWidth, y, 64 + 8 + arrowWidth, self.timeHeight, 10, Color(20, 20, 20, 255))
                self:DrawArrow(posX + v:GetWide() / 2 - 32 - arrowWidth, y, 64 + arrowWidth, self.timeHeight, 10, JB:GetLogColor(v.log.Type))
            end

            draw.DrawRect(posX + v:GetWide() / 2, y + self.timeHeight, 1, y + 2 + posY - v:GetTall() / 2, JB:GetLogColor(v.log.Type))
            -- draw.DrawRect(pos, y + k * (64 + 4), 128, 64, 2, Color(255, 255, 255))
            -- draw.ChamferedBox(pos, y + 8, 16, 16, 90, JB:GetLogColor(v.Type))
            --  draw.ChamferedBox(pos, y + 8, 16 - 4, 12, 90, Color(50, 50, 50, 225))
        end
    end
end

function LOGINSPECTOR:DrawArrow(x, y, width, height, skew, color)
    draw.DrawSkewedRect(x + skew, y, width - skew * 2, height / 2, -skew, color)
    draw.DrawSkewedRect(x, y + height / 2, width, height / 2, skew, color)
    draw.DrawSkewedRect(x + skew, y, width - skew * 2, height / 2, -skew, Color(30, 30, 30, 75))
end

vgui.Register("JailbreakLogInspector", LOGINSPECTOR)