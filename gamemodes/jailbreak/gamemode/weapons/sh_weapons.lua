if SERVER then
    util.AddNetworkString("DropWeapon")

    hook.Add("KeyPress", "PickupWeapons", function(ply, key)
        if (key == IN_USE) then
            ply.canPick = true
        else
            ply.canPick = false
        end
    end)

    function GM:PlayerLoadout(ply)
        ply:StripWeapons()
        ply:GiveWeapon("weapon_empty")
        ply:GiveWeapon("weapon_fists")
        ply:SetActiveWeapon(ply:GetWeapon("weapon_empty"))
        ply:SetActiveWeapon()

        if JB.round.activePhase == ROUND_WAITING then
            ply:GiveWeapon("weapon_tool")
            ply:SetActiveWeapon(ply:GetWeapon("weapon_tool"))
        end
    end

    hook.Add("PlayerSetWarden", "GiveTool", function(oldWarden, newWarden)
        if IsValid(oldWarden) then
            oldWarden:StripWeapon("weapon_crowbar")
        end

        if IsValid(newWarden) then
            newWarden:GiveWeapon("weapon_tool")
        end
    end)

    -- Putting things in a function didn't work so had to hardcode 

    function GM:PlayerSpawnProp(ply, model)
        return ply:IsWarden() or JB.round.activePhase == ROUND_WAITING and ply:Alive()
    end

    function GM:PlayerSpawnNPC(ply, model)
        return ply:IsWarden() or JB.round.activePhase == ROUND_WAITING and ply:Alive()
    end

    function GM:PlayerSpawnVehicle(ply, model)
        return ply:IsWarden() or JB.round.activePhase == ROUND_WAITING and ply:Alive()
    end

    function GM:PlayerSpawnSENT(ply, model)
        return ply:IsWarden() or JB.round.activePhase == ROUND_WAITING and ply:Alive()
    end

    function GM:PlayerSpawnSWEP(ply, model)
        return ply:IsWarden() or JB.round.activePhase == ROUND_WAITING and ply:Alive()
    end

    -- sorry
    net.Receive("DropWeapon", function(ln, ply)
        if not IsValid(ply) or not ply:GetActiveWeapon():IsValid() then return end

        if ply:GetActiveWeapon().CanDrop then
            ply:DropWeapon(ply:GetActiveWeapon())
        end
    end)

    hook.Add("PlayerCanPickupWeapon", "PickupLogic", function(ply, wep)
        if ply:HasWeapon(JB:GetWeapon(wep)) or ply:HasWeapon(wep:GetClass()) or not ply.canPick then return false end

        if JB:ValidateWeapon(ply, wep) then
            wep:Remove()

            return false
        end

        return true
    end)

    function JB:LookingAtWeapon(gazing)
        lookingAtWeapon = gazing
    end

    function JB:PickUpWeapon(ply, wep)
        if ply:HasWeapon(JB:GetWeapon(wep)) or ply:HasWeapon(wep:GetClass()) and ply:GetPos():Distance(wep:GetPos()) < 100 then return end
        ply:Give(wep:GetClass())
        wep:Remove()
    end

    local ply = FindMetaTable("Player")

    function ply:GiveWeapon(weapon)
        self.canPick = true
        self:Give(weapon)
        self.canPick = false
    end
end

if CLIENT then end