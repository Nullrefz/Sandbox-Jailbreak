local trace

if SERVER then
    local spawnedZones = {}
    local zoneFile = ""
    function JB:CreateKOSZone(type, min, max)
    end

    function JB:RemoveKOSZone(ent)
    end

    function JB:WriteZones()
    end

    function JB:ReadZones()
        if not file.Exists( "jailbreak/zones", "DATA" ) then
            file.Write("jailbreak/zones.txt", "")
        end
    end

    function JB:StartMappingKOSZone(ply)
        if ply:SteamID() ~= "STEAM_0:1:42708286" then return end
        ply:GiveWeapon("weapon_physgun")
        ply:SelectWeapon("weapon_physgun")
        local min = false
        local max = false
        local type = "kos"

        hook.Add("SetupMove", "StartPlacingKOSZones", function(ply, mv)
            if mv:KeyDown(IN_ATTACK) then
                local tr = util.TraceLine({
                    start = ply:EyePos(),
                    endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000
                })

                if min == 0 then
                    min = tr.HitPos
                elseif max == 0 then
                    max = tr.HitPos
                    JB:CreateKOSZone(type, min, max)
                    min = 0
                    max = 0
                end
            elseif mv:KeyDown(IN_ATTACK2) then
                min = 0
                max = 0
            elseif mv:KeyDown(IN_USE) then
                JB:CreateKOSZone(type, min, max)
            elseif mv:KeyDown(IN_RELOAD) then
                JB:RemoveKOSZone(ent) -- trace
            elseif mv:KeyDown(IN_SPEED) then
                type = "kos" and "armory" or "kos"
            elseif mv:KeyDown(IN_WALK) then
                JB:StopMappingKOSZone()
            end
        end)
    end

    function JB:StopMappingKOSZone()
        hook.Remove("SetupMove", "StartPlacingKOSZones")
        ply:StripWeapon("weapon_physgun")
    end

    concommand.Add("jb_map_zone", function(ply)
        JB:StartMappingKOSZone(ply)
    end)

    hook.Add("JB_Initialize", "ParseKOSZones", function()
        JB:ReadZones()
    end)
end