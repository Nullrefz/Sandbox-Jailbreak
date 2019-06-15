local COMMANDBAR = {}
local mats = {
    Material("jailbreak/vgui/afk.png", "smooth"),
    Material("jailbreak/vgui/crouch.png", "smooth"),
    Material("jailbreak/vgui/mic.png", "smooth"),
    Material("jailbreak/vgui/walk.png", "smooth"),
    Material("jailbreak/vgui/freelook.png", "smooth"),
    Material("jailbreak/vgui/sprinting.png", "smooth"),
    Material("jailbreak/vgui/waypoint.png", "smooth"),
    Material("jailbreak/vgui/jumping.png", "smooth")
}

function COMMANDBAR:Init()
    self:UpdateInfo()
    self.panel = vgui.Create("Panel", self)
    self.panel:Dock(FILL)
    local slots = {}

    for i = 1, #mats do
        local lerp = 0
        table.insert(slots, lerp)
    end

    function self.panel:Paint(width, height)
        local totalWidth = 0
        for i = 0, #mats -  2 do
            if table.HasValue(activeCommands, i) then
                slots[i + 1] = math.Clamp(slots[i + 1] + FrameTime() * 10, 0, 1)
            else
                slots[i + 1] = math.Clamp(slots[i + 1] - FrameTime() * 10, 0, 1)
            end

            draw.DrawRect(totalWidth , 0, height * slots[i + 1], height, Color(255, 255, 255, 255 * slots[i + 1]), mats[i + 1])
            totalWidth = totalWidth + (height + 16) * slots[i + 1]
        end
    end
end

function COMMANDBAR:UpdateInfo()
   net.Start("RequestCommands")
   net.SendToServer()
end

vgui.Register("JailbreakCommandBar", COMMANDBAR)
