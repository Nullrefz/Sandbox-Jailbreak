lastRequestMenu = {"TicTacToe", "knifeBattle", "freeday", "calendar", "sniper battle", "custom"}

function JB:AddLRMenu()
    local slots = {}

    for k, v in pairs(lastRequestMenu) do
        local slot = {}
        slot.NAME = v
        slot.CLOSE = true

        if v == "calendar" or v == "challenge" then
            slot.ACTION = function()
                JB:OpenMenu(v)
            end
        else
            slot.ACTION = function()
                JB:SendLR(v)
            end
        end

        slot.COLOR = Color(255, 255, 255)
        table.insert(slots, slot)
    end

    return self:RegisterMenu(slots, "lastrequest")
end

function JB:SendTicTacToe()
    net.Start("SendTicTacToe")
    net.SendToServer()
end

function JB:SendKnifeBattle()
    net.Start("SendKnifeBattle")
    net.SendToServer()
end

function JB:SendExclusiveFreeday()
    net.Start("SendExclusiveFreeday")
    net.SendToServer()
end

function JB:SendLR(lastRequest)
    net.Start("SendLR")
    net.WriteString(lastRequest)
    net.SendToServer()
end

hook.Add("JB_Initialize", "AddLRMenu", function()
    JB:AddLRMenu()
end)