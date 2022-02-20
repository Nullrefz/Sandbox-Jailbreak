lastRequestMenu = {"challenge", "calendar", "exclusive freeday", "custom"}
inLRMenu = false
lrPlayer = nil

function JB:AddLRMenu()
    local slots = {}

    for k, v in pairs(lastRequestMenu) do
        local slot = {}
        slot.NAME = v
        slot.CLOSE = true

        if v == "calendar" or v == "challenge" then
            slot.ACTION = function()
                JB:OpenMenu(v)
            end

            slot.COLOR = Color(255, 255, 255)
        else
            slot.ACTION = function()
                JB:SendLR(v)
            end

            slot.COLOR = Color(255, 255, 255)
        end

        table.insert(slots, slot)
    end

    net.Receive("SetLRPlayer", function()
        lrPlayer = net.ReadEntity()
    end)

    return self:RegisterMenu(slots, "lastrequest")
end

function JB:SendLR(lastRequest)
    net.Start("SendLR")
    net.WriteString(lastRequest)
    net.SendToServer()
    lrPlayer = nil
end

hook.Add("JB_Initialize", "AddLRMenu", function()
    JB:AddLRMenu()
end)

hook.Add("Think", "OpensTheLRMenu", function()
    if (LocalPlayer() == lrPlayer and input.IsKeyDown(KEY_V) and not inLRMenu) then
        inLRMenu = true
        JB:OpenMenu("lastrequest")
    elseif (((LocalPlayer() == lrPlayer and not input.IsKeyDown(KEY_V)) or not LocalPlayer():Alive()) and inLRMenu) then
        JB:CloseMenu()
        inLRMenu = false
    end
end)