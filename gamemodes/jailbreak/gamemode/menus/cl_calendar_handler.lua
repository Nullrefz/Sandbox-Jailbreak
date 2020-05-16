calendarMenu = {"freeday", "warday", "hide & seek", "weeping angels", "contest", "competition", "purge day"}

function JB:AddCalendarMenu()
    local slots = {}

    for k, v in pairs(calendarMenu) do
        local slot = {}
        slot.NAME = v
        slot.CLOSE = true

        if v == "freeday" or v == "warday" or v == "hide & seek" or v == "weeping angels" or v == "purge day" then
            slot.ACTION = function()
                if LocalPlayer():Team() == Team.GUARDS and self:CheckDay(v) then
                    JB:SendDay(v)
                elseif LocalPlayer():Team() == Team.PRISONERS then
                    JB:SendLR(v)
                end
            end
        else
            slot.ACTION = function()
                JB:OpenMenu(v)
            end
        end

        slot.COLOR = (self:CheckDay(v) or LocalPlayer():Team() == Team.PRISONERS) and Color(255, 255, 255) or Color(150, 150, 150, 150)
        table.insert(slots, slot)
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