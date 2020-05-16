local BUTTTON = {}

function BUTTTON:Init()
    self.button = vgui.Create("DButton", self)
    self.button:SetText("")
    self.selected = false
    self.enabled = true
    self.text = "button"
    self.color = Color(255, 255, 255)
    self.skew = 20

    function self.button:Paint(width, height)
    end
end

function BUTTTON:Paint(width, height)
    if (self.selected) then
        draw.DrawSkewedRect(0, 0, width, height, self.skew, Color(0, 255, 150, 255))
    else
        draw.DrawSkewedRect(0, 0, width, height, self.skew, self.color)
    end

    draw.DrawSkewedRect(0, 0, width, height, self.skew, Color(0, 0, 0, 50))
    draw.DrawSkewedRect(2, 2, width - 4, height - 4, self.skew, Color(0, 0, 0, 220))

    if self.button:IsHovered() and self.enabled then
        draw.DrawSkewedRect(0, 0, width, height, self.skew, Color(255, 255, 255, 10))
    end

    draw.DrawText(self.text, "Jailbreak_Font_46", width / 2, (height - 46) / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER)
end

function BUTTTON:PerformLayout(width, height)
    self.button:SetSize(width, height)
end

function BUTTTON:SetEnabled(enabled)
    self.enabled = enabled
end

function BUTTTON:SetClick(action)
    self.button.DoClick = action
end
vgui.Register("JailbreakButton", BUTTTON)