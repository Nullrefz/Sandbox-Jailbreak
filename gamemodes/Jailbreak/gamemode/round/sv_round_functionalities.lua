function JB:OpenCells(ply, ent)
    if not ent then
        for k, v in pairs(ents.GetAll()) do
            if v:GetModel() == "*57" then
                ent = v
            end
        end
    end
    ent:Fire("Press")
    ent:SetPos(Vector(0, 0, 0))

    timer.Simple(0.3, function()
        ent:Remove()
    end)

    if not ply then return end

    for k, v in pairs(player.GetAll()) do
        v:ChatPrint(ply:Name() .. " opened the cell doors")
    end
end

hook.Add("PlayerUse", "DisableDoorAfterPress", function(ply, ent)
    if ent:GetClass() == "func_button" and ent:GetModel() == "*57" then
        JB:OpenCells()

        return false
    end

    return true
end)

hook.Add("EntityTakeDamage", "DisableDoorAfterButtonDamage", function(ent, dmginfo)
    if ent:GetClass() == "func_button" and ent:GetModel() == "*57" then
        JB:OpenCells(dmginfo:GetAttacker() , ent)
    end
end)