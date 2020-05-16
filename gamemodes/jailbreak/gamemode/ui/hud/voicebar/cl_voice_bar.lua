local VOICEBAR = {}

function VOICEBAR:Init()
    self.progress = 0
    self.active = true
    self.volume = 0
    self.skew = toHRatio(7)
    self.nameText = vgui.Create("DLabel", self)
    self.nameText:SetFont("Jailbreak_Font_32")
    self.nameText:SetText("")
    self.padding = toHRatio(5)
    self.nameText:SetTall(45)
    self.playerIcon = vgui.Create("JailbreakPlayerIcon", self)
    self.playerIcon.skew = self.skew

    function self:Paint(width, height)
        if not self.player then return end
        self.volume = Lerp(FrameTime() * 15, self.volume, self.player:VoiceVolume())
        local volumeRed = self.volume
        local volumeYellow = math.Clamp(volumeRed, 0, 0.8)
        local volumeGreen = math.Clamp(volumeRed, 0, 0.65)
        local wid = self.skew * 2
        local widPos = width * (1 - self.progress) + self.skew * 2 + toHRatio(self.padding) * (1 - self.progress)
        local barHeight = 0.08
        draw.DrawSkewedRect(wid + widPos, 0, height + self.skew, height, self.skew, Color(255, 255, 255))
        self.playerIcon:SetPos(wid + widPos, 0)
        widPos = widPos + 45 + self.skew
        draw.DrawSkewedRect(wid + widPos, 0, self.skew * 3, height, self.skew, Color(70, 70, 70))
        -- if self.player == LocalPlayer() then
        --     draw.DrawSkewedRect(wid + widPos, height, self.skew * 3, height, self.skew, Color(0, 220, 255))
        -- else
        draw.DrawSkewedRect(wid + widPos, height - height * volumeRed, self.skew * 3 - self.skew * (1 - volumeRed), height * volumeRed, self.skew * volumeRed, Color(200, 0, 55))
        draw.DrawSkewedRect(wid + widPos, height - height * volumeYellow, self.skew * 3 - self.skew * (1 - volumeYellow), height * volumeYellow, self.skew * volumeYellow, Color(255, 255, 0))
        draw.DrawSkewedRect(wid + widPos, height - height * volumeGreen, self.skew * 3 - self.skew * (1 - volumeGreen), height * volumeGreen, self.skew * volumeGreen, Color(0, 205, 100))
        -- end
        widPos = widPos + self.skew * 3
        draw.DrawSkewedRect(wid + widPos, 0, width, height, self.skew, Color(70, 70, 70))
        draw.DrawSkewedRect(wid + widPos, height - height * barHeight, width, height * barHeight, self.skew * barHeight, team.GetColor(self.player:Team()))
        self.nameText:SetPos(wid + widPos + self.skew * 2, 0)
    end
end

function VOICEBAR:PerformLayout(width, height)
    self.playerIcon:SetSize(height + self.skew, height)
end

function VOICEBAR:StartEntryAnimation()
    self.active = true

    LerpFloat(self.progress, 1, 0.2, function(prog)
        if IsValid(self) and self.active then
            self.progress = prog
        end
    end, INTERPOLATION.SinLerp)
end

function VOICEBAR:StartExitAnimation()
    self.active = false

    LerpFloat(self.progress, 0, 0.4, function(prog)
        if IsValid(self) and not self.active then
            self.progress = prog
        end
    end, INTERPOLATION.CosLerp, function()
        if IsValid(self) and not self.active and self.progress == 0 then
            self:Remove()
        end
    end)
end

function VOICEBAR:AssignPlayer(ply)
    self.player = ply
    self.nameText:SetText(ply:Name())
    self.nameText:SizeToContentsX(6)
    self.playerIcon:SetPlayer(self.player)
end

vgui.Register("JailbreakVoiceBar", VOICEBAR)