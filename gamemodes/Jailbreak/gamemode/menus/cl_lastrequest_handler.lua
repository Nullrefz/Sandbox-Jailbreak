lastRequestMenu = {"TicTacToe", "knifeBattle", "freeday", "calendar", "sniper battle", "custom"}
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
        else
            slot.ACTION = function()
                JB:SendLR(v)
            end
        end

        slot.COLOR = Color(255, 255, 255)
        table.insert(slots, slot)
    end

    net.Receive("SetLRPlayer", function()
        lrPlayer = net.ReadEntity()
    end)

    return self:RegisterMenu(slots, "lastrequest")
end

function JB:SendTicTacToe()
    net.Start("SendTicTacToe")
    net.SendToServer()
end

function JB:SendKnifeBattle()
    net.Start("SendKnifeBattle")
    net.SendToServer()
end

function JB:SendExclusiveFreeday()
    net.Start("SendExclusiveFreeday")
    net.SendToServer()
end

function JB:SendLR(lastRequest)
    net.Start("SendLR")
    net.WriteString(lastRequest)
    net.SendToServer()
end

hook.Add("JB_Initialize", "AddLRMenu", function()
    JB:AddLRMenu()
end)

hook.Add("Think", "OpensTheLRMenu", function()
    if (LocalPlayer() == lrPlayer and input.IsKeyDown(KEY_F) and not inLRMenu) then
        inLRMenu = true
        JB:OpenMenu("lastrequest")

    elseif (((LocalPlayer() == lrPlayer and not input.IsKeyDown(KEY_F)) or not LocalPlayer():Alive()) and inLRMenu) then
        JB:CloseMenu()
        inLRMenu = false
    end
end)
hook.Add("InitPostEntity", "HandleLR", function()
    local button = vgui.Create("ButtonNotify")
    button:SetSize(512, 128)
    button:Center()
    button:SetPos(w / 2 - 256, h / 2 + 128)
    button:Hide()

    hook.Add("Think", "DrawLR", function()
        if IsValid(lrPlayer) and LocalPlayer() == lrPlayer and LocalPlayer():Alive() and LocalPlayer():Team() == Team.PRISONERS and not inLRMenu then
            key = "F"
            message = "Hold to Open Last Request Menu"

            if not button:IsVisible() then
                button:Show()
            end
        elseif (LocalPlayer() ~= lrPlayer or not LocalPlayer():Alive() or LocalPlayer():Team() ~= Team.PRISONERS) and button:IsVisible() and inLRMenu then
            button:Hide()
        end
    end)
end)