competitionMenu = {"firstlastreaction", "simonsay's", "redgreenlight", "snitch", "gamesRoom", "custom"}

if CLIENT then
    function JB:AddCompetitionMenu()
        local slots = {}

        for k, v in pairs(competitionMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            slot.ACTION = function()
                JB:SendCompetition(v)
            end

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots, "competition")
    end

    function JB:SendCompetition(name)
        net.Start("SendCompetition")
        net.WriteString(name)
        net.SendToServer()
    end
    hook.Add("Initialize", "AddCompetitionMenu", function()
        JB:AddCompetitionMenu()
    end)
end

if SERVER then
    util.AddNetworkString("SendCompetition")
    net.Receive("SendCompetition", function(ln, ply) end)
end