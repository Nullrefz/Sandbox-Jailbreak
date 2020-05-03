local VOTEBAR = {}

local mats = {
    BAR = Material("jailbreak/vgui/Bar.png", "smooth")
}


function VOTEBAR:Init()

    self.panel = vgui.Create("DPanel", self)

    function self.panel:Paint(width, height)
        draw.ChamferedBox(width / 2, height / 2, width, height, 3, Color(0, 0, 0))
    end

    self.container = vgui.Create("DPanel", self.panel)
    self.container.guardProgress = 0
    self.container.prisonnerProgress = 0
    self.container.guardPercentage = 0
    self.container.prisonersPercentage = 0

    function self.container:Paint(width, height)
        self.guardProgress = Lerp(FrameTime() * 5, self.guardProgress, self.guardPercentage)
        self.prisonnerProgress = Lerp(FrameTime() * 5, self.prisonnerProgress, self.prisonersPercentage)
        draw.ChamferedBox(width / 2, height / 2, width, height, 2, Color(26, 30, 33))
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)
        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_ZERO)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
        render.SetStencilReferenceValue(1)
        draw.ChamferedBox(width / 2, height / 2, width - 34, height, 2, Color(255, 255, 255))
        render.SetStencilFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilReferenceValue(1)

        if (#team.GetPlayers(TEAM_GUARDS) > 0) then
            DrawBar(0, width * 0.6, height, 3, #team.GetPlayers(TEAM_GUARDS), self.guardProgress, Color(0, 225, 255, 255), mats.Bar)
        end

        if (#team.GetPlayers(TEAM_PRISONERS) > 0) then
            DrawBar(self.guardProgress * width * 0.6, width * 0.4, height, 3, #team.GetPlayers(TEAM_PRISONERS), self.prisonnerProgress, Color(255, 150, 50, 255), mats.Bar)
        end

        render.SetStencilEnable(false)
        render.ClearStencil()
    end
end

function VOTEBAR:SetVotePercentage(guards, prisoners)
     self.container.guardPercentage = guards
     self.container.prisonersPercentage = prisoners
end

function VOTEBAR:PerformLayout(width, height)
    self.panel:SetSize(width * 0.8, height)
    self.panel:Center()
    local padding = 2
    self.container:SetSize(self.panel:GetWide() + 30, self.panel:GetTall() - toVRatio(padding))
    self.container:Center()
end

vgui.Register("VoteBar", VOTEBAR)