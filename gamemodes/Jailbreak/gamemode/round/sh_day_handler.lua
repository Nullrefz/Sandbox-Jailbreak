Days = {"freeday", "warday", "hidenseek", "purgeday"}

if SERVER then

    function JB:StartFreeDay()
        self:OpenCells()
    end

    function JB:StartWarday()
    end

    function JB:StartHideNSeek()
    end

    hook.Add("WardenRevoked", "WardenKilled", function()
        if JB:GetActivePhase() == ROUND_ACTIVE then
            JB:StartFreeDay()
        end
    end)
end