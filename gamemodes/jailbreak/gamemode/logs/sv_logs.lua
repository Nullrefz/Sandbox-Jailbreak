util.AddNetworkString("OpenLogs")

hook.Add("ShowTeam", "identifier", function(ply)
    JB:OpenLogs(ply)
end)

function JB:OpenLogs(ply)
    net.Start("OpenLogs")
    net.Send(ply)
end

local logs = {}
local roundLogs = {}
local session = 0
local roundNumber = 0
local dir = ""
function JB:RegisterLog(instigator, entry)
    if self:GetActivePhase() ~= ROUND_ACTIVE then
        return
    end
    for k, v in pairs(roundLogs) do
        if v.User == instigator then
            if entry.Type == "Death" then
                v.UserLifeSpan = entry.Time
            end
            table.insert(v.Logs, entry)
            self:SaveLogs()
            return
        end
    end
end

util.AddNetworkString("SendLog")
util.AddNetworkString("LogRequest")

function JB:SendLog(ply, round)
    if not ply then
        return
    end
    local logs = self:LoadLogs(round)
    net.Start("SendLog")
    net.WriteInt(round, 32)
    net.WriteFloat(logs.RoundTime)
    net.WriteTable(logs)
    net.Send(ply)
end

function JB:HandleLogRequest(ply, round)
    -- TODO: This is the section where I check if the player is allowed to get the logs
    round = math.Clamp(round, 1, roundNumber)
    self:SaveLogs()
    self:SendLog(ply, round)
end

net.Receive("LogRequest", function(ln, ply)
    local round = net.ReadInt(32)
    if round == -1 then 
        round = roundNumber
    end
    JB:HandleLogRequest(ply, round)
end)

function JB:SaveLogs()
    if roundLogs == {} then
        return
    end
    local json = util.TableToJSON(roundLogs)

    if not file.IsDir(dir, "DATA") then
        file.CreateDir(dir)
    end

    file.Write(dir .. "/round_" .. roundNumber .. ".txt", json)
end

function JB:LoadLogs(round)
    logs = {}
    
    logFile = file.Read(dir .."/round_" .. round .. ".txt", "DATA")
    return util.JSONToTable(logFile)
end

function JB:SetupLogs()
    roundLogs = {}
    roundNumber = roundNumber + 1

    for k, v in pairs(player.GetAll()) do
        table.insert(roundLogs, {
            User = v:IsBot() and v:Name() or v:SteamID(),
            UserTeam = v:Team(),
            UserName = v:Name(),
            UserLifeSpan = -1,
            Logs = {entry}
        })
    end
    
    roundLogs.RoundTime = 0
    self:SaveLogs()

end

hook.Add("jb_round_active", "SetupLogs", function()
    JB:SetupLogs()
end)

hook.Add("jb_round_ending", "SaveLogs", function()
    JB:SaveLogs()
end)

hook.Add("Think", "StoreTime", function()
    if not roundLogs.RoundTime then return end
    roundLogs.RoundTime = roundLogs.RoundTime + FrameTime()
end)

hook.Add("Initialize", "SetupLogsFolder", function()
    dir = "jailbreak/logs/session_" .. os.time()
end)
