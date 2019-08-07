calendarMenu = {"freeday", "warday", "hidenseek", "weepingangels", "contest", "competition"}

if CLIENT then
    function JB:AddCalendarMenu()
        local slots = {}

        for k, v in pairs(calendarMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            if v == "freeday" or v == "warday" or v == "hidenseek" or v == "weepingangels" then
                slot.ACTION = function()
                    JB:SendDay(v)
                end
            else
                slot.ACTION = function()
                    JB:OpenMenu(v)
                end
            end

            function JB:SendDay(day)
                net.Start("SendDay")
                net.WriteString(day)
                net.SendToServer()
            end

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots, "calendar")
    end

    hook.Add("JB_Initialize", "AddCalendarMenu", function()
        JB:AddCalendarMenu()
    end)
end