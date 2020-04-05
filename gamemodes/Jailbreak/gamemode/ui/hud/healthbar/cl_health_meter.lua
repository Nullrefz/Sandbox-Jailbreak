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
local percent = 0

function HEALTHMETER:Init()
    self.health = 0
    self.shield = 0
    self.armor = 0
    self:RequestHealth()
    self.total = 0

    function self:Paint(width, height)
        if not targetPlayer or not targetPlayer:Alive() then
            percent = Lerp(FrameTime() * 5, percent, 0)
        else
            percent = Lerp(FrameTime() * 5, percent, 1)
        end

        width = width - 30
        self.health = Lerp(FrameTime() * 10, self.health, health / targetPlayer:GetMaxHealth())
        self.shield = Lerp(FrameTime() * 10, self.shield, shield / targetPlayer:GetMaxHealth())
        self.total = Lerp(FrameTime() * 10, self.total, self.health + self.shield)
        self.armor = Lerp(FrameTime() * 10, self.armor, targetPlayer:Alive() and targetPlayer:Armor() / 100 or 0)
        self.armorWidth = self.armor / 2
        self.healthWidth = 1 - self.armor / 2
        self.shieldWidth = (1 - (targetPlayer:GetMaxHealth() - maxShield) / targetPlayer:GetMaxHealth()) * (1 - self.armor / 2)

        if (self.health > 0) then
            DrawBar(10, width * self.healthWidth, height, 5, barIncrement, math.Clamp(self.total, 0, self.health), Color(255, 255, 255, 255 * percent), mats.BAR)
        end

        DrawBar(10 + width * self.healthWidth * math.Clamp(self.total, 0, self.health), width * self.healthWidth, height, 5, barIncrement, maxShield / targetPlayer:GetMaxHealth(), Color(20, 175, 255, 50 * percent), mats.BAR)

        if (self.shield > 0) then
            DrawBar(10 + width * self.healthWidth * math.Clamp(self.total, 0, self.health), width * self.healthWidth, height, 5, barIncrement, math.Clamp(self.total, self.health, 1) - self.health, Color(20, 175, 255, 255 * percent), mats.BAR)
        end

        -- if (self.shield > 0) then
        --DrawBar(10 + width * self.healthWidth * self.health, width * self.shieldWidth, height, 5, (1 - (targetPlayer:GetMaxHealth() - maxShield) / targetPlayer:GetMaxHealth()) * barIncrement, self.shield, Color(20, 175, 255, 255 * percent), mats.BAR)
        -- end
        if (self.armor > 0) then
            DrawBar(10 + width * ((self.healthWidth * self.health) + self.healthWidth * self.shield), width * self.armorWidth, height, 5, math.ceil(self.armorWidth * 2 * barIncrement), 1, Color(255, 200, 0, 255 * percent), mats.BAR)
        end
    end
end

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