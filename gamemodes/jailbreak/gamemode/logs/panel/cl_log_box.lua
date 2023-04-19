local mats = {
    Door = Material("jailbreak/vgui/icons/opencelldoors.png", "smooth"),
    Arrow = Material("jailbreak/vgui/icons/arrow.png", "smooth")
}

LOGBOX = {}

function LOGBOX:Init()
end

function LOGBOX:PerformLayout(width, height)
end

function LOGBOX:SetInfo(log)
    self.log = log

    if self.log.Type == "Pickup" or self.log.Type == "Drop" then
        self:DrawPickup(self.log)
    elseif self.log.Type == "Doors" then
        self:DrawDoors(self.log)
    elseif self.log.Type == "Kill" or self.log.Type == "Death" then
        self:DrawKill(self.log)
    end
end

function LOGBOX:DrawPickup(log)
    self:DrawTitle(log)
    local bottomPanel = vgui.Create("Panel", self)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:SetTall(16)
    bottomPanel:DockMargin(0, 0, 0, 0)

    function bottomPanel:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 150, 255, 20))
        draw.DrawText(string.gsub(log.Weapon, "weapon_jb_", ""), "Jailbreak_Font_16", width / 2, -2,
            Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    local LeftSide = vgui.Create("Panel", self)
    LeftSide:Dock(FILL)
    local material = Material("jailbreak/vgui/weapons/" .. tostring(log.Weapon) .. ".png")
    local imgHeight = material:Height()
    local imgWidth = material:Width()
    function LeftSide:Paint(width, height)
        local imgWid = imgWidth / imgHeight * 72
        draw.DrawRect((width - imgWid) / 2, -12, imgWid, height + 32, Color(255, 255, 255), material)
    end
end

function LOGBOX:DrawDoors(log)
    self:DrawTitle(log)
    self:SetWide(64)
    self.image = vgui.Create("DPanel", self)
    self.image:Dock(FILL)
    local size = 32
    function self.image:Paint(width, height)
        draw.DrawRect(width / 2 - size / 2, height / 2 - size / 2 - 2, size, size, Color(255, 255, 255), mats.Door)
    end
end

function LOGBOX:DrawKill(log)
    -- self:DrawTitle(log)

    self.icon = vgui.Create("DPanel", self)
    self.icon:SetSize(64, 64)
    self.icon:Dock(RIGHT)
    self.icon:DockPadding(6, 6, 6, 6)
    self.victimIcon = vgui.Create("AvatarImage", self.icon)
    self.victimIcon:Dock(FILL)
    self.victim = player.GetBySteamID(log.Type == "Death" and log.Culprit or log.Victim)
    self.victimIcon:SetPaintedManually(true)
    if self.victim then
        self.victimIcon:SetPlayer(self.victim, 184)
    end
    function self.icon:Paint(width, height)
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)
        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_ZERO)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
        render.SetStencilReferenceValue(1)
        draw.ChamferedBox(width / 2, height / 2, width, height, 24, Color(255, 255, 255))
        render.SetStencilFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilReferenceValue(1)
        self:GetParent().victimIcon:PaintManual()

        render.SetStencilEnable(false)
        render.ClearStencil()
    end

    self.victimName = vgui.Create("DLabel", self)
    self.victimName:Dock(RIGHT)
    self.victimName:SetText(not self.victim and (log.Type == "Death" and log.Culprit or log.Victim) or
                                self.victim:Name())
    self.victimName:SetTextColor(Color(255, 255, 255))
    self.victimName:SetFont("Jailbreak_Font_32")
    self.victimName:SetWide(self.victimName:GetTextSize())
    self.victimName:DockPadding(8, 8, 8, 8)

    self.arrow = vgui.Create("DPanel", self)
    self.arrow:Dock(RIGHT)
    local size = 64
    function self.arrow:Paint(width, height)
        draw.DrawRect(width / 2 - size / 2, height / 2 - size / 2 - 2, size, size, Color(255, 255, 255), mats.Arrow)
    end
    self:SetWide(128 + self.victimName:GetWide())

    -- local LeftSide = vgui.Create("Panel", self)
    -- LeftSide:Dock(RIGHT)
    -- local material = Material("jailbreak/vgui/weapons/" .. tostring(log.Weapon) .. ".png")
    -- local imgHeight = material:Height()
    -- local imgWidth = material:Width()
    -- function LeftSide:Paint(width, height)
    --     local imgWid = imgWidth / imgHeight * 100
    --     draw.DrawRect((width - imgWid) / 2, -12, imgWid, height + 32, Color(255, 255, 255, 200), material)
    -- end

    -- local bottomPanel = vgui.Create("Panel", self)
    -- bottomPanel:Dock(BOTTOM)
    -- bottomPanel:SetTall(16)

    -- function bottomPanel:Paint(width, height)
    --     draw.DrawRect(0, 0, width, height, Color(0, 150, 255, 20))
    --     draw.DrawText(string.gsub(log.Weapon, "weapon_jb_", ""), "Jailbreak_Font_16", width / 2, -2,
    --         Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    -- end
end
function LOGBOX:DrawTitle(log)
    -- Title
    local topPanel = vgui.Create("Panel", self)
    topPanel:Dock(TOP)
    topPanel:SetTall(16)
    topPanel:DockMargin(0, 0, 0, 0)

    function topPanel:Paint(width, height)
        draw.DrawText(log.Type, "Jailbreak_Font_16", width / 2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

end
function LOGBOX:Paint(width, height)
    draw.ChamferedBox(width / 2, height / 2, width, height, 2, JB:GetLogColor(self.log.Type))
    draw.DrawRect(0, height / 2, width, height / 2, Color(30, 30, 30, 70))
end

vgui.Register("JailbreakLogBox", LOGBOX)
