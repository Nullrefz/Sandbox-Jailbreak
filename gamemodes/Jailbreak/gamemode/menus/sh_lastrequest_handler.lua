lastRequestMenu = {"TicTacToe", "knifeBattle", "freeday", "exclusivefreeday", "calendar", "challenge", "custom"}

if CLIENT then
    function JB:AddActionsMenu()
        local slots = {}

        for k, v in pairs(lastRequestMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            if v == "TicTacToe" then
                slot.ACTION = function()
                    JB:SendTicTacToe()
                end
            elseif v == "knifeBattle" then
                slot.ACTION = function()
                    JB:SendKnifeBattle()
                end
            elseif v == "freeday" then
                slot.ACTION = function()
                    JB:SendFreeday()
                end
            elseif v == "exclusivefreeday" then
                slot.ACTION = function()
                    JB:SendExclusiveFreeday()
                end
            elseif v == "calendar" or v == "challenge" then
                slot.ACTION = function()
                    JB:OpenMenu(v)
                end
            elseif v == "custom" then
                slot.ACTION = function()
                    JB:SendCustomLR()
                end
            end

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots)
    end

    function JB:SendTicTacToe()
        net.Start("SendTicTacToe")
        net.Send()
    end

    function JB:SendKnifeBattle()
        net.Start("SendKnifeBattle")
        net.Send()
    end

    function JB:SendExclusiveFreeday()
        net.Start("SendExclusiveFreeday")
        net.Send()
    end

    function JB:SendCustomLR()
        net.Start("SendCustomLR")
        net.Send()
    end
end

if SERVER then
    util.AddNetworkString("SendTicTacToe")
    util.AddNetworkString("SendKnifeBattle")
    util.AddNetworkString("SendExclusiveFreeday")
    util.AddNetworkString("SendCustomLR")
    net.Receive("SendTicTacToe", function(ln, ply) end)
    net.Receive("SendKnifeBattle", function(ln, ply) end)
    net.Receive("SendExclusiveFreeday", function(ln, ply) end)
    net.Receive("SendCustomLR", function(ln, ply) end)
end