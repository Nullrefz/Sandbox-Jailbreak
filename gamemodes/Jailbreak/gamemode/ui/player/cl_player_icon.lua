local mats = {
    WARDEN = Material("jailbreak/vgui/DeepBlue_Icon_small.png", "smooth")
}

local PLAYERICON = {}

function PLAYERICON:Init()
    self.playerIcon = vgui.Create("AvatarImage", self)
    self.playerIcon:SetPaintedManually(true)
 
end

function PLAYERICON:PerformLayout(width, height)
    self.playerIcon:SetSize(width, height)
    self.playerIcon:SetPlayer(LocalPlayer(), 64)
end

function PLAYERICON:Paint(width, height)
    draw.DrawRect(0, 0, width, height, Color(255, 255, 255), mats.WARDEN)
    -- render.ClearStencil()
    -- render.SetStencilEnable(true)
    -- render.SetStencilWriteMask(1)
    -- render.SetStencilTestMask(1)
    -- render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    -- render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    -- render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    -- render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    -- render.SetStencilReferenceValue(1)
    -- draw.ChamferedBox(width / 2, height / 2, width - 2, height - 2, 60, Color(252, 255, 255))
    -- render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    -- render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    -- render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    -- render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    -- render.SetStencilReferenceValue(1)
    -- self.avatar:PaintManual()
    -- render.SetStencilEnable(false)
end

vgui.Register("JailbreakPlayerICon", PLAYERICON)