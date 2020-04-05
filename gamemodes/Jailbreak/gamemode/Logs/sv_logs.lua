util.AddNetworkString("OpenLogs")

hook.Add("ShowTeam", "identifier", function(ply)
    JB:OpenLogs(ply)
end)

function JB:OpenLogs(ply)
    net.Start("OpenLogs")
    net.Send(ply)
end

local LogType = {"kill", "death"}
local roundLog = {}

function JB:RegisterLog(ply, type, event)
    if self:GetActivePhase() ~= ROUND_ACTIVE then return end
end

util.AddNetworkString("SendLog")

function JB:SendLog(ply)
    if not ply then return end
    net.Start("SendLog")
    net.WriteTable(roundLog)
    net.Send(ply)
end