calendarMenu = {"freeday", "warday", "hide & seek", "weeping angels", "contest", "competition", "purge day"}

    function JB:AddCalendarMenu()
        local slots = {}

        for k, v in pairs(calendarMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            if v == "freeday" or v == "warday" or v == "hide & seek" or v == "weeping angels" or v == "purge day" then
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