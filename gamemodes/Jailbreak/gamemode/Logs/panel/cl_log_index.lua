local LOGINDEX = {}

function LOGINDEX:Init()
    local alpha = 0
    self.player = nil
    self.panel = vgui.Create("DButton", self)
    self.panel:SetText("")
    self.index = 0
    self.playerInd = 0
    LerpFloat(0, 1, 1, function(progress)
        if not alpha then return end
        alpha = progress
    end, INTERPOLATION.SinLerp)

    function self.panel:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(30, 30, 30, alpha * 255))

        if self:IsHovered() then
        draw.DrawRect(0, 0, width, height, Color(255, 255, 255, alpha * 30))

        end
    end

    self.panel.DoClick = function()
        hook.Run("LogClicked", self.player, self.index, self.playerInd)
    end
end

function LOGINDEX:PerformLayout(width, height)
    self.panel:Dock(FILL)
end

function LOGINDEX:SetInfo(player, index, playerInd)
    self.player = player
    self.index = index
    self.playerInd = playerInd
end

vgui.Register("JailbreakLogIndex", LOGINDEX)