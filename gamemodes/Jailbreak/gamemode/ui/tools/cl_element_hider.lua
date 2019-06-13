local hide = {
    -- CHudAmmo = true,
     CHudBattery = true,
    -- CHudChat = true,
    -- CHudCrosshair = true,
    -- CHudDamageIndicator = true,
    -- CHudDeathNotice = true,
    CHudHealth = true
}

-- CHudPoisonDamageIndicator = true,
-- CHudSecondaryAmmo = true,
-- CHudSquadStatus = true,
-- CHudTrain = true,
-- CHudWeaponSelection = true,
-- CHudZoom = true
function HideEverything(element)
    if hide[element] then return false end
end

hook.Add("HUDShouldDraw", "HideHUD", HideEverything)