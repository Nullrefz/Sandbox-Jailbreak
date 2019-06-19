local reregister = {}

local function reregisterWeapon(old, new)
    reregister[old] = new
end

reregisterWeapon("weapon_hegrenade", "weapon_jb_m4a1")
reregisterWeapon("weapon_smokegrenade", "weapon_jb_m4a1")
reregisterWeapon("weapon_flashbang", "weapon_jb_m4a1")
reregisterWeapon("item_assaultsuit", "weapon_jb_knife")
reregisterWeapon("weapon_c4", "weapon_jb_m4a1")
reregisterWeapon("info_ladder", "weapon_jb_knife")
reregisterWeapon("weapon_ak47", "weapon_jb_ak47")
reregisterWeapon("weapon_aug", "weapon_jb_m4a1")
reregisterWeapon("weapon_awp", "weapon_jb_awp")
reregisterWeapon("weapon_deagle", "weapon_jb_deagle")
reregisterWeapon("weapon_elite", "weapon_jb_usp")
reregisterWeapon("weapon_famas", "weapon_jb_famas")
reregisterWeapon("weapon_fiveseven", "weapon_jb_fiveseven")
reregisterWeapon("weapon_g3sg1", "weapon_jb_m3")
reregisterWeapon("weapon_galil", "weapon_jb_galil")
reregisterWeapon("weapon_glock", "weapon_jb_glock")
reregisterWeapon("weapon_m249", "weapon_jb_scout")
reregisterWeapon("weapon_m3", "weapon_jb_m3")
reregisterWeapon("weapon_m4a1", "weapon_jb_m4a1")
reregisterWeapon("weapon_mac10", "weapon_jb_mac10")
reregisterWeapon("weapon_mp5navy", "weapon_jb_mp5navy")
reregisterWeapon("weapon_p228", "weapon_p228")
reregisterWeapon("weapon_p90", "weapon_jb_p90")
reregisterWeapon("weapon_scout", "weapon_jb_scout")
reregisterWeapon("weapon_sg550", "weapon_jb_scout")
reregisterWeapon("weapon_sg552", "weapon_jb_sg552")
reregisterWeapon("weapon_tmp", "weapon_jb_tmp")
reregisterWeapon("weapon_ump45", "weapon_jb_ump45")
reregisterWeapon("weapon_usp", "weapon_jb_usp")
reregisterWeapon("weapon_xm1014", "weapon_jb_scout")
reregisterWeapon("weapon_knife", "weapon_jb_knife")
reregisterWeapon("weapon_hegrenade", "weapon_jb_knife")
reregisterWeapon("weapon_smokegrenade", "weapon_jb_knife")
reregisterWeapon("weapon_flashbang", "weapon_jb_knife")

hook.Add("Initialize", "JB.Initialize.ReplaceCSSWeapons", function()
    for k, v in pairs(reregister) do
        weapons.Register({
            Base = v,
            IsDropped = true
        }, string.lower(k), false)
    end
end)

function JB:ValidateWeapon(ply, entity)
    if reregister[entity:GetClass()] then
        ply:Give(reregister[entity:GetClass()])

        return true
    end

    return false
end

function JB:GetWeapon(weapon)
    if reregister[weapon:GetClass()] then return reregister[weapon:GetClass()] end
    return ""
end

