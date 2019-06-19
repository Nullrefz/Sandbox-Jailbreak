util.AddNetworkString("ShowButtonNotification")
util.AddNetworkString("HideButtonNotification")
local ply = FindMetaTable("Player")

function ply:ShowNotifyButton(ply, button, message)
    if ply.buttonNotificationActive then return end
    ply.buttonNotificationActive = true
    net.Start("ShowButtonNotification")
    net.WriteString(button)
    net.WriteString(message)
    net.Send(ply)
end

function ply:HideNotifyButton(ply, button, message)
    if not ply.buttonNotificationActive then return end
    ply.buttonNotificationActive = false
    net.Start("HideButtonNotification")
    net.Send(ply)
end