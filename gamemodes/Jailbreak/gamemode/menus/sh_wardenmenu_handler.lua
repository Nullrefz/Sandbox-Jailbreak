wardenMenu = {"commands", "actions", "waypoint", "calendar"}

if CLIENT then
    local wardenSlots
    hook.Add("Think", "OpensWardenMenu", function()
        if not wardenSlots then return end

        if (LocalPlayer() == warden and input.IsKeyDown(KEY_F) and not wardenSlots.active) then
            wardenSlots:Show()
        elseif (LocalPlayer() == warden and not input.IsKeyDown(KEY_F) and wardenSlots.Hide) then
            wardenSlots:Hide()
        end
    end)

    hook.Add("Initialize", "AddWardenMenu", function()
        wardenSlots = JB:AddWardenMenu(wardenMenu)
    end)

    function JB:AddWardenMenu()
        local slots = {}

        for k, v in pairs(wardenMenu) do
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
        return self:RegisterMenu(slots)
    end
end