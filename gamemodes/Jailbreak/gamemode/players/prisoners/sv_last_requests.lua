util.AddNetworkString("SendCustomLR")
util.AddNetworkString("SetLRPlayer")
util.AddNetworkString("SetLR")
util.AddNetworkString("SendLR")
util.AddNetworkString("RequestLR")
util.AddNetworkString("GiveFreeday")
JB.curLRDay = ""

net.Receive("SendLR", function(ln, ply)
    local lastRequest = net.ReadString()
    JB:ParseLR(lastRequest, ply)
end)

function JB:ParseLR(lastRequest, ply)
    local lrNotification = {
        TEXT = "Last request given",
        TYPE = 2,
        TIME = 7,
        COLOR = Color(255, 175, 0, 200)
    }

    if lastRequest == "tic tac toe" then
        self:SetTicTacToe()
        self:SendNotification(lrNotification)
    elseif lastRequest == "knife battle" then
        self:SetKnifeBattle()
        self:SendNotification(lrNotification)
    elseif lastRequest == "sniper battle" then
        self:SetSniperBattle()
        self:SendNotification(lrNotification)
    elseif lastRequest == "calendar" then
        self:OpenMenu(lastRequest)
    elseif lastRequest == "challenge" then
        self:OpenMenu(lastRequest)
    elseif lastRequest == "custom" then
        self:SetCustom(ply)
    elseif lastRequest == "exclusive freeday" then
        self:SetExclusive(ply)
    elseif lastRequest ~= "" then
        local notification = {
            TEXT = "Next round is gonna be " .. lastRequest,
            TYPE = 2,
            TIME = 10,
            COLOR = Color(255, 0, 0, 200)
        }

        self:SendNotification(lrNotification)
        self:SendNotification(notification)
        self.nextDay = lastRequest
    end
end

net.Receive("GiveFreeday", function(ln, ply)
    local players = net.ReadTable()
    JB:SetExclusiveFreeday(ply, players)
end)

--End the round
function JB:SetExclusiveFreeday(ply, players)
    if #players == #team.GetPlayers(TEAM_PRISONERS) then
        self:ParseLR("freeday")
    else
        for k, v in pairs(players) do
            local notification = {
                TEXT = "Next round " .. v:Name() .. " will receive a freeday",
                TYPE = 2,
                TIME = 5,
                COLOR = Color(255, 175, 0, 200)
            }

            self.nextDay = "exclusive freeday"
            self:SendNotification(notification)
        end
    end

    self:UpdateLR()
end

util.AddNetworkString("OpenExclusive")

function JB:SetExclusive(ply)
    net.Start("OpenExclusive")
    net.Send(ply)
end

function JB:SetTicTacToe()
    -- TP players to tic tac toe
end

local challengeMode = false

function JB:SetKnifeBattle()
    challengeMode = true
    self:SetBattle("knife")
end

function JB:SetSniperBattle()
    challengeMode = true
    self:SetBattle("awp")
end

function JB:SetBattle(weapon)
    local pl, guard = self:GetBattlePlayers()
    if not IsValid(guard) or not IsValid(pl) or not guard:Alive() or not pl:Alive() then return end
    pl:StripWeapons()
    pl:GiveWeapon("weapon_" .. weapon)
    guard:StripWeapons()
    guard:GiveWeapon("weapon_" .. weapon)

    local notification = {
        TEXT = guard:Name() .. " VS " .. pl:Name() .. " in " .. weapon .. " battle",
        TYPE = 1,
        TIME = 10,
        COLOR = Color(0, 150, 255, 200)
    }

    JB:SendNotification(notification)

    hook.Add("PlayerDeath", "SelectBattlePlayer", function()
        if not IsValid(pl) or not IsValid(guard) then return end
        if pl:Alive() and guard:Alive() then return end

        if pl:Alive() and not guard:Alive() then
            local winNotify = {
                TEXT = pl:Name() .. " wins!",
                TYPE = 1,
                TIME = 5,
                COLOR = Color(0, 255, 150, 200)
            }

            JB:SendNotification(winNotify)
        elseif not pl:Alive() and guard:Alive() then
            winNotify = {
                TEXT = guard:Name() .. " wins!",
                TYPE = 1,
                TIME = 5,
                COLOR = Color(0, 255, 150, 200)
            }

            JB:SendNotification(winNotify)
        end

        hook.Remove("PlayerDeath", "SelectBattlePlayer")

        if challengeMode then
            JB:SetBattle(weapon)
        end
    end)
end

hook.Add("jb_round_ending", "StopChallenge", function()
    challengeMode = false
    JB:HighlightPlayers({}, "battle")
end)

function JB:GetBattlePlayers()
    local guards = self:GetAlivePlayersByTeam(TEAM_GUARDS)

    if #guards == 0 then
        challengeMode = false

        return
    end

    local guard = guards[1]
    local pl = self:GetAlivePlayersByTeam(TEAM_PRISONERS)[1]

    if #guards > 1 and guard.IsWarden() then
        guard = guard[2]
    end

    for k, v in pairs(guards) do
        if v ~= guard then
            v:StripWeapons()
            guard:GiveWeapon("weapon_empty")
        end
    end

    local players = {
        {
            Player = pl,
            Color = team.GetColor(pl:Team())
        },
        {
            Player = guard,
            Color = team.GetColor(guard:Team())
        }
    }

    self:HighlightPlayers(players, "battle")

    return pl, guard
end

util.AddNetworkString("OpenCustomRequest")
util.AddNetworkString("SendCustomRequest")

function JB:SetCustom(ply)
    net.Start("OpenCustomRequest")
    net.Send(ply)
end

net.Receive("SendCustomRequest", function(ln, ply)
    local customLR = net.ReadString()

    local notification = {
        TEXT = "Custom LR Set",
        TYPE = 2,
        TIME = 10,
        COLOR = Color(255, 175, 0, 200)
    }

    local lrNotification = {
        TEXT = "Next Round: " .. customLR,
        TYPE = 2,
        TIME = 15,
        COLOR = Color(255, 0, 0, 200)
    }

    JB:SendNotification(notification)
    JB:SendNotification(lrNotification)
    JB.nextDay = customLR
end)

function JB:ConsumeLR()
    if self.nextDay ~= "" then
        self.curLR = self.nextDay
        self:HandleDay(self.curLR)
        self.nextDay = ""
    end
end

function JB:UpdateLR(ply)
    net.Start("SetLR")
    net.WriteString(self.nextDay)

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
    self:SetLRPlayer(ply)
end

function JB:EndLR()
    self.curLRDay = ""
    self:HighlightPlayer()
    self:SetLRPlayer()
    self:UpdateLR()
end

net.Receive("RequestLR", function(ln, ply)
    JB:UpdateLR(ply)
end)

hook.Add("jb_round_active", "HonorLR", function()
    JB:ConsumeLR()
end)

hook.Add("jb_round_ending", "ResetLR", function()
    JB:EndLR()
end)

function JB:SetLRPlayer(ply)
    net.Start("SetLRPlayer")
    net.WriteEntity(ply)

    if ply then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

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