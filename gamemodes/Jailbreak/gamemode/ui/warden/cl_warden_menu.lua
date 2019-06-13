local WARDENMENU = {}
local mats = {Material("jailbreak/vgui/walk.png", "smooth"), Material("jailbreak/vgui/line up.png", "smooth"), Material("jailbreak/vgui/crouch.png", "smooth"), Material("jailbreak/vgui/afk.png", "smooth"), Material("jailbreak/vgui/jumping.png", "smooth"), Material("jailbreak/vgui/waypoint.png", "smooth"), Material("jailbreak/vgui/sprinting.png", "smooth"), Material("jailbreak/vgui/freelook.png", "smooth")}

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
    self.panel = vgui.Create("Panel", self)
    self.panel:MakePopup()
    self.thickness = 2
    self.alpha = 100
    self.anchor = -80
    self.radius = -self.anchor
    self.iconSize = 85
    self.iconRadius = 175
    self.textRadius = 275
    local panelAlpha = {}

    for i = 0, 7 do
        table.insert(panelAlpha, 0)
    end

    function self:Paint(width, height)
        self.width = 256
        draw.CapsuleBox(width / 2, height / 2, self.width, self.thickness, 360, 45 / 2, self.anchor, Color(255, 255, 255, self.alpha))
        draw.CapsuleBox(width / 2, height / 2, self.width, self.thickness, 360, 45 / 2 + 45, self.anchor, Color(255, 255, 255, self.alpha))
        draw.CapsuleBox(width / 2, height / 2, self.width, self.thickness, 360, 45 / 2 + 90, self.anchor, Color(255, 255, 255, self.alpha))
        draw.CapsuleBox(width / 2, height / 2, self.width, self.thickness, 360, 45 / 2 + 90 + 45, self.anchor, Color(255, 255, 255, self.alpha))
        draw.CapsuleBox(width / 2, height / 2, self.width, self.thickness, 360, 45 / 2 + 0 + 180, self.anchor, Color(255, 255, 255, self.alpha))
        draw.CapsuleBox(width / 2, height / 2, self.width, self.thickness, 360, 45 / 2 + 45 + 180, self.anchor, Color(255, 255, 255, self.alpha))
        draw.CapsuleBox(width / 2, height / 2, self.width, self.thickness, 360, 45 / 2 + 90 + 180, self.anchor, Color(255, 255, 255, self.alpha))
        draw.CapsuleBox(width / 2, height / 2, self.width, self.thickness, 360, 45 / 2 + 90 + 45 + 180, self.anchor, Color(255, 255, 255, self.alpha))
        draw.DrawArc(width / 2, height / 2, self.radius, self.radius - 3, 360, 0, Color(255, 255, 255, 255))
        draw.DrawArc(width / 2, height / 2, self.radius - 5, self.radius - 15, 360, 0, Color(255, 255, 255, self.alpha))
        local y = Vector(width / 2, height / 2, 0)
        local x = Vector(gui.MouseX(), gui.MouseY(), 0)
        x:Sub(y)

        for i = 0, 7 do
            local a = math.rad((i / 8) * 360 - 45)
            local str = string.GetFileFromFilename(mats[i + 1]:GetName())
            draw.DrawRect(width / 2 - self.iconSize / 2 + math.sin(a) * self.iconRadius, height / 2 - self.iconSize / 2 + math.cos(a) * self.iconRadius, self.iconSize, self.iconSize, Color(255, 255, 255), mats[i + 1])
            draw.DrawText(str:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end), "Jailbreak_Font_WardenMenu", width / 2 + math.sin(a) * self.textRadius, height / 2 + math.cos(a) * self.textRadius - 42 / 2, Color(255, 255, 255, 180), TEXT_ALIGN_CENTER)
            print(panelAlpha[i])
            if i == math.floor(x:Angle().yaw / 360 * 8 + 0.5) % 8 then
                panelAlpha[i] = math.Clamp(panelAlpha[i] + FrameTime(), 0, 10)
            else
                panelAlpha[i] = math.Clamp(panelAlpha[i] - FrameTime(), 0, 10)
            end

            draw.DrawArc(width / 2, height / 2, 250, self.radius, 45, i * 45 + 45 / 2, Color(0, 180, 255, self.panelAlpha[i]))
        end

        LocalPlayer():ChatPrint(math.floor(x:Angle().yaw / 360 * 8 + 0.5) % 8)
        draw.DrawArc(width / 2, height / 2, width, self.radius, 45, math.floor((-x:Angle().yaw + 90 - 45 / 2) / (360 / 8)) * 45 + 45 / 2, Color(0, 180, 255, 10))
    end
end

function WARDENMENU:PerformLayout(width, height)
    self.panel:SetSize(width, height)
end

vgui.Register("JailbreakWardenMenu", WARDENMENU)
JB.ShowMenu = {}

function JB.ShowMenu:Show()
    self.menu = vgui.Create("JailbreakWardenMenu")
    self.menu:SetSize(w, h)
    self.menu:SetPos(0, 0)

    JB.ShowMenu.Hide = function()
        self.menu:Remove()
        self.menu:Clear()
    end
end

function GM:ScoreboardShow()
    JB.ShowMenu:Show()
end

function GM:ScoreboardHide()
    JB.ShowMenu:Hide()
end