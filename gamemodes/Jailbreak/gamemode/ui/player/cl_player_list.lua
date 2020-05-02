local PLAYERLIST = {}

function PLAYERLIST:Init()
    self:MakePopup()
    self.etiquettes = {}
    self.cols = 1 + math.floor(#player.GetAll() / 10)
    self.spacingX = 0
    self.spacingY = 32
    self.header = vgui.Create("Panel", self)
    self.footer = vgui.Create("PanelContainer", self)
    self.footer:SetCols(32)
    self.panel = vgui.Create("Panel", self)
    self.buttonHolder = vgui.Create("Panel", self.header)
    self.button = vgui.Create("JailbreakButton", self.buttonHolder)
    self.button.skew = 13
    self.selectedPlayers = {}

    function self.header:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 200))
        draw.DrawText("Choose Players", "Jailbreak_Font_72", 72, height - 72, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawRect(0, height - height * 0.01, width, height * 0.01, Color(255, 255, 255, 255))
    end

    function self.footer:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 200))
        draw.DrawRect(0, 0, width, height * 0.01, Color(255, 255, 255, 255))
    end

    for k, v in pairs(team.GetPlayers(TEAM_PRISONERS)) do
        local playerEtiquette = vgui.Create("PlayerEtiquette", self.panel)
        playerEtiquette:SetPlayer(v)

        playerEtiquette.button.DoClick = function()
            playerEtiquette.selected = not playerEtiquette.selected

            if playerEtiquette.selected then
                table.insert(self.selectedPlayers, v)
            else
                table.RemoveByValue(self.selectedPlayers, v)
            end

            self:UpdateSelected()
        end

        table.insert(self.etiquettes, playerEtiquette)
    end

    self:UpdateSelected()

    self.button:SetClick(function()
        if #self.selectedPlayers == 0 then
            self.selectedPlayers = team.GetPlayers(TEAM_PRISONERS)
        end

        net.Start("GiveFreeDay")
        net.WriteTable(self.selectedPlayers)
        net.SendToServer()
        self:Remove()
    end)
end

function PLAYERLIST:UpdateSelected()
    self.footer:ClearPanel()

    for k, v in pairs(self.selectedPlayers) do
        local playerIcon = vgui.Create("SpectatorCard", self.footer)
        playerIcon:SetSize(84, 84)
        playerIcon.color = Color(0, 255, 150, 255)
        playerIcon:Player(v)
        self.footer:AddPanel(playerIcon)
    end

    self.button.color = Color(0, 255, 150)

    if #self.selectedPlayers > 0 then
        self.button.text = "Give " .. #self.selectedPlayers .. " selected freeday"
    else
        self.button.text = "Give everyone freeday"
    end
end

function PLAYERLIST:PerformLayout(width, height)
    self.buttonHolder:SetWide(480)
    self.button:SetSize(460, 56)
    self.button:Center()
    self.button:AlignRight(12)
    self.button:AlignBottom(12)
    self.buttonHolder:Dock(RIGHT)
    self.header:Dock(TOP)
    self.footer:Dock(BOTTOM)
    self.header:SetTall(128)
    self.footer:SetTall(72)
    local totalWid = 0
    local rows = math.floor(#self.etiquettes / self.cols) + 1
    local split = self.panel:GetWide() / self.cols
    self.panel:SetSize(300 * self.cols + rows * 32, height - 256 - 128)
    self.panel:SetPos(0, 128)
    self.panel:Center()

    for k, v in pairs(self.etiquettes) do
        local row = math.floor((k - 1) / self.cols)
        v:SetSize(split - self.spacingX / 2 - rows * v.skew, 64 - self.spacingY / 4)
        v:SetPos(totalWid + self.spacingX / 4 - v.skew * row + rows * v.skew, row * 72 + self.spacingY / 4)
        totalWid = (totalWid + split) % self.panel:GetWide()
    end
end

function PLAYERLIST:Paint(width, height)
    draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 200))
end

vgui.Register("PlayerList", PLAYERLIST)
JB.playerList = {}

function JB.playerList:Show()
    self.list = vgui.Create("PlayerList")
    self.list:SetSize(w, h)

    JB.playerList.Hide = function()
        self.list:Remove()
        self.list:Clear()
    end
end

function JB:OpenPlayerList()
    JB.playerList:Show()
end

function JB:ClosePlayerList()
    JB.playerList:Hide()
end