hook.Add("PlayerCanPickupWeapon", "SinglePickup", function(ply, wep)
    if (ply:HasWeapon(wep:GetClass())) then return false end
end)