local LRBAR = {}
local percent = 0

local mats = {
    SLASH = Material("jailbreak/vgui/slash.png")
}

function LRBAR:Init()
    self.lr = ""
    self:UpdateInfo()
    percent = 0

    net.Receive("SetLR", function()
        self.lastRequest:SetText(self.lr)
    end)

    function self:Paint(width, height)
        if warden and self.lr ~= "" then
            percent = Lerp(FrameTime() * 5, percent, 1)
        else
            percent = Lerp(FrameTime() * 5, percent, 0)
        end

            draw.DrawRect(0, height / 2 - toVRatio(64) / 2, toHRatio(32), toVRatio(64), Color(255, 255, 255, 150 * percent), mats.SLASH)
            draw.DrawText("Last request", "Jailbreak_Font_WardenTitle", toHRatio(10 + 32), height / 2 - toVRatio(30) / 2 - toVRatio(18) / 2, Color(255, 255, 255, 150 * percent), TEXT_ALIGN_LEFT)
            draw.DrawText(self.lr, "Jailbreak_Font_WardenName", toHRatio(5 + 32), height / 2 - toVRatio(30) / 2, Color(255, 255, 255, 200 * percent), TEXT_ALIGN_LEFT)
     end
end

function LRBAR:PerformLayout(width, height)
end

function LRBAR:UpdateInfo()
    --net.Start("RequestLR")
    --net.SendToServer()
end

vgui.Register("JailbreakLRBar", LRBAR)