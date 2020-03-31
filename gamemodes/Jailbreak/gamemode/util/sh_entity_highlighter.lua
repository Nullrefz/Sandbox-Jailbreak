if SERVER then
    util.AddNetworkString("SendHighlights")

    function JB:HighlightPlayer(players, targets)
        net.Start("SendHighlights")

        if players then
            net.WriteTable(players)
        else
            net.WriteTable({})
        end

        if targets then
            for k, v in pairs(targets) do
                net.Send(v)
            end
        else
            net.Broadcast()
        end
    end
end

if CLIENT then
    local entList = {}

    hook.Add("PreDrawHalos", "HighlightPlayers", function()
        for k, v in pairs(entList) do
            if v:Alive() then
                halo.Add({v}, team.GetColor(v:Team()), 1, 1, 2, true, true)
            end
        end
    end)

    net.Receive("SendHighlights", function()
        entList = net.ReadTable()
    end)
end