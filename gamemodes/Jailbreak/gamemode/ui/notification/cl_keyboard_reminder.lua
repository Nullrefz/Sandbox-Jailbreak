local mats = {
    BUTTON = Material("jailbreak/vgui/button.png", "smooth")
}

surface.CreateFont("Jailbreak_Font_ButtonNotifyKey", {
    font = "Optimus",
    extended = false,
    size = 34,
    weight = 5,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = true,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

surface.CreateFont("Jailbreak_Font_ButtonNotifyMessage", {
    font = "Optimus",
    extended = false,
    size = 28,
    weight = 5,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = true,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

local BUTTONOTIFY = {}
local message = ""
local key = ""

function BUTTONOTIFY:Paint(width, height)
    draw.DrawRect(width / 2 - 32, 0, 64, 64, Color(255, 255, 255, 150), mats.BUTTON)
    draw.DrawText(key, "Jailbreak_Font_ButtonNotifyKey", width / 2 - 2, 12, Color(255, 255, 255, 150), TEXT_ALIGN_CENTER)
    draw.DrawText(message, "Jailbreak_Font_ButtonNotifyMessage", width / 2, 64, Color(255, 255, 255, 150), TEXT_ALIGN_CENTER)
end

vgui.Register("ButtonNotify", BUTTONOTIFY)

hook.Add("InitPostEntity", "ShowButtonNotification", function()
    local buttonNotify = vgui.Create("ButtonNotify")
    buttonNotify:SetSize(512, 128)
    buttonNotify:Center()
    buttonNotify:SetPos(w / 2 - 256, h / 2 + 128)
    buttonNotify:Hide()

    net.Receive("ShowButtonNotification", function()
        key = net.ReadString()
        message = net.ReadString()
        buttonNotify:Show()
    end)

    net.Receive("HideButtonNotification", function()
        buttonNotify:Hide()
    end)

    hook.Add("Think", "DrawWeaponOutline", function()
        local trace = LocalPlayer():GetEyeTrace()

        if LocalPlayer():Alive() and trace.Entity:IsWeapon() and LocalPlayer():GetPos():Distance(trace.Entity:GetPos()) < 100 and not LocalPlayer():HasWeapon(JB:GetWeapon(trace.Entity)) then
            key = "E"
            message = "Pick Up"

            if not buttonNotify:IsVisible() then
                buttonNotify:Show()
            end
        elseif buttonNotify:IsVisible() then
            buttonNotify:Hide()
        end
    end)
end)

hook.Add("InitPostEntity", "ShowWardenJoin", function()
    local buttonNotif = vgui.Create("ButtonNotify")
    buttonNotif:SetSize(512, 128)
    buttonNotif:Center()
    buttonNotif:SetPos(w / 2 - 256, h / 2 + 128)
    buttonNotif:Hide()

    hook.Add("Think", "DrawMicJoin", function()
        if LocalPlayer():Alive() and LocalPlayer():Team() == Team.GUARDS and not warden and roundPhase == "Preparing" then
            key = "X"
            message = "Use Mic To Become Warden"

            if not buttonNotif:IsVisible() then
                buttonNotif:Show()
            end
        elseif (warden or roundPhase ~= "Preparing") and buttonNotif:IsVisible() then
            buttonNotif:Hide()
        end
    end)
end)

hook.Add("InitPostEntity", "HandleLR", function()
    local button = vgui.Create("ButtonNotify")
    button:SetSize(512, 128)
    button:Center()
    button:SetPos(w / 2 - 256, h / 2 + 128)
    button:Hide()
    local lrPlayer

    net.Receive("SetLRPlayer", function()
        lrPlayer = player.GetBySteamID(net.ReadString())
    end)

    hook.Add("Think", "DrawLR", function()
        if LocalPlayer() == lrPlayer and LocalPlayer():Alive() and LocalPlayer():Team() == Team.PRISONERS then
            key = "C"
            message = "Hold to Open Last Request Menu"

            if not button:IsVisible() then
                button:Show()
            end
        elseif (LocalPlayer() ~= lrPlayer or not LocalPlayer():Alive() or LocalPlayer():Team() ~= Team.PRISONERS) and button:IsVisible() then
            button:Hide()
        end
    end)
end)