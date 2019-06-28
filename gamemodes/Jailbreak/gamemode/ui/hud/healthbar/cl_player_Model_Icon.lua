local PLAYERMODELPANEL = {}

local mats = {
    WARDEN = Material("jailbreak/vgui/Blue_Icon_Slot.png", "smooth"),
    GUARD = Material("jailbreak/vgui/DeepBlue_Icon_Slot.png", "smooth"),
    PRISONER = Material("jailbreak/vgui/Orange_Icon_Slot.png", "smooth")
}

function PLAYERMODELPANEL:Init()
    targetPlayer = LocalPlayer()
    self.avatar = vgui.Create("DModelPanel", self)
    self.avatar:SetModel(targetPlayer:GetModel())
    local eyepos = self.avatar.Entity:GetBonePosition(self.avatar.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    self.avatar:SetLookAt(eyepos - Vector(0, 0, 5))
    self.avatar:SetCamPos(eyepos - Vector(-30, 5, 5)) -- Move cam in front of eyes
    self.avatar:SetFOV(52)
    self.avatar:SetDirectionalLight(BOX_RIGHT, Color(0, 50, 255))
    self.avatar:SetDirectionalLight(BOX_LEFT, Color(255, 170, 170))
    self.avatar:SetDirectionalLight(BOX_LEFT, Color(50, 170, 250))
    self.avatar.Entity:SetEyeTarget(eyepos - Vector(-35, 0, 0))
    self.avatar:SetPaintedManually(true)

    -- disables default rotation
    function self.avatar:LayoutEntity(Entity)
        return
    end

    function self.avatar.Entity:GetPlayerColor()
        return team.GetColor(ply:Team())
    end
end

function PLAYERMODELPANEL:PerformLayout(width, height)
    self.avatar:SetSize(width, width)
end

function PLAYERMODELPANEL:Paint(width, height)
    if not targetPlayer or not targetPlayer:Alive() then return end
    draw.DrawRect(0, 0, self.avatar:GetWide(), self.avatar:GetTall(), Color(255, 255, 255), (targetPlayer:Team() == 1) and mats.PRISONER or (targetPlayer == warden and mats.GUARD or mats.WARDEN))
    local radius = 109
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
    draw.ChamferedBox(width / 2, height / 2 - toVRatio(25), toHRatio(radius), toVRatio(radius + 50), 1000, Color(252, 255, 255))
    render.SetStencilReferenceValue(2)
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
    self.avatar:PaintManual()
    render.SetStencilEnable(false)

    if self.avatar:GetModel() ~= targetPlayer:GetModel() then
        self.avatar:SetModel(targetPlayer:GetModel())
        self.avatar:SetAnimated(false)

        function self.avatar.Entity:GetPlayerColor()
            return team.GetColor(ply:Team())
        end
    end
end

vgui.Register("PlayerModelPanel", PLAYERMODELPANEL)