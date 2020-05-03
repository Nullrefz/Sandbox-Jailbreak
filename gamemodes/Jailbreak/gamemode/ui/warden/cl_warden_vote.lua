local JAILBREAKWARDENVOTE = {}
local entries = {}
local time = 0
JB.PrisonerWardenPercentage = 0.4

function JAILBREAKWARDENVOTE:Init()
    self.background = vgui.Create("Panel", self)
    self.header = vgui.Create("Panel", self)
    self.footer = vgui.Create("Panel", self)
    self.footer.time = CurTime() + time
    self.panel = vgui.Create("DGrid", self)
    self.panel:SetCols(#entries)
    self.panel:MakePopup()

    function self.background:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 200))
    end

    function self.panel:Paint(width, height)
    end

    function self.header:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 220))
        draw.DrawText("Warden Vote", "Jailbreak_Font_72", 72, height - 72, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawRect(0, height - 1, width, 1, Color(255, 255, 255))
    end

    function self.footer:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 220))
        draw.DrawText(string.FormattedTime(self.time - CurTime(), "%02i:%02i"), "Jailbreak_Font_72", width / 2 - 72 / 2, 1, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawRect(0, 0, width, 1, Color(255, 255, 255))
    end

    function self:Think()
        if self.footer.time - CurTime() <= 0 then
            self:Remove()
        end
    end

    self.slots = {}

    for k, v in pairs(entries) do
        local card = vgui.Create("JailbreakWardenCard")
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
    self.header:Dock(TOP)
    self.header:SetTall(height * 0.15)
    self.footer:Dock(BOTTOM)
    self.footer:SetTall(toVRatio(72))
    self.background:SetSize(width, height)
    self.panel:Dock(FILL)
    self.panel:SetColWide(self.panel:GetWide() / self.panel:GetCols())
    self.panel:SetRowHeight(self.panel:GetTall() / (math.ceil(#entries / self.panel:GetCols())))

    for k, v in pairs(self.panel:GetItems()) do
        v:SetSize(self.panel:GetColWide(), self.panel:GetRowHeight())
    end
end

vgui.Register("JailbreakWardenVote", JAILBREAKWARDENVOTE)
JB.WardenVote = {}

function JB.WardenVote:Show()
    self.VotePanel = vgui.Create("JailbreakWardenVote")
    self.VotePanel:SetSize(w, h)
    self.VotePanel:SetPos(0, 0)

    JB.WardenVote.Hide = function()
        if not IsValid(self) then return end
        self.VotePanel:Clear()
        self.VotePanel:Remove()
    end
end

net.Receive("InitiateWardenVote", function()
    entries = net.ReadTable()
    time = net.ReadInt(32)
    JB.PrisonerWardenPercentage = net.ReadFloat()

    if (#entries > 0) then
        JB.WardenVote:Show()
    end
end)

net.Receive("BreakWardenVote", function()
    JB.WardenVote:Hide()
end)

hook.Add("Think", "ShowHideVoter", function()
    if not IsValid(JB.WardenVote) then return end
    print(input.IsKeyDown(KEY_V))

    if input.IsKeyDown(KEY_V) then
        JB.WardenVote:Hide()
    else
        JB.WardenVote:Show()
    end
end)