calendarMenu = {"freeday", "warday", "hidenseek", "weepingangles", "contest", "competition"}

if CLIENT then
    function JB:AddCalendarMenu()
        local slots = {}

        for k, v in pairs(calendarMenu) do
            local slot = {}
            slot.NAME = v
            slot.CLOSE = true

            if v == "freeday" then
                slot.ACTION = function()
                    JB:SendFreeday()
                end
            elseif v == "warday" then
                slot.ACTION = function()
                    JB:SendWarday()
                end
            elseif v == "hidenseek" then
                slot.ACTION = function()
                    JB:HidenSeek()
                end
            elseif v == "weepingangles" then
                slot.ACTION = function()
                    JB:SendWeepingAngles()
                end
            else
                slot.ACTION = function()
                    JB:OpenMenu(v)
                end
            end

            function JB:SendFreeday()
                net.Start("SendFreeday")
                net.Send()
            end

            function JB:SendWarday()
                net.Start("SendWarday")
                net.Send()
            end

            function JB:HidenSeek()
                net.Start("SendHidenSeek")
                net.Send()
            end

            function JB:SendWeepingAngles()
                net.Start("SendWeepingAngles")
                net.Send()
            end

            slot.COLOR = Color(255, 255, 255)
            table.insert(slots, slot)
        end

        return self:RegisterMenu(slots, "calendar")
    end

    hook.Add("Initialize", "AddCalendarMenu", function()
        JB:AddCalendarMenu()
    end)
end

if SERVER then
    util.AddNetworkString("SendFreeday")
    util.AddNetworkString("SendWarday")
    util.AddNetworkString("SendHidenSeek")
    util.AddNetworkString("SendWeepingAngles")
    net.Receive("SendFreeday", function(ln, ply) end)
    net.Receive("SendWarday", function(ln, ply) end)
    net.Receive("SendHidenSeek", function(ln, ply) end)
    net.Receive("SendWeepingAngles", function(ln, ply) end)
end