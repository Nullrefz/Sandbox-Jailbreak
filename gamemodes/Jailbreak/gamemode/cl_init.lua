include('sh_init.lua')
activeCommands = {}
warden = nil

net.Receive('UpdateCommands', function()
    activeCommands = net.ReadTable()
end)

net.Receive('OnWardenSet', function()
    warden = player.GetBySteamID(net.ReadString())
    print(warden)
end)