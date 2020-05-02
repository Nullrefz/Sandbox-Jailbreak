challengeMenu = {"knife battle", "sniper battle"}

function JB:AddChallengeMenu()
    local slots = {}

    for k, v in pairs(challengeMenu) do
        local slot = {}
        slot.NAME = v
        slot.CLOSE = true

        slot.ACTION = function()
            JB:SendLR(v)
        end

        slot.COLOR = Color(255, 255, 255)
        table.insert(slots, slot)
    end

    return self:RegisterMenu(slots, "challenge")
end

hook.Add("JB_Initialize", "AddChallengeMenu", function()
    JB:AddChallengeMenu()
end)