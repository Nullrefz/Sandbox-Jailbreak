include('sh_init.lua')
warden = nil
roundPhase = "Waiting"
allowedGuardCount = 0

net.Receive('UpdateCommands', function()
    activeCommands = net.ReadTable()
end)

net.Receive('OnWardenSet', function()
    warden = player.GetBySteamID(net.ReadString())
end)

function JB:CountGuards()
    return allowedGuardCount
end

net.Receive("GuardCount", function()
    allowedGuardCount = #team.GetPlayers(TEAM_GUARDS) + net.ReadInt(32)
end)

hook.Add("SpawnMenuOpen", "SpawnMenuWhitelist", function()
    if LocalPlayer() ~= warden and roundPhase ~= "Waiting" then return false end
end)

hook.Add("PlayerButtonDown", "DropWeapon", function(ply, button)
    if (button == KEY_Q) then
        net.Start("DropWeapon")
        net.SendToServer()
    end
end)