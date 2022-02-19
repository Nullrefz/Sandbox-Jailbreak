local PANELCONTAINER = {}

function PANELCONTAINER:Init()
    self.panel = vgui.Create("Panel", self)
    self.panels = {}
    self.spacingX = 4
    self.spacingY = 16
    self.cols = 1
end

function PANELCONTAINER:PerformLayout(width, height)
    local totalWid = 0

    if #self.panels > 0 then
        self.panel:SetSize(math.Clamp(#self.panels, 0, self.cols) * self.panels[1]:GetWide(), height)
    end

    local rows = math.floor(#self.panels / self.cols) + 1

    for k, v in pairs(self.panels) do
        local row = math.floor((k - 1) / self.cols)
        v:SetPos(totalWid, row * v:GetTall() - self.spacingY / 4)
        totalWid = (totalWid + v:GetWide()) % self.panel:GetWide()
    end

    self.panel:Center()
end

function PANELCONTAINER:SetCols(cols)
    self.cols = cols
end

function PANELCONTAINER:AddPanel(panel)
    table.insert(self.panels, panel)
    panel:SetParent(self.panel)
end

function PANELCONTAINER:ClearPanel()
    self.panels = {}
    self.panel:Clear()
end

vgui.Register("PanelContainer", PANELCONTAINER)