local ply = FindMetaTable("Player")

local spawns = {
    ["prisoners"] = ents.FindByClass("info_player_terrorist"),
    ["guards"] = ents.FindByClass("info_player_counterterrorist"),
    ["global"] = ents.FindByClass("info_player_start")
}

local models = {{"models/player/group01/male_01.mdl", "models/player/group01/male_02.mdl", "models/player/group01/male_03.mdl", "models/player/group01/male_04.mdl", "models/player/group01/male_05.mdl", "models/player/group01/male_06.mdl", "models/player/group01/male_07.mdl", "models/player/group01/male_08.mdl", "models/player/group01/male_09.mdl", "models/player/group01/female_01.mdl", "models/player/group01/female_02.mdl", "models/player/group01/female_03.mdl", "models/player/group01/female_04.mdl", "models/player/group01/female_05.mdl", "models/player/group01/female_06.mdl"}, {"models/player/combine_soldier.mdl", "models/player/combine_soldier_prisonguard.mdl", "models/player/combine_super_soldier.mdl", "models/player/police.mdl", "models/player/police_fem.mdl"}}

function ply:GetSpawnPos()
    local teamSpawn = spawns[self:Team()]

    if not teamSpawn then
        teamSpawn = spawns["global"]
    end

    local spawn = teamSpawn[math.random(#teamSpawn)]

    return spawn:GetPos()
end

function ply:ApplyModel()
    local teamModels = models[self:Team()]
    if not teamModels then return end
    local designatedModel = teamModels[math.random(#teamModels)]
    self:SetModel(designatedModel)
end

function ply:Setup()
    self:SetPos(self:GetSpawnPos())
    self:ApplyModel()
    local col = team.GetColor(self:Team())
    self:SetPlayerColor(Vector(col.r / 255, col.g / 255, col.b / 255))
end

hook.Add("PlayerSpawn", "OnPlayerSpawn", function(pl)
    pl:Setup()
end)

hook.Add("PlayerInitialSpawn", "some_unique_name", function(pl)
    pl:SetTeam(1)
    pl:SetTeam(TEAM_REBELS)
    pl:KillSilent()
end)