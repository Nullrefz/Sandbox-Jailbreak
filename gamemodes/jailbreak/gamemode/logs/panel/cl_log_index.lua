local LOGINDEX = {}

function LOGINDEX:Init()
    local alpha = 0
    self.player = nil
    self.panel = vgui.Create("DButton", self)
    self.panel:SetText("")
    self.index = 0
    self.playerInd = 0
    self.playerAlive = true
    LerpFloat(0, 1, 1, function(progress)
        if not alpha then
            return
        end
        alpha = progress
    end, INTERPOLATION.SinLerp)

    function self.panel:Paint(width, height)
        draw.DrawRect(0, 0, width, height,
            self:GetParent().playerAlive and Color(30, 30, 30, 255) or Color(1, 1, 1, 255))
        local logCount = #self:GetParent().logs
        if logCount > 0 then
            for i = 1, logCount do
                local wid = width / logCount
                draw.DrawRect((i - 1) * wid, 0, (logCount > 1 and i ~= logCount) and wid - 1 or wid , height,
                JB:GetLogColor(self:GetParent().logs[i].Type))
            end
        end

        if self:IsHovered() then
            draw.DrawRect(0, 0, width, height, Color(255, 255, 255, 30))
        end

        draw.DrawRect(0, 0, width, height * 0.7, Color(40, 40, 40, 50))

        local status = self:GetParent().playerStatus
        if status and  self:GetParent().playerAlive and status ~= "Neutral" then
            draw.DrawRect(0, height - 2, width, 2, JB:GetStatusColor(status))
            draw.DrawRect(0, 0, width, 2, JB:GetStatusColor(status))
        end
    end

    self.panel.DoClick = function()
        hook.Run("LogClicked", self.index, self.playerInd, self.logs, self.minutes)
    end
end

function LOGINDEX:PerformLayout(width, height)
    self.panel:Dock(FILL)
end

function LOGINDEX:SetInfo(logs, index, playerInd, inspector, minutes, playerAlive, playerStatus)
    self.logs = logs
    self.index = index
    self.playerInd = playerInd
    self.inspector = inspector
    self.minutes = minutes
    self.playerAlive = playerAlive
    self.playerStatus = playerStatus
end

vgui.Register("JailbreakLogIndex", LOGINDEX)
