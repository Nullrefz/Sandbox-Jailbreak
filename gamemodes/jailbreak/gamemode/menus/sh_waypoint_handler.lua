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

    local menuActive = false
    local menuDelay = 0
    local keyPressed = false

    hook.Add("Think", "OpenWaypointMenu", function()
        if (LocalPlayer() == warden and input.IsKeyDown(KEY_V) and not menuActive and not keyPressed) then
            keyPressed = true
            if CurTime() > menuDelay then
                menuActive = true
                JB:OpenMenu("waypoint")
            end
        elseif (LocalPlayer() == warden and input.IsKeyDown(KEY_V) and not menuActive and keyPressed) then
            keyPressed = false
            JB:SendWaypoint("Waypoint")
        elseif (((LocalPlayer() == warden and not input.IsKeyDown(KEY_V)) or not LocalPlayer():Alive()) and menuActive) then
            keyPressed = false
            JB:CloseMenu()
            menuActive = false
        else
            menuDelay = CurTime() + 1
        end
    end)
end