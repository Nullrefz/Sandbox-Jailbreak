competitionMenu = {"first last reaction", "simon say's", "simon say's machine", "red light green light", "snitch", "games room", "custom"}
activeCommands = {}

function JB:AddCompetitionMenu()
    local slots = {}

    for k, v in pairs(competitionMenu) do
        local slot = {}
        slot.NAME = v
        slot.CLOSE = true

        slot.ACTION = function()
            if LocalPlayer():Team() == Team.GUARDS then
                JB:SendCompetition(v)
            else
                JB:SendLR(v)
            end
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

hook.Add("JB_Initialize", "AddCompetitionMenu", function()
    JB:AddCompetitionMenu()
end)