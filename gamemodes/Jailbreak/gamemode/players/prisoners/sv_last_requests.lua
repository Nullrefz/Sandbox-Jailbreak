util.AddNetworkString("SendCustomLR")
util.AddNetworkString("SetLRPlayer")
util.AddNetworkString("SetLR")
util.AddNetworkString("SendLR")
util.AddNetworkString("RequestLR")
JB.curLRDay = ""

net.Receive("SendLR", function(ln, ply)
    local lastRequest = net.ReadString()

    if lastRequest == "tic tac toe" then
        JB:SetTicTacToe()
    elseif lastRequest == "knife battle" then
        JB:SetKnifeBattle()
    elseif lastRequest == "calendar" then
        JB:OpenMenu(lastRequest)
    elseif lastRequest == "sniper battle" then
        JB:SetSniperBattle()
    elseif lastRequest == "custom" then
        JB:SetCustom()
    end
end)

function JB:SetTicTacToe()
    -- TP players to tic tac toe
end

function JB:SetKnifeBattle()
    -- TP players to knife battle
end

function JB:SetSniperBattle()
    -- TP players to sniper battle
end

function JB:SetCustom()
    -- Open Message Text
end

function JB:ConsumerLR()
    if self.nextDay ~= "" then
        self.curLR = self.nextDay
        self:HandleDay(self.curLR)
        self.nextDay = ""
    end
end

function JB:UpdateLR(ply)
    net.Start("SetLR")
    net.WriteString(self.curLRDay)

    if ply then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function JB:InitiateLR(ply)
    local notification = {
        TEXT = ply:Name() .. " gets the last request",
        TYPE = 2
    }

    self:SendNotification(notification)
    local playersToHighlight = {ply}
    self:HighlightPlayer(playersToHighlight)
    -- Give them access to the menu
end

function JB:EndLR()
    self.curLRDay = ""
    self:HighlightPlayer()
    self:UpdateLR()
end

net.Receive("RequestLR", function(ln, ply)
    JB:UpdateLR(ply)
end)

hook.Add("jb_round_active", "HonorLR", function()
    JB:ConsumerLR()
end)

hook.Add("jb_round_ending", "ResetLR", function()
    JB:EndLR()
end)

function JB:CheckLR()
    if #self:GetAlivePlayersByTeam(Team.PRISONERS) ~= 1 or self.dayPhase == "Purge Day" or self.dayPhase == "Warday" or self:GetActivePhase() ~= "Active" then return end
    self:InitiateLR(self:GetAlivePlayersByTeam(Team.PRISONERS)[1])
end

hook.Add("PostPlayerDeath", "CheckForLR", function(ply)
    if ply:Team() > Team.PRISONERS then return end
    JB:CheckLR()
end)

hook.Add("PlayerDisconnected", "CheckForLRAfterDisconnect", function(ply)
    if ply:Team() > Team.PRISONERS then return end
    JB:CheckLR()
end)