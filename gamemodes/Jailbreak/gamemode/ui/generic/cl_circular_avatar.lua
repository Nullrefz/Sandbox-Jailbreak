local CIRCULARAVATAR = {}

function CIRCULARAVATAR:DrawSkin()
    self.panel = vgui.Create("AvatarImage", self)
    self.panel:SetPaintedManually(true)
    self.panel:SetPlayer(self.ply, 128)
    self.panel:Dock(FILL)
end

function CIRCULARAVATAR:Player(pl)
    if pl then
        self.ply = pl
        self:DrawSkin()
    else
        return self.ply
    end
end

function CIRCULARAVATAR:Paint(width, height)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
    draw.ChamferedBox(width / 2, height / 2, width, height, 2000, Color(255, 255, 255))
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
    self.panel:PaintManual()
    render.SetStencilEnable(false)
    render.ClearStencil()
end

vgui.Register("CircularAvatar", CIRCULARAVATAR)