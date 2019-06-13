local mats = {
    HPBlUE = Material("jailbreak/vgui/HealthBar_Blue.png", "smooth"),
    HPWHITE = Material("jailbreak/vgui/HealthBar_White.png", "smooth"),
    HPYELLOW = Material("jailbreak/vgui/HealthBar_Yellow.png", "smooth"),
    BAR = Material("jailbreak/vgui/Bar.png", "smooth")
}

local HEALTHMETER = {}
-- How many healthpoint each bar repesents
local barIncrement = 10
local shield = 0
local health = 0
local maxShield = 30

function HEALTHMETER:Init()
    self.health = 0
    self.shield = 0
    self.armor = 0
    self.ply = LocalPlayer()
    self:RequestHealth()

    function self:Paint(width, height)
        width = width - 30
        self.health = Lerp(FrameTime() * 5, self.health, health / self.ply:GetMaxHealth())
        self.shield = Lerp(FrameTime() * 5, self.shield, shield / maxShield)
        self.armor =  Lerp(FrameTime() * 5, self.armor, self.ply:Armor() / 100)
        self.armorWidth = self.armor / 2
        self.healthWidth = 1 - self.armor / 2
        self.shieldWidth = (1 - (self.ply:GetMaxHealth() - maxShield) / self.ply:GetMaxHealth()) * (1 - self.armor / 2)

        if (self.health > 0) then
            DrawBar(10, width * self.healthWidth, height, 5, barIncrement, self.health, Color(255, 255, 255, 255))
        end

        if (self.shield > 0) then
            DrawBar(10 + width * self.healthWidth * self.health, width * self.shieldWidth, height, 5, (1 - (self.ply:GetMaxHealth() - maxShield) / self.ply:GetMaxHealth()) * barIncrement, self.shield, Color(20, 175, 255, 255))
        end

        if (self.armor > 0) then
            DrawBar(10 + width * ((self.healthWidth * self.health) + self.shieldWidth * self.shield), width *  self.armorWidth , height, 5, math.ceil( self.armorWidth * 2 * barIncrement)   , 1, Color(255, 200, 0, 255))
        end
    end
end

function DrawBar(offset, width, height, skew, divisions, prog, color)
    local wide = width / divisions
    local progress = prog * divisions

    for i = 1, math.Clamp(divisions, 0, math.ceil(progress)) do
        local fill = math.Clamp(progress, 0, 1)
        progress = progress - fill
        draw.DrawSkewedRect((i - 1) * wide - skew + offset, 0, (wide * fill) + skew / 2, height, skew, color, mats.BAR)
    end
end

-- TODO: TO BE OPTIMIZED
vgui.Register("HealthMeter", HEALTHMETER)

net.Receive("UpdateHealth", function()
    shield = net.ReadInt(32)
    health = net.ReadInt(32)
    maxShield = net.ReadInt(32)
end)

function HEALTHMETER:RequestHealth()
    net.Start("RequestHealth")
    net.SendToServer()
end