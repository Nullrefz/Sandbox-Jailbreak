util.AddNetworkString("PlayerSpawned")
util.AddNetworkString("PlayerNoticeDied")
util.AddNetworkString("PlayerJoined")
local ply = FindMetaTable("Player")
local spawns = {}
local models = {{"models/player/group01/male_01.mdl", "models/player/group01/male_02.mdl", "models/player/group01/male_03.mdl", "models/player/group01/male_04.mdl", "models/player/group01/male_05.mdl", "models/player/group01/male_06.mdl", "models/player/group01/male_07.mdl", "models/player/group01/male_08.mdl", "models/player/group01/male_09.mdl", "models/player/group01/female_01.mdl", "models/player/group01/female_02.mdl", "models/player/group01/female_03.mdl", "models/player/group01/female_04.mdl", "models/player/group01/female_05.mdl", "models/player/group01/female_06.mdl"}, {"models/player/police.mdl"}}
local wardenModels = {"models/player/combine_super_soldier.mdl"}

--[[---------------------------------------------------------
    Name: player:GetSpawnPos()
    Desc: Get a spawn position based on the player's team
-----------------------------------------------------------]]
function ply:GetSpawnPos()
    spawns = {
        ents.FindByClass("info_player_terrorist"),
        ents.FindByClass("info_player_counterterrorist"),
        ["global"] = ents.FindByClass("info_player_start")
    }

    local teamSpawn = spawns[self:Team()]

    if not teamSpawn then
        teamSpawn = spawns["global"]
    end

    local spawn = teamSpawn[math.random(#teamSpawn)]

    return spawn:GetPos() or ents.FindByClass("info_player_terrorist")
end

--[[---------------------------------------------------------
    Name: player:ApplyModel()
    Desc: Applies a default player model based on the player's team
-----------------------------------------------------------]]
function ply:ApplyModel()
    if self:IsWarden() then
        self:SetModel(wardenModels[math.random(#wardenModels)])
    else
        local teamModels = models[self:Team()]
        if not teamModels then return end
        local designatedModel = teamModels[math.random(#teamModels)]
        self:SetModel(designatedModel)
    end
end

--[[---------------------------------------------------------
    Name: player:Setup()
    Desc: Initializes the player and assigns them
-----------------------------------------------------------]]
function ply:Setup()
    if self:Team() == TEAM_UNASSIGNED then
        self:SetTeam(TEAM_PRISONERS)
        self:KillSilent()
    end

    self:ShouldDropWeapon(true)
    self:SetPos(self:GetSpawnPos())
    self:SetupHealth()
    self.health = self:Health()
    self:SendSpawned()
end

hook.Add("PlayerSpawn", "OnPlayerSpawn", function(pl)
    if pl:Alive() then
        pl:Setup()
    end
end)

function ply:SendSpawned()
    net.Start("PlayerSpawned")
    net.Send(self)
end

hook.Add("PlayerDeath", "SendPlayerDied", function(ply, item, killer)
    net.Start("PlayerNoticeDied")
    net.WriteEntity(ply)
    net.WriteEntity(killer)
    net.Broadcast()
end)

hook.Add("PlayerInitialSpawn", "SendPlayerJoined", function()
    net.Start("PlayerJoined")
    net.Broadcast()
end)

hook.Add("PlayerInitialSpawn", "DisableDeathNotice", function(ply)
    ply:ConCommand("hud_deathnotice_time 0")
end)

function GM:PlayerSetModel( ply )
    ply:ApplyModel()
    local col = team.GetColor(ply:Team())
    ply:SetPlayerColor(Vector(col.r / 255, col.g / 255, col.b / 255))
end