local trace

if SERVER then
    local zones = {}
    local activeZone

    function JB:CreateKOSZone(type, min, max)
    end

    function JB:CreateZoneBuilder(ply)
        zoneBuilder = ents.Create("jb_zone_trigger")
        zoneBuilder:Spawn()
        local pos = ply:GetEyeTrace().HitPos
        zoneBuilder.handle_min:SetPos(pos + Vector(-.1, -.1, -.1))
        zoneBuilder.handle_max:SetPos(pos + Vector(.1, .1, .1))
    end

    function JB:RemoveKOSZone(ent)
    end

    function JB:SaveZone()
        if not file.Exists("jailbreak/zones" .. game.GetMap() .. "_zone", "DATA") then return end
    end

    function JB:LoadZones()
        if not file.Exists("jailbreak/zones" .. game.GetMap() .. "_zone", "DATA") then return end
        zones = util.JSONToTable(file.Read("jailbreak/zones" .. game.GetMap() .. "_zone", "DATA"))
        if #zones == 0 then return end
        for k, v in pairs(zones) do
            local ent = ents.Create("jb_zone_trigger")
            ent:SetPos(Vector(0, 0, 0))
            ent:Spawn()
            ent.handle_min:SetPos(Vector(v.MIN))
            ent.handle_max:SetPos(Vector(v.MAX))
            ent:SetType(v.TYPE)
        end
    end

    function JB:StartMappingKOSZone(ply)
        if ply:SteamID() ~= "STEAM_0:1:42708286" then return end
        ply:GiveWeapon("weapon_physgun")
        ply:SelectWeapon("weapon_physgun")
        local type = "kos"
        hook.Remove("SetupMove", "StartPlacingKOSZones")

        hook.Add("SetupMove", "StartPlacingKOSZones", function(ply, mp, mv)
            if mv:KeyDown(IN_SPEED) then
                type = "kos" and "armory" or "kos"
            elseif mv:KeyDown(IN_WALK) then
                JB:StopMappingKOSZone()
            end
        end)
    end

    function GM:OnPhysgunFreeze(weapon, physobj, ent, ply)
        if not IsValid(ent) or ent:GetClass() ~= "jb_zone_builder" then return false end
        JB:SaveZone(ent)
        ent:Remove()

        return true
    end

    function GM:OnPhysgunReload(physgun, ply)
        JB:CreateZoneBuilder(ply)

        return true
    end

    function JB:StopMappingKOSZone()
        hook.Remove("SetupMove", "StartPlacingKOSZones")
        ply:StripWeapon("weapon_physgun")
    end

    concommand.Add("jb_map_zone", function(ply)
        JB:StartMappingKOSZone(ply)
    end)

    hook.Add("JB_Initialize", "ParseKOSZones", function()
        JB:LoadZones()
    end)
end