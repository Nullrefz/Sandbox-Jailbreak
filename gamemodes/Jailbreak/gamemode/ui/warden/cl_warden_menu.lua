local WARDENMENU = {}

surface.CreateFont("Jailbreak_Font_WardenMenu", {
    font = "Optimus",
    extended = false,
    size = 36,
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

function WARDENMENU:Init()
    self.UpdateInfo()
    self.slots = {}
    self.hookedMenu = {}
    self.menu = {}
    self.panel = vgui.Create("Panel", self)
    self.panel:MakePopup()
    self.thickness = 2
    self.alpha = 100
    self.anchor = -80
    self.radius = -self.anchor
    self.iconSize = 85
    self.iconRadius = 175
    self.textRadius = 275
    self.alphaLerp = 0
    self.remove = false
    local insideSelection = false
    local selection = 0

    function self:Paint(width, height)
        self.alphaLerp = math.Clamp(self.alphaLerp + FrameTime() * 10 * (self.remove and -1 or 1), 0, 1)
        height = height - height * (1 - self.alphaLerp) / 50

        if self.alphaLerp <= 0 then
            self:Remove()
            self:Clear()
        end

        self.width = 256
        draw.DrawArc(width / 2, height / 2, self.radius, self.radius - 3, 360, 0, Color(255, 255, 255, 255 * self.alphaLerp))
        draw.DrawArc(width / 2, height / 2, self.radius - 5, self.radius - 15, 360, 0, Color(255, 255, 255, self.alpha * self.alphaLerp))
        local y = Vector(width / 2, height / 2, 0)
        local x = Vector(gui.MouseX(), gui.MouseY(), 0)
        x:Sub(y)
        local segments = 360 / #self.slots
        local shiter = segments / 2 --CurTime() * 50
        selection = math.ceil(((x:Angle().yaw - shiter) % 360) / segments)
        local shift = 90 --+ CurTime() * 50

        for i = 1, #self.slots do
            draw.CapsuleBox(width / 2, height / 2 - 2, self.width, self.thickness, 360, -i * segments + shift + shiter, self.anchor, Color(255, 255, 255, self.alpha * self.alphaLerp))
            local angle = math.rad(-i * segments + shift - shiter + segments / 2)
            local str = self.slots[i].NAME

            if i == math.ceil(((x:Angle().yaw - shiter) % 360) / segments) and insideSelection then
                self.slots[i].ALPHA = math.Clamp(self.slots[i].ALPHA + FrameTime() * 100, 0, 25)
            else
                self.slots[i].ALPHA = math.Clamp(self.slots[i].ALPHA - FrameTime() * 100, 0, 25)
            end

            draw.DrawArc(width / 2, height / 2, width, self.radius, segments, -i * segments + shift - shiter, Color(255, 255, 255, self.slots[i].ALPHA))

            if self.slots[i].MAT then
                draw.DrawRect(width / 2 - self.iconSize / 2 + math.sin(angle) * self.iconRadius, height / 2 - self.iconSize / 2 + math.cos(angle) * self.iconRadius, self.iconSize, self.iconSize, table.HasValue(activeCommands, i) and Color(255, 255, 255, 255 * self.alphaLerp) or Color(self.slots[i].COLOR.r, self.slots[i].COLOR.g, self.slots[i].COLOR.b, self.slots[i].COLOR.a * self.alphaLerp), self.slots[i].MAT)
            end

            draw.DrawText(str:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end), "Jailbreak_Font_WardenMenu", width / 2 + math.sin(angle) * self.textRadius, height / 2 + math.cos(angle) * self.textRadius - 42 / 2, table.HasValue(activeCommands, i) and Color(255, 255, 255, 255 * self.alphaLerp) or Color(self.slots[i].COLOR.r, self.slots[i].COLOR.g, self.slots[i].COLOR.b, self.slots[i].COLOR.a * self.alphaLerp), TEXT_ALIGN_CENTER)
        end

        if y:Distance(Vector(gui.MouseX(), gui.MouseY(), 0)) > self.radius then
            self.panel:SetCursor("hand")
            insideSelection = true
        else
            self.panel:SetCursor("arrow")
            insideSelection = false
        end
    end

    function self:Think()
        if input.IsMouseDown(MOUSE_FIRST) then
            self.clicked = true
        end
    end

    function self:Exit()
        if not self.clicked then
            self.button:SendCommand(self.slots[selection].REALEASEACTION)
        end

        self.remove = true
    end

    self.button = vgui.Create("DButton", self.panel)
    self.button:Dock(FILL)
    self.button:SetText("")

    function self.button:Paint()
    end

    function self.button:DoClick()
        local slot = self:GetParent():GetParent().slots[selection]
        self:SendCommand(slot.ACTION, slot.CLOSE)
    end

    function self.button:SendCommand(action, close)
        if not insideSelection then return end

        if action then
            action()
        end

        if close then
            self:GetParent():GetParent():Exit()
        end
    end
end

function WARDENMENU:PerformLayout(width, height)
    self.panel:SetSize(width, height)
end

function WARDENMENU:UpdateInfo()
    net.Start("RequestCommands")
    net.SendToServer()
end

function WARDENMENU:AddSlot(name, action, color, close, releaseAction)
    local mat = Material("jailbreak/vgui/icons/" .. name .. ".png", "smooth")

    local slot = {
        NAME = name,
        ACTION = action,
        COLOR = color,
        ALPHA = 0,
        CLOSE = close,
        MAT = not mat:IsError() and mat
    }

    REALEASEACTION = releaseAction and releaseAction or action
    table.insert(self.slots, slot)
end

function WARDENMENU:HookMenu(menu)
    self.hookedMenu = menu
end

vgui.Register("JailbreakOptionMenu", WARDENMENU)