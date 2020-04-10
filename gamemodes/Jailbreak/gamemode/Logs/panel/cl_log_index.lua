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
        draw.DrawRect(0, 0, width, height, Color(25, 25, 25, 255))

        if #self:GetParent().logs > 0 then
            for i = 1, #self:GetParent().logs do
                draw.DrawRect(0, 0, width, height, JB:GetLogColor(self:GetParent().logs[i].Type))
            end
        end

        if self:IsHovered() then
            draw.DrawRect(0, 0, width, height, Color(255, 255, 255, 30))
        end

        draw.DrawRect(0, 0, width, height * 0.7, Color(40, 40, 40, 50))
    end

    self.panel.DoClick = function()
        hook.Run("LogClicked", self.player, self.index, self.playerInd)
    end
end

function LOGINDEX:PerformLayout(width, height)
    self.panel:Dock(FILL)
end

function LOGINDEX:SetInfo(logs, index, playerInd)
    self.logs = logs
    self.index = index
    self.playerInd = playerInd
    print(index)
    PrintTable(logs)
end

vgui.Register("JailbreakLogIndex", LOGINDEX)