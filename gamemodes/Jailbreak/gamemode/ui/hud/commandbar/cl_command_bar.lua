local COMMANDBAR = {}

function COMMANDBAR:Init()
    self:UpdateInfo()
    self.panel = vgui.Create("Panel", self)
    self.panel:Dock(FILL)
    local slots = {}
    local mats = {}

    for i = 1, #commandType do
        local lerp = 0
        table.insert(slots, lerp)
        print(commandType[i])
        mats[i] = Material("jailbreak/vgui/icons/" .. commandType[i] .. ".png", "smooth")
    end

    function self.panel:Paint(width, height)
        local totalWidth = 0

        for i = 1, #slots do
            if table.HasValue(activeCommands, i) then
                slots[i] = math.Clamp(slots[i] + FrameTime() * 10, 0, 1)
            else
                slots[i] = math.Clamp(slots[i] - FrameTime() * 10, 0, 1)
            end

            draw.DrawRect(totalWidth, 0, height * slots[i], height, Color(255, 255, 255, 255 * slots[i]), mats[i])
            totalWidth = totalWidth + (height + 16) * slots[i]
        end
    end
end

function COMMANDBAR:UpdateInfo()
    net.Start("RequestCommands")
    net.SendToServer()
end

vgui.Register("JailbreakCommandBar", COMMANDBAR)