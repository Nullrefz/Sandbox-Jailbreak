if SERVER then
    util.AddNetworkString("SetDay")
    util.AddNetworkString("SendDay")

    net.Receive("SendDay", function(ln, ply)
        local day = net.ReadString()
        print(day)

        if day == "freeday" then
            JB:SetFreeday()
        elseif day == "warday" then
            JB:SetWarday()
        elseif day == "hidenseek" then
            JB:HideNSeek()
        elseif day == "weepingangels" then
            JB:WeepingAngels()
        end
    end)

    -- hook.Add("WardenRevoked", "WardenKilled", function()
    --     if JB:GetActivePhase() == ROUND_ACTIVE then
    --         JB:SetFreeday()
    --     end
    -- end)
    function JB:SetFreeday()
        self:OpenCells()
        self:RevokeWarden()
        self:SetDayPhase("Freeday", self:GetTimeLeft())

        local notification = {
            TEXT = "It's a Freeday!!!!!",
            TYPE = 2,
            TIME = 5
        }

        self:SendNotification(notification)
        Entity(1):EmitSound("jailbreak/wow.mp3")
    end

    function JB:SetWarday()
        self:SetDayPhase("Starting Warday", 3)

        timer.Simple(3, function()
            self:OpenCells()
            self:SetDayPhase("Warday", self:GetTimeLeft())
        end)
    end

    function JB:HideNSeek()
        self:OpenCells()
        self:SetDayPhase("Prisoners Hiding", 30)

        timer.Simple(30, function()
            self:SetDayPhase("Hide And Seek", self:GetTimeLeft())
        end)
    end

    function JB:WeepingAngels()
        self:SetDayPhase("WeepingAngels", self:GetTimeLeft())
    end

    function JB:SetDayPhase(name, dayTime)
        net.Start("SetDay")
        net.WriteString(name)
        net.WriteFloat(dayTime)
        net.Broadcast()
    end

    concommand.Add("jb_joygasm", function(ply, cmd, args)
        ply:EmitSound(Sound("vo/npc/female01/pain06.wav"))
        ply:Kill()
    end)
end