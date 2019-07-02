GM.Name = "Jailbreak"
GM.Author = "Nullrefz"
GM.Email = "davidmoussa@outlook.com"
GM.Website = "N/A"
JB = {}

PING = {
    ["BEST"] = 0,
    ["GOOD"] = 60,
    ["MID"] = 100,
    ["BAD"] = 150
}

Team = {
    PRISONERS = 1,
    GUARDS = 2,
    SPECTATORS = 3
}

team.SetUp(1, "Prisoners", Color(255, 89, 50))
team.SetUp(2, "Guards", Color(50, 185, 255))
TEAM_PRISONERS = 1
TEAM_GUARDS = 2
TEAM_SPECTATORS = 1002
local gmDir = "jailbreak/gamemode"

--[[---------------------------------------------------------
    Name: jailbreak:AutoInclude()
    Desc: Includes server, client, and shared files
-----------------------------------------------------------]]
function JB:AutoInclude(dir)
    if not dir then
        dir = gmDir
    end

    local files, directories = file.Find(dir .. "/*", "LUA")

    for k, v in pairs(directories) do
        self:AutoInclude(dir .. "/" .. v)
    end

    if (dir ~= gmDir) then
        for k, v in pairs(files) do
            local path = string.gsub(dir, gmDir .. "/", "", 2) .. "/" .. v

            if string.StartWith(v, "cl_") then
                if SERVER then
                    AddCSLuaFile(path)
                elseif CLIENT then
                    include(path)
                end
            elseif string.StartWith(v, "sv_") then
                if SERVER then
                    include(path)
                end
            else
                if SERVER then
                    AddCSLuaFile(path)
                    include(path)
                elseif CLIENT then
                    include(path)
                end
            end
        end
    else
        hook.Run("JB_Initialize")
    end
end

JB:AutoInclude()