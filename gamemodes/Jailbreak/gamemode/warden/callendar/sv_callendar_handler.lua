JB.dayPhase = ""
util.AddNetworkString("SetDay")
util.AddNetworkString("SendDay")
util.AddNetworkString("SendCompetition")
util.AddNetworkString("SendContest")

net.Receive("SendDay", function(ln, ply)
    local day = net.ReadString()

    if day == "freeday" then
        JB:SetFreeday()
    elseif day == "warday" then
        JB:SetWarday()
    elseif day == "hide & seek" then
        JB:HideNSeek()
    elseif day == "weeping angels" then
        JB:WeepingAngels()
    elseif day == "purge day" then
        JB:PurgeDay()
    end
end)

net.Receive("SendCompetition", function(ln, ply)
    JB:SetDay(net.ReadString())
end)

net.Receive("SendContest", function(ln, ply)
    JB:SetDay(net.ReadString())
end)

hook.Add("jb_round_ending", "setup waiting", function()
    JB:ResetDay()
end)

hook.Add("WardenRevoked", "WardenKilled", function()
    if JB.warden and not JB.warden:Alive() and JB:GetActivePhase() == ROUND_ACTIVE and (JB.dayPhase ~= "Freeday" or JB.dayPhase ~= "Purge Day") then
        JB:SetFreeday()
    end
end)

function JB:ResetDay()
    JB.dayPhase = ""
end

function JB:SetDay(day)
    self:SetDayPhase(day, self:GetTimeLeft())

    local notification = {
        TEXT = day,
        TYPE = 2,
        TIME = 5,
        COLOR = Color(255, 175, 0, 200)
    }

    self:SendNotification(notification)
end

function JB:SetFreeday()
    self:OpenCells()
    self:RevokeWarden()
    self:SetDayPhase("Freeday", self:GetTimeLeft())

    local notification = {
        TEXT = "It's a Freeday!!!!!",
        TYPE = 2,
        TIME = 5,
        COLOR = Color(255, 175, 0, 200)
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
        COLOR = Color(255, 175, 0, 200)
    }

    self:SendNotification(notification)

    timer.Simple(5, function()
        local notify = {
            TEXT = "Kill the other team!",
            TYPE = 2,
            TIME = 5,
            COLOR = Color(255, 175, 0, 200)
        }

        self:SendNotification(notify)
        self:OpenCells()
        self:SetDayPhase("Warday", self:GetTimeLeft())
    end)
end

function JB:HideNSeek()
    self:OpenCells()
    self:SetDayPhase("Starting Hide & Seek", 30)

    local notify = {
        TEXT = "Prisoners must hide, and guards must remain in the armory",
        TYPE = 2,
        TIME = 5,
        COLOR = Color(255, 175, 0, 200)
    }

    self:SendNotification(notify)

    for k, v in pairs(team.GetPlayers(Team.GUARDS)) do
        v:SetPos(v:GetSpawnPos())
        v:RestrictZone("armory", "You can leave the armory yet")
    end

    timer.Simple(30, function()
        self:SetDayPhase("Hide & Seek", self:GetTimeLeft())

        for k, v in pairs(team.GetPlayers(Team.GUARDS)) do
            v:ClearRestrictions()
        end

        local notification = {
            TEXT = "Ready or not, Guards will seek and destroy",
            TYPE = 2,
            TIME = 5,
            COLOR = Color(255, 175, 0, 200)
        }

        self:SendNotification(notification)
    end)
end

function JB:WeepingAngels()
    self:SetDayPhase("Preparing Weeping Angels", 15)

    local notification = {
        TEXT = "Prisoners can free roam before the day starts",
        TYPE = 2,
        TIME = 5,
        COLOR = Color(255, 175, 0, 200)
    }

    self:SendNotification(notification)

    timer.Simple(15, function()
        local notify = {
            TEXT = "All prisoners freeze!!! Don't let them see you move",
            TYPE = 2,
            TIME = 5,
            COLOR = Color(255, 175, 0, 200)
        }

        self:SendNotification(notify)
        self:OpenCells()
        self:SetDayPhase("Weeping Angels", self:GetTimeLeft())
    end)
end

function JB:SetDayPhase(name, dayTime)
    self.dayPhase = name
    net.Start("SetDay")
    net.WriteString(name)
    net.WriteFloat(dayTime)
    net.Broadcast()
end

function JB:PurgeDay()
    self:OpenCells()
    self:RevokeWarden()
    self:SetDayPhase("Purge Day", 30)

    local notify = {
        TEXT = "Purge Day... No Rules, No Limits",
        TYPE = 2,
        TIME = 5,
        COLOR = Color(255, 175, 0, 200)
    }

    self:SendNotification(notify)
end

concommand.Add("jb_joygasm", function(ply, cmd, args)
    ply:EmitSound(Sound("vo/npc/female01/pain06.wav"))
    ply:Kill()
end)