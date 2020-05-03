local JAILBREAKWARDENVOTE = {}
local entries = {}

function JAILBREAKWARDENVOTE:Init()
    self.panel = vgui.Create("DGrid", self)
    self.panel:MakePopup()
    self.panel:Dock(FILL)
    self.panel:SetCols(#entries)
    self.panel:SetColWide(w / self.panel:GetCols())
    self.panel:SetRowHeight(h / (math.ceil(#entries / self.panel:GetCols())))

    function self.panel:Paint()
    end

    self.slots = {}

    for k, v in pairs(entries) do
        local card = vgui.Create("JailbreakWardenCard")
        card:SetSize(self.panel:GetColWide(), self.panel:GetRowHeight())
        card:Player(player.GetBySteamID(v.NOMINEE))
        card:SetVoteValue(v.GUARDVOTE, v.PRISONERVOTE)
        self.panel:AddItem(card)
        table.insert(self.slots, card)
    end

    function self:UpdateResult()
        for k, v in pairs(self.slots) do
            if v:Player():SteamID() ~= entries[k].NOMINEE then
                print("Some PLayers Are Not in the Vote DO SOMETHIN!")
            end

            v:SetVoteValue(entries[k].GUARDVOTE, entries[k].PRISONERVOTE)
        end
    end

    net.Receive("UpdateWardenVoteResults", function()
        entries = net.ReadTable()

        if IsValid(self) then
            self:UpdateResult()
        end
    end)
end

function JAILBREAKWARDENVOTE:PerformLayout(width, height) 

end

vgui.Register("JailbreakWardenVote", JAILBREAKWARDENVOTE)
JB.WardenVote = {}

function JB.WardenVote:Show()
    self.VotePanel = vgui.Create("JailbreakWardenVote")
    self.VotePanel:SetSize(w, h)
    self.VotePanel:SetPos(0, 0)

    JB.WardenVote.Hide = function()
        self.VotePanel:Clear()
        self.VotePanel:Remove()
    end
end

net.Receive("InitiateWardenVote", function()
    entries = net.ReadTable()

    if (#entries > 0) then
        JB.WardenVote:Show()
    end
end)

net.Receive("BreakWardenVote", function()
    JB.WardenVote:Hide()
end)