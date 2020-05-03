if SERVER then
    util.AddNetworkString("InitiateWardenVote")
    util.AddNetworkString("UpdateWardenVoteResults")
    util.AddNetworkString("BreakWardenVote")
    util.AddNetworkString("NominateGuard")
    util.AddNetworkString("DenominateGuard")
    util.AddNetworkString("SendWardenVote")
    local constituents = {}
    local nominees = {}
    local voteTree = {}

    function JB:VoteRunning()
        return self.voteActive
    end

    function JB:InitiateVote()
        nominees = self:GetNominee()
        print(#nominees)
        if #nominees == 0 then return end
        self.voteActive = true
        constituents = player.GetAll()

        if self.warden then
            self:RevokeWarden()
        end

        net.Start("InitiateWardenVote")
        local entries = {}

        for k, v in pairs(nominees) do
            v.guardVoteCount = 0
            v.prisonerVoteCount = 0

            table.insert(entries, {
                NOMINEE = v:SteamID(),
                GUARDVOTE = v.guardVoteCount,
                PRISONERVOTE = v.prisonerVoteCount,
                TOTAL = v.guardVoteCount + v.prisonerVoteCount * ((math.Clamp(GetConVar("jb_warden_prisoners_vote_percentage"):GetInt(), 0, 100)) / 100)
            })
        end

        net.WriteTable(entries)
        net.WriteInt(GetConVar("jb_round_ending"):GetInt(), 32)
        net.WriteFloat(GetConVar("jb_warden_prisoners_vote_percentage"):GetFloat() / 100)
        net.Broadcast()

        timer.Simple(GetConVar("jb_round_ending"):GetInt(), function()
            if self.voteActive then
                self:ConcludeVote()
            end
        end)
    end

    hook.Add("jb_round_ending", "StartWardenVote", function()
        for k, v in pairs(team.GetPlayers(TEAM_GUARDS)) do
            if not v:IsBot() then
                JB:Nominate(v)
            end
        end

        JB:InitiateVote()
    end)

    function JB:ConcludeVote()
        self:BreakVote()
        local score = {}

        for k, v in pairs(nominees) do
            table.insert(score, {
                pl = v,
                Score = v.guardVoteCount * (GetConVar("jb_warden_prisoners_vote_percentage"):GetFloat() / 100) + v.prisonerVoteCount * (1 - (GetConVar("jb_warden_prisoners_vote_percentage"):GetFloat() / 100))
            })
        end

        table.sort(score, function(a, b) return a.Score > b.Score end)
        constituents = {}
    end

    function JB:CountVotes()
        local result = {}

        for k, v in pairs(nominees) do
            table.insert(result, {
                NOMINEE = v:SteamID(),
                GUARDVOTE = v.guardVoteCount,
                PRISONERVOTE = v.prisonerVoteCount,
                TOTAL = v.guardVoteCount + v.prisonerVoteCount * ((math.Clamp(GetConVar("jb_warden_prisoners_vote_percentage"):GetInt(), 0, 100)) / 100)
            })
        end

        --table.SortByMember(result, "Total")
        self:SendUpdatedValues(result)
    end

    function JB:SendUpdatedValues(result)
        for k, v in pairs(player.GetAll()) do
            if table.HasValue(constituents, v) then
                net.Start("UpdateWardenVoteResults")
                net.WriteTable(result)
                net.Send(v)
            end
        end
    end

    function JB:BreakVote()
        self.voteActive = false
        net.Start("BreakWardenVote")
        net.Broadcast()
    end

    function JB:ValidateVotes()
        if not self.voteActive then return end

        for k, v in pairs(nominees) do
            if v:Team() ~= TEAM_GUARDS then
                table.remove(nominees, guard)
            end
        end

        if #nominees > 0 then return end
        self:BreakVote()
    end

    hook.Add("PlayerChangedTeam", "CheckGuards", function()
        JB:ValidateVotes()
    end)

    function JB:CastVote(voter, candidate)
        if not table.HasValue(constituents, voter) then return end

        --table.RemoveByValue(constituents, voter)
        if voter:Team() == TEAM_PRISONERS then
            candidate.prisonerVoteCount = candidate.prisonerVoteCount + 1
        elseif voter:Team() == TEAM_GUARDS then
            candidate.guardVoteCount = candidate.guardVoteCount + 1
        end

        self:CountVotes()
    end

    net.Receive("SendWardenVote", function(ln, ply)
        JB:CastVote(ply, player.GetBySteamID(net.ReadString()))
    end)

    function JB:Nominate(nominee, ply)
        if not IsValid(ply) then return end
        local ind = ply:SteamID()

        if not voteTree.ind then
            voteTree.ind = {}
        end

        if not table.HasValue(voteTree.ind, nominee) then
            table.insert(voteTree.ind, nominee)
            print("nominated " .. nominee:Name())
        end

        if ply:Team() ~= TEAM_GUARDS or table.HasValue(nominees, ply) then return end
        table.insert(nominees, ply)
    end

    function JB:Denominate(nominee, ply)
        if not IsValid(ply) then return end
        local ind = ply:SteamID()
        if not voteTree.ind then return end

        if table.HasValue(voteTree.ind, nominee) then
            table.RemoveByValue(voteTree.ind, nominee)
            print("denominated " .. nominee:Name())
        end
    end

    function JB:GetNominee()
        local nominated = {}

        for k, v in pairs(voteTree) do
            PrintTable(v)
            for k2, v2 in pairs(v) do
                if not table.HasValue(nominated, v2) and IsValid(v2) and v2:Team() == TEAM_GUARDS then
                    table.insert(nominated, v2)
                end
            end
        end

        return nominated
    end

    net.Receive("NominateGuard", function(ln, ply)
        JB:Nominate(net.ReadEntity(), ply)
    end)

    net.Receive("DenominateGuard", function(ln, ply)
        JB:Denominate(net.ReadEntity(), ply)
    end)
end

if CLIENT then
    function JB:Denominate(ply)
        net.Start("NominateGuard")
        net.WriteEntity(ply)
        net.SendToServer()
    end

    function JB:Nominate(ply)
        net.Start("DenominateGuard")
        net.WriteEntity(ply)
        net.SendToServer()
    end
end