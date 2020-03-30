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
    self.nextSelect = 0
    function self:Paint(width, height)
        DrawInfinitBar(width / 2 + width * 0.1, 0, width * 0.1, 128, 10, #self.weapons, self.curIndex + 1, Color(255, 255, 255), mats.BAR, self.mats, self.weapons, self.percentage)
        self.percentage = math.Clamp(self.percentage - FrameTime() * 2, 0, 10)
    end

    hook.Add("CreateMove", "selectID", function()
        if self.nextSelect - CurTime() <= 0 then
            if (input.WasMouseReleased(MOUSE_WHEEL_UP)) then
                self.curIndex = self.curIndex + 1
                self:SortWeapons()
            elseif (input.WasMouseReleased(MOUSE_WHEEL_DOWN)) then
                self.curIndex = self.curIndex - 1
                self:SortWeapons()
            end

            for i = 2, 10 do
                if input.WasKeyPressed(i) then
                    self:SelectWeapon(i - 2)
                end
            end
        end
    end)
end

function WEAPONSELECT:SelectWeapon(category)
    self:SortWeapons()
    if not self.weapons or #self.weapons == 0 then return end
    local selectedSlot

    for k, v in pairs(self.weapons) do
        if not selectedSlot and v:GetSlot() == category then
            selectedSlot = k
        end

        if k == self.curIndex + 1 then
            if self.weapons[k + 1] and self.weapons[k + 1]:GetSlot() == category then
                self.curIndex = selectedSlot + 1
                self:SortWeapons()

                return
            end

            if selectedSlot ~= nil then
                self.curIndex = selectedSlot - 1
                self:SortWeapons()
            end
        end
    end
end

function WEAPONSELECT:SortWeapons()
    self.percentage = 2
    self.nextSelect = CurTime() + 0.1
    self.weapons = LocalPlayer():GetWeapons()
    if not self.weapons or #self.weapons == 0 then return end
    self.curIndex = self.curIndex % #LocalPlayer():GetWeapons()
    table.sort(self.weapons, function(a, b) return (a:GetSlot() * 1000 + a:GetSlotPos()) < (b:GetSlot() * 1000 + b:GetSlotPos()) end)
    input.SelectWeapon(self.weapons[self.curIndex + 1])
    self.mats = {}

    for k, v in pairs(self.weapons) do
        local wepMat = Material("jailbreak/vgui/weapons/" .. v:GetClass() .. ".png", "smooth")
        table.insert(self.mats, wepMat)
    end
end

vgui.Register("JailbreakWeaponSelect", WEAPONSELECT)

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
    height = height / 2
    width = width / 2
    if not LocalPlayer():Alive() or not weapons or not weaponMat then return end
    -- local pivot = math.floor(index / divisions)
    curPos = Lerp(FrameTime() * 10, curPos, index * width)
    local dist = (index * width - curPos) / (index * width)
    percentage =  Lerp(FrameTime() * 10, percentage, showPercentage)

    -- for j = -1, 1 do
    for i = 1, divisions do
        if not IsValid(weapons[i]) then return end
        local offsetX = (i - 1) * width - skew + (x - (divisions * width)/ 2)  + (1 - math.Clamp(percentage, 0, 1))
        local offsetY = 0
        draw.SkweredChamferedBox(offsetX - 2, y - offsetY + 2, width + skew * 2 - 1, height * 2, 2, skew, Color(0, 0, 0, 255 * percentage))
        draw.DrawSkewedRect(offsetX, y - offsetY, width + skew / 2, height, skew, Color(255, math.abs(index - i - (1 * dist)) * 255, math.abs(index - i - (1 * dist)) * 255, 225 * percentage), mat) -- - pivot * width * divisions + j * width * divisions,
        draw.DrawText(string.Replace(weapons[i]:GetClass(), "weapon_jb_", ""), "Jailbreak_Font_Ammo", offsetX + width / 2, 32 - offsetY, Color(255, 255, 255, 255 * percentage), TEXT_ALIGN_CENTER) -- - pivot * width * divisions + j * width * divisions + width / 2
        draw.DrawRect(offsetX + 24 / 2, -offsetY - 12, width - 24, width - 24, Color(255, 255, 255, 255 * percentage), weaponMat[i])
    end
    -- end
end