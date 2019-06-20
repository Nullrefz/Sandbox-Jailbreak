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
        ply:GiveWeapon("weapon_fists")
    end
    
    net.Receive("DropWeapon", function(ln, ply)
        if not IsValid(ply) and ply:GetActiveWeapon():IsValid() then return end
        ply:DropWeapon(ply:GetActiveWeapon())
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
        print(ply:GetPos():Distance(wep:GetPos()))
        if ply:HasWeapon(JB:GetWeapon(wep)) or ply:HasWeapon(wep:GetClass()) and ply:GetPos():Distance(wep:GetPos()) < 100 then return end
        ply:Give(wep:GetClass())
        wep:Remove()
    end

    local ply = FindMetaTable("Player")
    
    --TODO: Find a better sollution
    function ply:GiveWeapon(weapon)
        self.canPick = true
        ply:Give(weapon)
        self.canPick = false
    end
end

if CLIENT then
    --TODO: Move weapon pickup notify and weapon highlight here
end