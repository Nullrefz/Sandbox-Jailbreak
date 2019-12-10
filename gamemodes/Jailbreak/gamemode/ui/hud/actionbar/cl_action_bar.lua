local ACTIONBAR = {}

function ACTIONBAR:Init()
    self:UpdateInfo()
    self.panel = vgui.Create("Panel", self)
    self.panel:Dock(FILL)
    local slots = {}
    local mats = {}

    for i = 1, #actionsMenu do
        local lerp = 0
        table.insert(slots, lerp)
        mats[i] = Material("jailbreak/vgui/icons/" .. actionsMenu[i] .. ".png", "smooth")
    end

    function self.panel:Paint(width, height)
        local totalHeight = 0

        for i = 1, #slots do
            if table.HasValue(activeActions, actionsMenu[i]) then
                slots[i] = math.Clamp(slots[i] + FrameTime() * 10, 0, 1)
            else
                slots[i] = math.Clamp(slots[i] - FrameTime() * 10, 0, 1)
            end

            draw.DrawRect(0, height / 2 - totalHeight, width, width * slots[i], Color(255, 255, 255, 150 * slots[i]), mats[i])
            totalHeight = totalHeight + (width + 8) * slots[i]
        end
    end
end

function ACTIONBAR:UpdateInfo()
    net.Start("RequestActions")
    net.SendToServer()
end

vgui.Register("JailbreakActionBar", ACTIONBAR)