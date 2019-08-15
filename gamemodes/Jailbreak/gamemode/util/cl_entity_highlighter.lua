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