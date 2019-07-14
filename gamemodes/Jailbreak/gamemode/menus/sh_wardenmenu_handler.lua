wardenMenu = {"commands", "actions", "waypoint", "calendar"}

if CLIENT then
    local menuActive = false

    hook.Add("Think", "OpensWardenMenu", function()

        if (LocalPlayer() == warden and input.IsKeyDown(KEY_F) and not menuActive) then
            menuActive = true
            JB:OpenMenu("wardenMenu")
        elseif (((LocalPlayer() == warden and not input.IsKeyDown(KEY_F)) or not LocalPlayer():Alive()) and menuActive) then
            JB:CloseMenu()
            menuActive = false
        end
    end)

    hook.Add("Initialize", "AddWardenMenu", function()
        JB:AddWardenMenu(wardenMenu)
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

        return self:RegisterMenu(slots, "wardenMenu")
    end
end