util.AddNetworkString("UpdateHealth")
util.AddNetworkString("PlayerDied")
util.AddNetworkString("RequestHealth")
local ply = FindMetaTable("Player")
local regHealth = 0

function ply:GenerateHealth(amount, cap)
    self.regHealth = math.Clamp(amount, 0, self:GetMaxHealth())
    self:SetHealth(self:GetMaxHealth())
    self.maxShield = math.Clamp(cap, 0, self:GetMaxHealth())
    self.shield = self.maxShield
    self.hp = self:GetMaxHealth() - self.maxShield

    hook.Add("Think", "RegenerateHealth", function()
        JB:RegenerateHealth()
    end)

    self:SendHealthStatus()
end

function JB:RegenerateHealth()
    for k, v in pairs(player.GetAll()) do
        v:GainHealth()
        v:LoseHealth()
        v:GenerateShield()
        --     if v:Alive() and v:Health() <= v:GetMaxHealth() and v.shield < v.maxShield then
        --         v.shield = v.shield + regHealth * FrameTime()
        --         v:SetHealth(v.hp + v.shield)
        --         v:SendHealthStatus()
        --     end
    end
end

function ply:SendHealthStatus()
    net.Start("UpdateHealth")
    net.WriteInt(self.shield, 32)
    net.WriteInt(self.hp, 32)
    net.WriteInt(self.maxShield, 32)
    net.Send(self)
end

function ply:LoseHealth()
    if (self.hp + math.floor(self.shield)) <= self:Health() then return end
    local dmg = (self.hp + self.shield) - self:Health()

    if self.shield > 0 then
        self.shield = self.shield - dmg

        if self.shield < 0 then
            dmg = math.abs(self.shield)
            self.shield = 0
        else
            dmg = 0
        end
        --`
    end

    if dmg > 0 then
        self.hp = self.hp - dmg
    end

    self:SendHealthStatus()
end

function ply:GainHealth()
    if (self.hp + self.shield) >= self:Health() then return end
    gain = self:Health() - (self.hp + self.shield)

    if self.hp < self:GetMaxHealth() - self.maxShield then
        self.hp = self.hp + gain
        gain = 0

        if self.hp > self:GetMaxHealth() - self.maxShield then
            gain = self.hp - (self:GetMaxHealth() - self.maxShield)
            self.hp = self:GetMaxHealth() - self.maxShield
        end
    end

    if gain > 0 then
        self.shield = self.shield + gain
        self.shield = math.Clamp(self.shield, 0, self.maxShield)
    end

    self:SendHealthStatus()
end

function ply:GenerateShield()
    if self.regHealth == 0 then return end

    if self:Alive() and self:Health() <= self:GetMaxHealth() and self.shield < self.maxShield then
        self.shield = self.shield + self.regHealth * FrameTime()
        self:SetHealth(self.hp + self.shield)
        self:SendHealthStatus()
    end
end

hook.Add("PlayerDeath", "SendDied", function(victim, inflictor, attacker)
    JB:SendPlayerDied(victim)
end)

hook.Add("PlayerSilentDeath", "SendSilentDied", function(pl)
    JB:SendPlayerDied(pl)
end)

function JB:SendPlayerDied(pl)
    net.Start("PlayerDied")
    net.Send(pl)
end

net.Receive("RequestHealth", function(ln, pl) 
    pl:SendHealthStatus()
end)