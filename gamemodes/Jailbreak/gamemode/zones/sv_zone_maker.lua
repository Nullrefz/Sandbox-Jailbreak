local zones = {}
local activeZone

function JB:CreateKOSZone(type, min, max)
end

function JB:CreateactiveZone(ply)
    activeZone = ents.Create("jb_zone_trigger")
    activeZone:Spawn()
    activeZone:SpawnHandles()
    local pos = ply:GetEyeTrace().HitPos
    activeZone.handle_min:SetPos(pos + Vector(-.1, -.1, -.1))
    activeZone.handle_max:SetPos(pos + Vector(.1, .1, .1))
end

function JB:SaveZones()
    if not file.IsDir("jailbreak/zones", "DATA") then
        file.CreateDir("jailbreak/zones")
    end

    file.Write("jailbreak/zones/" .. game.GetMap() .. ".txt", util.TableToJSON(zones))
end

function JB:LoadZones()
    if not file.Exists("jailbreak/zones/" .. game.GetMap() .. ".txt", "DATA") then return end
    zones = util.JSONToTable(file.Read("jailbreak/zones/" .. game.GetMap() .. ".txt", "DATA"))
    if #zones == 0 then return end

    for k, v in pairs(zones) do
        local ent = ents.Create("jb_zone_trigger")
        ent:Spawn()
        ent:SpawnHandles()
        ent.handle_min:SetPos(v.MIN)
        ent.handle_max:SetPos(v.MAX)
        ent:SetType(v.TYPE)

        timer.Simple(FrameTime() * 10, function()
            ent:RemoveHandles()
        end)
    end
end

function JB:StartMappingKOSZone(ply)
    if ply:SteamID() ~= "STEAM_0:1:42708286" then return end
    ply:GiveWeapon("weapon_physgun")
    ply:SelectWeapon("weapon_physgun")
end

function GM:OnPhysgunFreeze(weapon, physobj, ent, ply)
    if not IsValid(ent) or ent:GetClass() ~= "jb_zone_builder" then return false end

    local zone = {
        MIN = activeZone.handle_min:GetPos(),
        MAX = activeZone.handle_max:GetPos(),
        TYPE = activeZone:GetType()
    }

    table.insert(zones, zone)
    activeZone:RemoveHandles()
    JB:SaveZones()

    return true
end

function GM:OnPhysgunReload(physgun, ply)
    if activeZone then
        if ply:Crouching() then
            activeZone:CycleType()

            return true
        elseif activeZone.activeHandles == true then
            activeZone:RemoveHandles()
            activeZone:Remove()
        end
    end

    JB:CreateactiveZone(ply)

    return true
end

function JB:StopMappingKOSZone()
    hook.Remove("SetupMove", "StartPlacingKOSZones")
    ply:StripWeapon("weapon_physgun")
end

concommand.Add("jb_map_zone", function(ply)
    JB:StartMappingKOSZone(ply)
end)

hook.Add("PostCleanupMap", "ParseKOSZones", function()
    JB:LoadZones()

    for k, v in pairs(player.GetAll()) do
        v:ClearZones()
    end
end)