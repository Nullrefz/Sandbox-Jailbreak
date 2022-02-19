local MOTDPANEL = {}
local mats = {Material("jailbreak/vgui/images/prisoner_card.png", "smooth"), Material("jailbreak/vgui/images/guards_card.png", "smooth"), Material("jailbreak/vgui/images/steam_card.png", "smooth"), Material("jailbreak/vgui/images/discord_card.png", "smooth")}
--, Material("jailbreak/vgui/images/patreon_card.png", "smooth")}

function MOTDPANEL:Init()
    self.panel = vgui.Create("DButton", self)
    self.panel:SetText("")
    local footerHeight = 0.15
    self.info = 1
    self.text = ""
    local alpha = 0

    LerpFloat(0, 1, 0.3, function(progress)
        if not alpha then return end
        alpha = progress
    end, INTERPOLATION.SinLerp)

    function self.panel:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(255, 255, 255, 255 * alpha), mats[self:GetParent().info])
        draw.DrawRect(0, (1 - footerHeight) * height, width, height * footerHeight, Color(50, 50, 50, 250 * alpha))
        draw.DrawRect(0, (1 - footerHeight) * height + height * footerHeight - height * footerHeight / 2, width, height * footerHeight / 2, Color(150, 150, 150, 10 * alpha))
        draw.DrawText(self:GetParent().texts[self:GetParent().info], "Jailbreak_Font_46", width / 2, (1 - footerHeight) * height + 46 / 2, Color(255, 255, 255 * alpha), TEXT_ALIGN_CENTER)
    end
end

function MOTDPANEL:PerformLayout(width, height)
    self.panel:SetSize(width, height)
end

function MOTDPANEL:SetInfo(index)
    self.info = index
    self.texts = {"Join Prisoners", "Join Guards", "Steam Group", "Discord Server", "Patreon"}

    self.panel.DoClick = function()
        if index == 1 then
            self:JoinTeamPrisoners()
        elseif index == 2 then
            self:JoinTeamGuards()
        elseif index == 3 then
            self:JoinSteamGroup()
        elseif index == 4 then
            self:JoinDiscordServer()
        elseif index == 5 then
            self:JoinPatreon()
        end

        self:GetParent():GetParent():GetParent():Remove()
    end
end

function MOTDPANEL:JoinTeamPrisoners()
    JB:JoinTeam(1)
end

function MOTDPANEL:JoinTeamGuards()
    JB:JoinTeam(2)
end

function MOTDPANEL:JoinSteamGroup()
    gui.OpenURL("https://steamcommunity.com/groups/chillrush")
end

function MOTDPANEL:JoinDiscordServer()
    gui.OpenURL("https://discord.gg/46CzHt")
end

function MOTDPANEL:JoinPatreon()
end

vgui.Register("MOTDPanel", MOTDPANEL)

function JB:JoinTeam(index)
    net.Start("ChangeTeam")
    net.WriteInt(index, 32)
    net.SendToServer()
end