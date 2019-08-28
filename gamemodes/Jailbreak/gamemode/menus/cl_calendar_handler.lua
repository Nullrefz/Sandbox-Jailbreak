calendarMenu = {"freeday", "warday", "hide & seek", "weeping angels", "contest", "competition", "purge day"}

function JB:AddCalendarMenu()
    local slots = {}

    for k, v in pairs(calendarMenu) do
        if self:CheckDay(v) then
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            if v == "freeday" or v == "warday" or v == "hide & seek" or v == "weeping angels" or v == "purge day" then
                slot.ACTION = function()
                    if LocalPlayer():Team() == Team.GUARDS then
                        JB:SendDay(v)
                    else
                        JB:SendLR(v)
                    end
                end
            else
                slot.ACTION = function()
                    JB:OpenMenu(v)
                end
            end

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end
    end

    return self:RegisterMenu(slots, "calendar")
end

function JB:SendDay(day)
    net.Start("SendDay")
    net.WriteString(day)
    net.SendToServer()
end

function JB:CheckDay(v)
    if (v ~= "freeday" and v ~= "contest" and v ~= "competition") and curDay ~= "" then return false end

    return true
end

hook.Add("JB_Initialize", "AddCalendarMenu", function()
    JB:AddCalendarMenu()
end)