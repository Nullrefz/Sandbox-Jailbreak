waypointMenu = {"waypoint", "line", "question", "avoid", "warning", "cancelWaypoint"}

if CLIENT then
    function JB:AddWaypointMenu()
        local slots = {}

        for k, v in pairs(waypointMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            slot.ACTION = function()
                JB:SendWaypoint(v)
            end

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots, "waypoint")
    end

    hook.Add("JB_Initialize", "AddWaypointMenu", function()
        JB:AddWaypointMenu()
    end)
end