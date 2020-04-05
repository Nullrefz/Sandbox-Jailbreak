-- Script that handles the in-game timer, and round phases.
JB.round = {}
ROUND_WAITING = "Waiting"
ROUND_PREPARING = "Preparing"
ROUND_ACTIVE = "Active"
ROUND_ENDING = "Ending"
util.AddNetworkString("RoundChanged")
util.AddNetworkString("RequestRound")

--[[---------------------------------------------------------
Name: jailbreak:GetPhaseByName(phaseName)
Desc: Returns phase by name
Args: • phaseName -- Name of the phase
-----------------------------------------------------------]]
function JB:GetPhaseByName(phaseName)
    for k, v in pairs(self.round) do
        if v == phaseName then return v end
    end
end

--[[---------------------------------------------------------
Name: jailbreak:SetRoundPhase(roundPhase)
Desc: Sets the phase of the round
Args: • roundPhase -- Phase of the round
-----------------------------------------------------------]]
function JB:SetRoundPhase(roundPhase)
    if not self.round.count then
        self.round.count = 0
    end

    if self:GetPhaseByName(roundPhase) then
        self.round.activePhase = self:GetPhaseByName(roundPhase)
    end

    self:SetRoundTime(GetConVar("jb_Round_" .. self.round.activePhase):GetInt() or -1)
    hook.Run(string.lower("jb_round_" .. self.round.activePhase))
    self:SendRoundChanged()
end

--[[---------------------------------------------------------
Name: jailbreak:SendRoundChanged()
Desc: Sends the new round phase to the client
-----------------------------------------------------------]]
function JB:SendRoundChanged(ln, ply)
    net.Start("RoundChanged")
    net.WriteString(self.round.activePhase)
    net.WriteFloat(self.round.roundTime)
    net.WriteFloat(self:GetTimeLeft())

    if ply then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

--[[---------------------------------------------------------
Name: jailbreak:GetActivePhase()
Desc: Returns the active phase
-----------------------------------------------------------]]
function JB:GetActivePhase()
    return self.round.activePhase
end

--[[---------------------------------------------------------
Name: jailbreak:SetRoundTime(time)
Desc: Sets the round time
Args: • time -- length of the phase in seconds
-----------------------------------------------------------]]
function JB:SetRoundTime(time)
    if not self.round.roundEnd then
        self.round.roundEnd = -1
    end

    if time then
        self.round.roundTime = time
        self.round.roundEnd = CurTime() + time
    end
end

--[[---------------------------------------------------------
Name: jailbreak:GetTimeLeft()
Desc: Returns the time left
-----------------------------------------------------------]]
function JB:GetTimeLeft()
    return self.round.roundEnd - CurTime()
end

function JB:GetTimeElapsed()
    return self.round.roundTime - (self.round.roundEnd - CurTime())
end

--[[---------------------------------------------------------
Name: jailbreak:AddPhase(phaseName, defaultPhaseTime, onBegin, onUpdate)
Desc: Adds a phase to the round
Args: • phaseName            -- Name of the phase
• defaultPhaseTime     -- Span of the pase
-----------------------------------------------------------]]
-- phase name, trigger function, think function
function JB:AddPhase(phaseName, defaultPhaseTime)
    CreateConVar("jb_round_" .. phaseName, defaultPhaseTime, FCVAR_ARCHIVE)
    table.insert(self.round, phaseName)
end

--[[---------------------------------------------------------
Name: jailbreak:RegisterRounds()
Desc: Registers the rounds and customizes them
-----------------------------------------------------------]]
function JB:RegisterRounds()
    self:AddPhase(ROUND_WAITING, -1)
    self:AddPhase(ROUND_PREPARING, 15)
    self:AddPhase(ROUND_ACTIVE, 600)
    self:AddPhase(ROUND_ENDING, 10)
end

hook.Add("JB_Initialize", "Register Rounds", JB:RegisterRounds())

--[[---------------------------------------------------------
Name: jailbreak:RoundThink()
Desc: Does the logic of a specified phase of the round every frame
-----------------------------------------------------------]]
function JB:RoundThink()
    if not self.round.activePhase then
        self.round.roundEnd = -1
        self:SetRoundPhase(ROUND_WAITING)
    end

    if (#team.GetPlayers(Team.PRISONERS) < (GetConVar("jb_min_players"):GetInt() or 1) or #team.GetPlayers(Team.GUARDS) == 0) and self.round.activePhase ~= ROUND_WAITING then
        self:SetRoundPhase(ROUND_WAITING)

        return
    end

    hook.Run(string.lower("jb_round_" .. self.round.activePhase .. "_think"))
end

hook.Add("Think", "Round Handler", function()
    JB:RoundThink()
end)

net.Receive("RequestRound", function(ply)
    JB:SendRoundChanged(ply)
end)