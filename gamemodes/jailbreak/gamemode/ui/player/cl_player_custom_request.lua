local CUSTOMREQUEST = {}

function CUSTOMREQUEST:Init()
    self.background = vgui.Create("Panel", self)

    function self.background:Paint(width, height)
        Derma_DrawBackgroundBlur(self, 3)
    end

    self.panel = vgui.Create("Panel", self)

    function self.panel:Paint(width, height)
        draw.DrawRect(0, 0, width, height, Color(0, 0, 0, 200))
        draw.DrawRect(0, 0, width, 1, Color(255, 255, 255, 100))
        draw.DrawRect(0, height - 1, width, 1, Color(255, 255, 255, 100))
    end

    self.label = vgui.Create("DLabel", self)
    self.label:SetFont("Jailbreak_Font_72")
    self.label:SetText("Custom Last Request")
    self.entry = vgui.Create("DTextEntry", self)
    self.entry:SetFont("Jailbreak_Font_72")
    self.text = "Enter Last Request"
    self.entry:SetPlaceholderText(self.text)
    self.entry:SetPaintBackground(false)
    self.entry:SetTextColor(Color(255, 255, 255))
    self.entry:SetCursorColor(Color(255, 255, 255))
    self.entry:MakePopup()
    self.entry:SetPos(w / 2 - 72 / 5 * string.len(self.text), h / 2 - h * 0.15 / 2)

    self.entry.OnChange = function(self)
        self.text = self:GetValue()
        self:SetPos(self:GetParent():GetWide() / 2 - 72 / 5 * string.len(self.text), self:GetParent():GetTall() / 2 - self:GetTall() / 2)
    end

    self.entry.OnEnter = function(self)
        net.Start("SendCustomRequest")
        net.WriteString(self:GetValue())
        net.SendToServer()
        self:GetParent():Remove()
    end
end

function CUSTOMREQUEST:PerformLayout(width, height)
    self.background:SetSize(width, height)
    self.panel:SetSize(width, height * 0.15)
    self.panel:Center()
    self.label:SetSize(width, height * 0.15)
    self.label:SetPos(72 / 2, height / 2 - self.label:GetTall() - 72 / 2)
    self.entry:SetSize(width, height * 0.15)
end

vgui.Register("JailbreakCustomRequest", CUSTOMREQUEST)
net.Receive("OpenCustomRequest", function()
    JB:OpenCustomRequest()
end)
JB.customRequest = {}
function JB.customRequest:Show()
    self.panel = vgui.Create("JailbreakCustomRequest")
    self.panel:SetSize(w, h)
    JB.customRequest.Hide = function()
        self.panel:Remove()
        self.panel:Clear()
    end
end
function JB:OpenCustomRequest()
    JB.customRequest:Show()
end
function JB:CloseCustomRequest()
    JB.customRequest:Hide()
end