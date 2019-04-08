include('sh_init.lua')

local hide = {CHudAmmo == true, CHudBattery == true, CHudChat == true, CHudCrosshair == true, CHudDamageIndicator == true, CHudDeathNotice == true, CHudHealth == true, CHudPoisonDamageIndicator == true, CHudSecondaryAmmo == true, CHudSquadStatus == true, CHudTrain == true, CHudWeaponSelection == true, CHudZoom == true}

function HideEverything(element)
    if hide[element] then return false end
end

hook.Add('HUDShouldDraw', 'HideHUD', HideEverything)


CreateClientConVar('gb_angle', 45, true, true)
CreateClientConVar('gb_camera_distance', 300, true, true)
CreateClientConVar('gb_camera_z', 90, true, true)