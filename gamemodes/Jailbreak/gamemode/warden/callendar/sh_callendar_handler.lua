if SERVER then
    JB.dayPhase = ""
    util.AddNetworkString("SetDay")
    util.AddNetworkString("SendDay")

    net.Receive("SendDay", function(ln, ply)
        local day = net.ReadString()
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

    hook.Add("jb_round_ending", "setup waiting", function()
        JB.dayPhase = ""
    end)

    hook.Add("WardenRevoked", "WardenKilled", function()
        if JB.warden and not JB.warden:Alive() and JB:GetActivePhase() == ROUND_ACTIVE and JB.dayPhase ~= "Freeday" then
            JB:SetFreeday()
        end
    end)

    function JB:SetFreeday()
        self:OpenCells()
        self:RevokeWarden()
        self:SetDayPhase("Freeday", self:GetTimeLeft())

        local notification = {
            TEXT = "It's a Freeday!!!!!",
            TYPE = 2,
            TIME = 5,
            COLOR = Color(255, 175 ,0, 200)
        }

        self:SendNotification(notification)
        Entity(1):EmitSound("jailbreak/wow.mp3")
    end

    function JB:SetWarday()
        self:SetDayPhase("Starting Warday", 5)
        local notification = {
            TEXT = "Warday Staring Soon. Guards better hide",
            TYPE = 2,
            TIME = 5,
            COLOR = Color(255, 175 ,0, 200)
        }

        self:SendNotification(notification)
        timer.Simple(5, function()
            local notify= {
                TEXT = "Kill the other team!",
                TYPE = 2,
                TIME = 5,
                COLOR = Color(255, 175 ,0, 200)
            }
    
            self:SendNotification(notify)
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
        self.dayPhase = name
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