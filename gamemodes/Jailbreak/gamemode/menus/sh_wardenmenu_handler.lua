wardenMenu = {"commands", "actions", "waypoint", "calendar"}

if CLIENT then
    local wardenSlots

    -- JB.wardenMenu = {}
    -- function JB.wardenMenu:Show()
    --     self.active = true
    --     self.menu = vgui.Create("JailbreakOptionMenu")
    --     self.menu:SetSize(w, h)
    --     self.menu:SetPos(0, 0)
    --     for k, v in ipairs(wardenMenu) do
    --         if v == "waypoint" then
    --             self.menu:AddSlot(v, function()
    --                 JB:SendWaypoint(0)
    --             end, Color(255, 200, 0, 255), true)
    --         else
    --             self.menu:AddSlot(v, function()
    --                 JB:OpenMenu(v)
    --             end, Color(255, 255, 255), true)
    --         end
    --     end
    --     JB.wardenMenu.Hide = function()
    --         self.active = false
    --         if self.menu:IsValid() then
    --             self.menu:Exit()
    --         end
    --     end
    -- end
    hook.Add("Think", "OpensWardenMenu", function()
        if not wardenSlots then return end

        if (LocalPlayer() == warden and input.IsKeyDown(KEY_F) and not wardenSlots.active) then
            wardenSlots:Show()
        elseif (LocalPlayer() == warden and not input.IsKeyDown(KEY_F) and wardenSlots.Hide) then
            wardenSlots:Hide()
        end
    end)

    hook.Add("Initialize", "AddWardenMenu", function()
        wardenSlots = JB:AddMenu(wardenMenu)
    end)

    function JB:AddMenu(list)
        local slots = {}

        for k, v in pairs(list) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            if v == "waypoint" then
                slot.ACTION = function()
                    JB:SendWaypoint(0)
                end

                slot.COLOR = Color(255, 200, 0, 255)
            else
                slot.ACTION = function()
                    JB:OpenMenu(v)
                end

                slot.COLOR = Color(255, 255, 255)
            end

            table.insert(slots, slot)
        end
        print("hello")
        return self:RegistereMenu(slots)
    end
end