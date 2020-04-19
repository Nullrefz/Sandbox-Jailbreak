if CLIENT then
    local MOTD = {}

    local mats = {
        BG = Material("jailbreak/vgui/images/gradient_background.png", "smooth")
    }

    function MOTD:Init()
        self:MakePopup()
        self.background = vgui.Create("Panel", self)
        local alpha = 0

        LerpFloat(0, 1, 1, function(progress)
            if not alpha then return end
            alpha = progress
        end, INTERPOLATION.SinLerp)

        function self.background:Paint(width, height)
            draw.DrawRect(0, 0, width, height, Color(255, 255, 255, 50 * alpha), mats.BG)
            --  Derma_DrawBackgroundBlur(self, 0)
        end

        self.header = vgui.Create("Panel", self)
        self.body = vgui.Create("Panel", self)
        self.footer = vgui.Create("Panel", self)
        self.list = vgui.Create("DIconLayout", self.body)
        self.list:SetSpaceX(16)
        self.cardCount = 5

        for i = 1, self.cardCount do
            local card = self.list:Add("MOTDPanel")
            card:SetSize(toHRatio(331), toVRatio(581))
            card:SetInfo(i)
        end

        function self.header:Paint(width, height)
            draw.DrawText("You are playing on" .. " " .. GetHostName(), "Jailbreak_Font_70", width / 2, height - 70, Color(255, 255, 255, 255 * alpha), TEXT_ALIGN_CENTER)
        end
    end

    function MOTD:PerformLayout(width, height)
        self.background:SetSize(width, height)
        self.header:Dock(TOP)
        self.body:Dock(FILL)
        self.footer:Dock(BOTTOM)
        self.list:SetSize(toHRatio(288 + self.list:GetSpaceX() * 3.5) * self.cardCount, toVRatio(512))
        self.list:Center()
        self.header:SetTall(144)
        self.footer:SetTall(self.header:GetTall())
    end

    function MOTD:Paint(width, height)
    end

    function MOTD:Close()
        self:Clear()
        self:Remove()
    end

    vgui.Register("JailbreakMOTD", MOTD)
    JB.motd = {}

    function JB.motd:Show()
        self.motdPanel = vgui.Create("JailbreakMOTD")
        self.motdPanel:SetSize(w, h)

        JB.motd.Hide = function()
            if not IsValid(self.motdPanel) then return end
            self.motdPanel:Remove()
            self.motdPanel:Clear()
        end
    end

    net.Receive("OpenMOTD", function()
        JB.motd:Show()
    end)
end

if SERVER then
    util.AddNetworkString("OpenMOTD")

    hook.Add("PlayerInitialSpawn", "FullLoadSetup", function(ply)
        hook.Add("SetupMove", ply, function(self, ply, _, cmd)
            if self == ply and not cmd:IsForced() then
                hook.Run("PlayerFullLoad", self)
                hook.Remove("SetupMove", self)
            end
        end)
    end)

    hook.Add("PlayerFullLoad", "OpenMOTD", function(ply)
        JB:OpenMOTD(ply)
    end)

    hook.Add("ShowHelp", "OpenMOTD", function(ply)
        JB:OpenMOTD(ply)
    end)

    function JB:OpenMOTD(ply)
        net.Start("OpenMOTD")
        net.Send(ply)
    end
end