local WEAPONSELECT = {}
local curPos = 0
local percentage = 0

local mats = {
    BAR = Material("jailbreak/vgui/bar.png", "smooth")
}

function WEAPONSELECT:Init()
    self.curIndex = 1
    self:SortWeapons()
    self.percentage = 0

    function self:Paint(width, height)
        DrawInfinitBar(width / 2 + width * 0.1, 0, width * 0.1, 128, 10, #self.weapons, self.curIndex, Color(255, 255, 255), mats.BAR, self.mats, self.weapons, self.percentage)
        self.percentage = math.Clamp(self.percentage - FrameTime(), 0, 10)
    end

    hook.Add("CreateMove", "selectID", function()
        self.curIndex = self.curIndex % #self.weapons

        if self.curIndex < 0 or self.curIndex >= #self.weapons then
            self.curIndex = #self.weapons - 1
        end

        if (input.WasMouseReleased(MOUSE_WHEEL_UP) and self.nextSelect - CurTime() <= 0) then
            self.curIndex = self.curIndex + 1
            input.SelectWeapon(self.weapons[self.curIndex])
            self:SortWeapons()
        elseif (input.WasMouseReleased(MOUSE_WHEEL_DOWN) and self.nextSelect - CurTime() <= 0) then
            self.curIndex = self.curIndex - 1
            input.SelectWeapon(self.weapons[self.curIndex])
            self:SortWeapons()
        end
    end)

    function self:OnRemove()
        hook.Remove("CreateMove", "selectID")
    end
end

function WEAPONSELECT:SortWeapons()
    self.percentage = 1.5
    self.nextSelect = CurTime() + 0.1
    self.weapons = LocalPlayer():GetWeapons()
    table.sort(self.weapons, function(a, b) return (a:GetSlot() * 1000 + a:GetSlotPos()) < (b:GetSlot() * 1000 + b:GetSlotPos()) end)
    self.mats = {}

    for k, v in pairs(self.weapons) do
        local wepMat = Material("jailbreak/vgui/weapons/" .. v:GetClass() .. ".png", "smooth")
        table.insert(self.mats, wepMat)
    end
end

vgui.Register("JailbreakWeaponSelect", WEAPONSELECT)
JB.scoreboard = {}

function JB.scoreboard:Show()
    self.scoreboardPanel = vgui.Create("JailbreakWeaponSelect")
    self.scoreboardPanel:SetSize(w, h)

    JB.scoreboard.Hide = function()
        self.scoreboardPanel:Remove()
        self.scoreboardPanel:Clear()
    end
end

function GM:ScoreboardShow()
    JB.scoreboard:Show()
end

function GM:ScoreboardHide()
    JB.scoreboard:Hide()
end

surface.CreateFont("Jailbreak_Font_Weapon_Select", {
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

function DrawInfinitBar(x, y, width, height, skew, divisions, index, color, mat, weaponMat, weapons, showPercentage)
    -- local pivot = math.floor(index / divisions)
    curPos = Lerp(FrameTime() * 10, curPos, index * width)
    local dist = (index * width - curPos) / (index * width)
    percentage = Lerp(FrameTime() * 5, percentage, showPercentage)

    -- for j = -1, 1 do
    for i = 1, divisions do
        local offsetX = (i - 1) * width - skew + x - curPos + math.abs(index - i - 1 * dist) * skew / 2
        local offsetY = math.abs(index - i - (1 * dist)) * height / 2
        draw.DrawSkewedRect(offsetX, y - offsetY, width + skew / 2, height, skew, Color(255, math.abs(index - i - (1 * dist)) * 255 + 200, math.abs(index - i - (1 * dist)) * 255, 225 * percentage), mat) -- - pivot * width * divisions + j * width * divisions,
        draw.DrawText(string.Replace(weapons[i]:GetClass(), "weapon_jb_", ""), "Jailbreak_Font_Ammo", offsetX + width / 2, height - 24 - offsetY, Color(0, 0, 0, 255 * percentage), TEXT_ALIGN_CENTER) -- - pivot * width * divisions + j * width * divisions + width / 2
        draw.DrawRect(offsetX + 24 / 2, -offsetY - 24, width - 24, width - 24, Color(0, 0, 0, 255 * percentage), weaponMat[i])
    end
    -- end
end