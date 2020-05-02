if SERVER then
    util.AddNetworkString("SendHighlights")
    util.AddNetworkString("SentHighlightedPlayers")

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

    function JB:HighlightPlayers(players, tableName)
        if not players then return end
        net.Start("SentHighlightedPlayers")
        net.WriteString(tableName and tableName or "undefined")
        net.WriteTable(players)
        net.Broadcast()
    end
end

if CLIENT then
    local entList = {}
    local highlightPlayers = {}

    hook.Add("PreDrawHalos", "HighlightPlayers", function()
        for k, v in pairs(entList) do
            if v:Alive() then
                halo.Add({v}, team.GetColor(v:Team()), 1, 1, 2, true, true)
            end
        end

        for k, v in pairs(highlightPlayers) do
            for i, j in pairs(v) do
                if j.Player:Alive() then
                    halo.Add({j.Player}, j.Color,  1, 1, 2, true, true)
                end
            end
        end
    end)

    net.Receive("SendHighlights", function()
        entList = net.ReadTable()
    end)

    net.Receive("SentHighlightedPlayers", function() 
        local tableName = net.ReadString()
        local players  = net.ReadTable()
        highlightPlayers[tableName] = players
    end)
end