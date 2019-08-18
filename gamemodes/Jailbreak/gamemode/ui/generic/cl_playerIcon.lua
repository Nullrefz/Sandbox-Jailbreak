local PLAYERICON = {}

function PLAYERICON:Init()
    self.avatar = vgui.Create("AvatarImage", self)
    self.avatar:SetPaintedManually(true)
    self.skew = toHRatio(7)
end

function PLAYERICON:SetPlayer(ply)
    self.avatar:SetPlayer(ply, toVRatio(64))
end

function PLAYERICON:Paint(width, height)
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
    draw.DrawSkewedRect(0, 0, width, height, self.skew, Color(255, 255, 255, 255))
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
    self.avatar:PaintManual()
    render.SetStencilEnable(false)
    render.ClearStencil()
end

function PLAYERICON:PerformLayout(width, height)
    self.avatar:SetSize(width, height)
end

vgui.Register("JailbreakPlayerIcon", PLAYERICON)