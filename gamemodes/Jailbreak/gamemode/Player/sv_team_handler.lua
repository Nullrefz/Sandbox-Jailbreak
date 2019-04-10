local pl = FindMetaTable("Player")

hook.Add("PlayerInitialSpawn", "FirstPlayerSpawn", function(ply)
    ply:SetTeam(TEAM_PRISONERS)
    ply:KillSilent()
end)

function JB:OrganizeGuards()
    local guardBalance = self:GetGuardBalance()
    if guardBalance == 0 then return end
    local prisoners = team.GetPlayers(TEAM_PRISONERS)

    for i = 1, guardBalance do
        local righteousPrisoners = prisoners[math.random(#prisoners)]
        righteousPrisoners:SetTeam(TEAM_GUARDS)
        table.RemoveByValue(righteousPrisoners, chosenPlayer)
    end
end

function JB:GetGuardBalance()
    local players = player.GetAll()
    local ratio = GetConVar("jb_guards_ratio"):GetInt()

    return math.ceil(#players / ratio) - #team.GetPlayers(TEAM_GUARDS)
end

concommand.Add("jb_jointeam", function(ply, cmd, args)
    local selectedTeam = tonumber(args[1])

    if selectedTeam == TEAM_PRISONERS then
        ply:JoinTeam(TEAM_PRISONERS)
    elseif selectedTeam == TEAM_GUARDS and JB:GetGuardBalance() > 0 then
        ply:JoinTeam(TEAM_GUARDS)
    elseif selectedTeam == TEAM_SPECTATOR or selectedTeam == TEAM_SPECTATORS then
        ply:JoinTeam(TEAM_SPECTATOR)
    end
end)

function pl:JoinTeam(chosenTeam)
    if self:Team() ~= chosenTeam then
        self:KillSilent()
    end

    self:SetTeam(chosenTeam)
end