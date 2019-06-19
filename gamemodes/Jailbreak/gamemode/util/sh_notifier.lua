util.AddNetworkString("ShowButtonNotification")
util.AddNetworkString("HideButtonNotification")

function JB:ShowNotifyButton(ply, button, message)
    if ply.buttonNotificationActive then return end
    ply.buttonNotificationActive = true
    net.Start("ShowButtonNotification")
    net.WriteString(button)
    net.WriteString(message)
    net.Send(ply)
end

function JB:HideNotifyButton(ply, button, message)
    if not ply.buttonNotificationActive then return end
    ply.buttonNotificationActive = false
    net.Start("HideButtonNotification")
    net.Send(ply)
end