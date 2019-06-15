local WARDENMENU = {}
local mats = {Material("jailbreak/vgui/walk.png", "smooth"), Material("jailbreak/vgui/mic.png", "smooth"), Material("jailbreak/vgui/crouch.png", "smooth"), Material("jailbreak/vgui/afk.png", "smooth"), Material("jailbreak/vgui/jumping.png", "smooth"), Material("jailbreak/vgui/waypoint.png", "smooth"), Material("jailbreak/vgui/sprinting.png", "smooth"), Material("jailbreak/vgui/freelook.png", "smooth")}

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
    --self.UpdateInfo()
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
    local panelAlpha = {}

    for i = 0, 7 do
        local num = 0
        table.insert(panelAlpha, i, num)
    end

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

        for i = 0, 7 do
            draw.CapsuleBox(width / 2, height / 2 - 2, self.width, self.thickness, 360, 45 / 2 + 45 * i, self.anchor, Color(255, 255, 255, self.alpha * self.alphaLerp))
            local angle = math.rad((i / 8) * 360 - 45)
            local str = string.GetFileFromFilename(mats[i + 1]:GetName())

            if i == math.floor(x:Angle().yaw / 360 * 8 + 0.5) % 8 and insideSelection then
                panelAlpha[i] = math.Clamp(panelAlpha[i] + FrameTime() * 100, 0, 25)
            else
                panelAlpha[i] = math.Clamp(panelAlpha[i] - FrameTime() * 100, 0, 25)
            end

            draw.DrawArc(width / 2, height / 2, width, self.radius, 45, -i * 45 + 45 / 2 + 45 + 0.5, Color(0, 180, 255, panelAlpha[i]))

            if i == 5 then
                draw.DrawRect(width / 2 - self.iconSize / 2 + math.sin(angle) * self.iconRadius, height / 2 - self.iconSize / 2 + math.cos(angle) * self.iconRadius, self.iconSize, self.iconSize, Color(255, 200, 0, 255 * self.alphaLerp), mats[i + 1])
                draw.DrawText(str:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end), "Jailbreak_Font_WardenMenu", width / 2 + math.sin(angle) * self.textRadius, height / 2 + math.cos(angle) * self.textRadius - 42 / 2,  Color(255, 200, 0, 255 * self.alphaLerp), TEXT_ALIGN_CENTER)

            else
                draw.DrawRect(width / 2 - self.iconSize / 2 + math.sin(angle) * self.iconRadius, height / 2 - self.iconSize / 2 + math.cos(angle) * self.iconRadius, self.iconSize, self.iconSize, table.HasValue(activeCommands, (-i + 3) % 8) and Color(255, 255, 255, 255 * self.alphaLerp) or Color(200, 200, 200, 180 * self.alphaLerp), mats[i + 1])
                draw.DrawText(str:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end), "Jailbreak_Font_WardenMenu", width / 2 + math.sin(angle) * self.textRadius, height / 2 + math.cos(angle) * self.textRadius - 42 / 2, table.HasValue(activeCommands, (-i + 3) % 8) and Color(255, 255, 255, 255 * self.alphaLerp) or Color(200, 200, 200, 180 * self.alphaLerp), TEXT_ALIGN_CENTER)

            end

        end

        selection = math.floor(x:Angle().yaw / 360 * 8 + 0.5) % 8

        if y:Distance(Vector(gui.MouseX(), gui.MouseY(), 0)) > self.radius then
            self.panel:SetCursor("hand")
            insideSelection = true
        else
            self.panel:SetCursor("arrow")
            insideSelection = false
        end
    end

    function self:Exit()
        --self.button:SendCommand()
        self.remove = true
    end

    self.button = vgui.Create("DButton", self.panel)
    self.button:Dock(FILL)
    self.button:SetText("")

    function self.button:Paint()
    end

    function self.button:DoClick()
        self:SendCommand()
    end

    function self.button:SendCommand()
        if not insideSelection then return end
        net.Start("SendWardenCommand")
        net.WriteInt(selection, 32)
        net.SendToServer()
    end
end

function WARDENMENU:PerformLayout(width, height)
    self.panel:SetSize(width, height)
end

function WARDENMENU:UpdateInfo()
    net.Start("RequestCommands")
    net.SendToServer()
end

vgui.Register("JailbreakWardenMenu", WARDENMENU)
JB.ShowMenu = {}

function JB.ShowMenu:Show()
    self.menu = vgui.Create("JailbreakWardenMenu")
    self.menu:SetSize(w, h)
    self.menu:SetPos(0, 0)

    JB.ShowMenu.Hide = function()
        self.menu:Exit()
    end
end

-- implement if player is warden
function GM:OnContextMenuOpen()
    JB.ShowMenu:Show()
end

function GM:OnContextMenuClose()
    JB.ShowMenu:Hide()
end