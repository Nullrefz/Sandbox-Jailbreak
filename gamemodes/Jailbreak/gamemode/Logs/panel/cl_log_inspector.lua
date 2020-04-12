local LOGINSPECTOR = {}

function LOGINSPECTOR:Init()
    self.active = false
    self.barHeight = 0
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

function LOGINSPECTOR:SetInfo(barHeight, ind, plyInd)
    self.barHeight = barHeight

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

function LOGINSPECTOR:Paint(width, height)
    draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
    draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
    draw.DrawRect(0, 0, width, 1, Color(0, 0, 0, 255))
    draw.DrawRect(0, height - height * 0.1, width, height * 0.1, Color(255, 255, 255, 255))

    for i = 0, 5 do
        draw.DrawRect(i * width / 5, 0, 1, height, Color(255, 255, 255, 255))
    end
end

vgui.Register("JailbreakLogInspector", LOGINSPECTOR)