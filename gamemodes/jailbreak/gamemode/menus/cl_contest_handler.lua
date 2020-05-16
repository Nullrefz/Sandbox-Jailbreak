contestMenu = {"jokeday", "foodday", "trivia", "salty spitoon", "american idol", "custom"}

function JB:AddContestMenu()
    local slots = {}

    for k, v in pairs(contestMenu) do
        local slot = {}
        slot.NAME = v
        slot.CLOSE = true

        slot.ACTION = function()
            if LocalPlayer():Team() == Team.GUARDS then
                JB:SendContest(v)
            else
                JB:SendLR(v)
            end
        end

        slot.COLOR = Color(255, 255, 255)
        table.insert(slots, slot)
    end

    return self:RegisterMenu(slots, "contest")
end

function JB:SendContest(name)
    net.Start("SendContest")
    net.WriteString(name)
    net.SendToServer()
end

hook.Add("JB_Initialize", "AddContestMenu", function()
    JB:AddContestMenu()
end)