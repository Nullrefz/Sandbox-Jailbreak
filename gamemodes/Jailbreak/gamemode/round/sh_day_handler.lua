if SERVER then
    util.AddNetworkString("UpdateCommands")

    daysFunction = {
        ["freeday"] = function()
            JB:OpenCells()
            JB:RemoveWarden()
        end,
        ["waraday"] = function()
            JB:OpenCells()
            JB:RemoveWarden()
        end,
        ["hidenseek"] = function()
            --Teleport Guards to Armory
            JB:OpenCells()
        end
    }

    net.Receive("SendChosenDay", function(ln, ply)
        daysFunction[table.KeyFromValue(calendar, net.ReadInt(32))]()
    end)

    hook.Add("WardenRevoked", "WardenKilled", function()
        if JB:GetActivePhase() == ROUND_ACTIVE then
            --daysFunction["freeday"]()
        end
    end)

    function JB:SetFreeday()
    end

    function JB:SetWarday()
    end

    function JB:HideNSeek()
    end

    function JB:ContestDay()
    end
end