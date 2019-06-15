include('sh_init.lua')
activeCommands = {}

net.Receive("UpdateCommands", function()
    activeCommands = net.ReadTable()
end)