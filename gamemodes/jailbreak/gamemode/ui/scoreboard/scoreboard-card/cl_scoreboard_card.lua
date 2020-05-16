local SCOREBOARDCARD = {}

local mats = {
    DEAD = Material("jailbreak/vgui/dead.png", "smooth")
}

surface.CreateFont("Jailbreak_Font_Name", {
    font = "Optimus",
    extended = false,
    size = 24,
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

surface.CreateFont("Jailbreak_Font_CardHealth", {
    font = "Optimus",
    extended = false,
    size = 22,
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

function SCOREBOARDCARD:PerformLayout(width, height)
    -- Background
    self.panel:SetSize(width, height)
    self.panel:SetPos(0, 0)
    -- Icon
    self.playerIconContainer:SetTall(toVRatio(128))
    self.playerIcon:SetSize(self.playerIconContainer:GetWide() - toHRatio(32), self.playerIconContainer:GetWide() - toVRatio(32))
    self.playerIcon:SetPos(toHRatio(29), -toHRatio(16))
    self.playerIcon:SetPlayer(self.ply, toVRatio(128))
    -- Name
    self.playerNameContainer:SetTall(32)
    self.playerName:SetSize(toHRatio(100), toVRatio(72))
    self.playerName:SetPos(width / 4.5, self.playerIconContainer:GetTall() + toVRatio(4))
    -- Health
    self.playerHealthContainer:SetSize(toHRatio(156), toVRatio(32))
    self.playerHealth:SetSize(toHRatio(156), toVRatio(32))
    -- Utilies
    local wid = 5
    self.muteButton:SetPos(toHRatio(wid), toVRatio(0))
    self.muteButton:SetSize(self.playerUtilContainer:GetTall(), self.playerUtilContainer:GetTall())
    wid = wid + self.muteButton:GetWide() + 2

    if IsValid(self.nominateButton) then
        self.nominateButton:SetSize(self.playerUtilContainer:GetTall() - 12, self.playerUtilContainer:GetTall() - 12)
        self.nominateButton:SetPos(toHRatio(wid), (self.playerUtilContainer:GetTall() - self.nominateButton:GetTall() - 2) / 2)
        wid = wid + self.nominateButton:GetWide()
    end

    self.pingPanel:SetSize(self.playerUtilContainer:GetTall() * 2, self.playerUtilContainer:GetTall())
    self.pingPanel:AlignRight()
    self.playerUtilContainer:SetSize(toHRatio(140), toVRatio(35))
    self.playerUtilContainer:AlignBottom()
end

function SCOREBOARDCARD:Player(pl)
    if pl then
        self.ply = pl
        self:DrawSkin()
    else
        return self.ply
    end
end

function SCOREBOARDCARD:DrawSkin()
    -- Main Container
    self:SetMouseInputEnabled(true)
    self.panel = vgui.Create("DPanel", self)
    self.panel:SetMouseInputEnabled(true)

    function self.panel:Paint(width, height)
        return
    end

    -- Player Icon
    self.playerIconContainer = vgui.Create("DPanel", self.panel)
    self.playerIconContainer:Dock(TOP)

    function self.playerIconContainer:Paint(width, height)
        return
    end

    self.playerIcon = vgui.Create("AvatarImage", self.playerIconContainer)
    self.playerIcon:SetPaintedManually(true)
    -- player Name
    self.playerNameContainer = vgui.Create("DPanel", self.panel)
    self.playerNameContainer:Dock(TOP)

    function self.playerNameContainer:Paint(width, height)
        return
    end

    self.playerName = vgui.Create("DLabel", self.panel)
    self.playerName:SetFont("Jailbreak_Font_Name")

    if self.ply then
        self.playerName:SetText(self.ply:Name())
    end

    self.playerName:SetAutoStretchVertical(true)
    self.playerName:SetContentAlignment(2)
    -- function self.playerName:Paint(width, height)
    --     draw.DrawText(
    --         self.ply:Name() .. "BigMelonQuanZing",
    --         "Jailbreak_Font_Health",
    --         width / 2,
    --         toVRatio(5),
    --         Color(255, 255, 255, 200),
    --         TEXT_ALIGN_CENTER
    --     )
    -- end
    -- Player Health
    self.playerHealthContainer = vgui.Create("DPanel", self.panel)
    self.playerHealthContainer:Dock(TOP)

    function self.playerHealthContainer:Paint(width, height)
        -- draw.DrawSkewedRect(0, 0, width, height, toHRatio(0), Color(255, 255, 255, 1))
    end

    self.playerHealth = vgui.Create("DPanel", self.playerHealthContainer)
    local user = self.ply

    function self.playerHealth:Paint(width, height)
        if not IsValid(user) then return end
        draw.DrawSkewedRect(toHRatio(12), 0, width - toHRatio(12), height, toHRatio(8), Color(83, 83, 83, 255))
        draw.DrawSkewedRect(toHRatio(12), 0, ((user:Health() + user:Armor()) / (user:GetMaxHealth() + user:Armor())) * (width - toHRatio(12)), height, toHRatio(8), Color(255, 255, 255, 255))

        if user:Alive() then
            draw.DrawText(tostring(user:Health() + user:Armor() .. "/" .. user:GetMaxHealth() + user:Armor()), "Jailbreak_Font_CardHealth", width / 2 + toHRatio(6), toVRatio(4), team.GetColor(user:Team()), TEXT_ALIGN_CENTER)
        else
            draw.DrawRect(width / 2 - 8, 0, 32, 32, Color(255, 255, 255, 255), mats.DEAD)
        end
    end

    -- Player Utilities
    self.playerUtilContainer = vgui.Create("DPanel", self.panel)

    function self.playerUtilContainer:Paint()
    end

    self.muteButton = vgui.Create("MuteButton", self.playerUtilContainer)
    self.muteButton:Player(self.ply)

    if self.ply:Team() == TEAM_GUARDS then
        self.nominateButton = vgui.Create("DImageButton", self.playerUtilContainer)
        self.nominateButton:SetImage("materials/jailbreak/vgui/icons/thumbsup.png")
        self.nominateButton.pressed = false

        self.nominateButton.DoClick = function()
            self.nominateButton.pressed = not self.nominateButton.pressed
            self.nominateButton:SetColor(self.nominateButton.pressed and Color(0, 150, 255) or Color(255, 255, 255))

            if self.nominateButton.pressed then
                JB:Denominate(self.ply)
            else
                JB:Nominate(self.ply)
            end
        end
    end

    self.pingPanel = vgui.Create("PingPanel", self.playerUtilContainer)
    self.pingPanel:Dock(RIGHT)
    self.pingPanel:Player(self.ply)

    function self:Paint(width, height)
        if not IsValid(self.ply) then return end
        --draw.DrawSkewedRect(0, 0, width, height, toHRatio(60), team.GetColor(self.ply:Team()))
        draw.SkweredChamferedBox(0, height / 2, width, height, 2, toHRatio(58) / 2, team.GetColor(user:Team()))

        if self:IsChildHovered() then
            draw.SkweredChamferedBox(0, height / 2, width, height, 2, toHRatio(58) / 2, Color(255, 255, 255, 255))
        end

        self.playerHealth:SetSize(toHRatio(156), toVRatio(32))
        draw.DrawSkewedRect(0 + toHRatio(3), 0 + toVRatio(3), width - toHRatio(6), height - toVRatio(6), toHRatio(58), (self.ply:Team() == TEAM_PRISONERS) and (Color(49, 44, 42, 255)) or Color(42, 44, 49, 255))
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)
        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_ZERO)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
        render.SetStencilReferenceValue(1)
        draw.DrawSkewedRect(0 + toHRatio(3), 0 + toVRatio(3), width - toHRatio(6), height - toVRatio(6), toHRatio(58), Color(255, 255, 255, 255))
        render.SetStencilFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilReferenceValue(1)
        self.playerIcon:PaintManual()
        render.SetStencilEnable(false)
        render.ClearStencil()
    end
end

vgui.Register("PlayerCard", SCOREBOARDCARD)