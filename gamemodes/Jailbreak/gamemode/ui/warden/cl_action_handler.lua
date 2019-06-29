JB.ShowMenu = {}

local Commands = {
    WALK = 1,
    MIC = 2,
    CROUCH = 3,
    AFK = 4,
    JUMPING = 5,
    WAYPOINT = 6,
    SPRINTING = 7,
    FREELOOK = 8
}
function JB.ShowMenu:Show()
    self.menu = vgui.Create("JailbreakWardenMenu")
    self.menu:SetSize(w, h)
    self.menu:SetPos(0, 0)

    self.menu:AddSlot(function() JB:SendCommand(Commands.WALK) end, Color(200,200,200), Material("jailbreak/vgui/walk.png", "smooth"))
    self.menu:AddSlot(function() JB:SendCommand(Commands.MIC) end, Color(200,200,200), Material("jailbreak/vgui/mic.png", "smooth"))
    self.menu:AddSlot(function() JB:SendCommand(Commands.CROUCH) end, Color(200,200,200), Material("jailbreak/vgui/crouch.png", "smooth"))
    self.menu:AddSlot(function() JB:SendCommand(Commands.AFK) end, Color(200,200,200), Material("jailbreak/vgui/afk.png", "smooth"))
    self.menu:AddSlot(function() JB:SendCommand(Commands.JUMPING) end, Color(200,200,200), Material("jailbreak/vgui/jumping.png", "smooth"))
    self.menu:AddSlot(function() JB:SendCommand(Commands.WAYPOINT) end, Color(200,200,200), Material("jailbreak/vgui/waypoint.png", "smooth"))
    self.menu:AddSlot(function() JB:SendCommand(Commands.SPRINTING) end, Color(200,200,200), Material("jailbreak/vgui/sprinting.png", "smooth"))
    self.menu:AddSlot(function() JB:SendCommand(Commands.FREELOOK) end, Color(200,200,200), Material("jailbreak/vgui/freelook.png", "smooth"))

    JB.ShowMenu.Hide = function()
        if self.menu:IsValid() then
            self.menu:Exit()
        end
    end
end

-- implement if player is warden
function GM:OnContextMenuOpen()
    JB.ShowMenu:Show()
end

function GM:OnContextMenuClose()
    JB.ShowMenu:Hide()
end

function JB:SendCommand(command)
    net.Start("SendWardenCommand")
    net.WriteInt(command, 32)
    net.SendToServer()
end