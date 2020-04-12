LOGBOX = {}

local mats = {
    PICKUP = Material("jailbreak/vgui/icons/pickup.png")
}

function LOGBOX:Init()
end

function LOGBOX:PerformLayout(width, height)
end

function LOGBOX:SetInfo(log)
    self.log = log
end

function LOGBOX:Paint(width, height)
    draw.ChamferedBox(width / 2, height / 2, width, height, 2, JB:GetLogColor(self.log.Type))
    draw.ChamferedBox(width / 2, height / 2, width - 2, height - 2, 2, Color(0, 0, 0, 220))
    draw.DrawRect(0, height / 2, width, height / 2, Color(30, 30, 30, 70))

end

vgui.Register("JailbreakLogBox", LOGBOX)