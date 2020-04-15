LOGBOX = {}

local mats = {
    PICKUP = Material("jailbreak/vgui/icons/pickup.png", smooth)
}

function LOGBOX:Init()
end

function LOGBOX:PerformLayout(width, height)
end

function LOGBOX:SetInfo(log)
    self.log = log

    if self.log.Type == "Pickup" then
        self:DrawPickup(self.log)
    end
end

function LOGBOX:DrawPickup(log)
    local topPanel = vgui.Create("Panel", self)
    topPanel:Dock(TOP)
    topPanel:SetTall(16)
    topPanel:DockMargin(0, 0, 0, 0)

    function topPanel:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 150, 255, 150))
        draw.DrawText("Pickup", "Jailbreak_Font_16", width / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    local bottomPanel = vgui.Create("Panel", self)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:SetTall(16)
    bottomPanel:DockMargin(0, 0, 0, 0)

    function bottomPanel:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 150, 255, 20))
        draw.DrawText(string.gsub(log.Weapon, "weapon_jb_", ""), "Jailbreak_Font_16", width / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    local LeftSide = vgui.Create("Panel", self)
    LeftSide:Dock(FILL)
    local material = Material("jailbreak/vgui/weapons/" .. tostring(log.Weapon) .. ".png")
    local imgHeight = material:Height()
    local imgWidth = material:Width()
    function LeftSide:Paint(width, height)
        local imgWid = imgWidth / imgHeight * 64
        draw.DrawRect((width - imgWid) / 2, 0, imgWid, height, Color(255, 255, 255), material)
    end
end

function LOGBOX:Paint(width, height)
    draw.ChamferedBox(width / 2, height / 2, width, height, 2, JB:GetLogColor(self.log.Type))
    draw.DrawRect(0, height / 2, width, height / 2, Color(30, 30, 30, 70))
end

vgui.Register("JailbreakLogBox", LOGBOX)