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
    buttonNotify:SetSize(256, 128)
    buttonNotify:Center()
    buttonNotify:SetPos(w / 2 - 128, h / 2 + 128)
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

        if  LocalPlayer():Alive() and trace.Entity:IsWeapon() and LocalPlayer():GetPos():Distance(trace.Entity:GetPos()) < 100 and not LocalPlayer():HasWeapon(JB:GetWeapon(trace.Entity)) then
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