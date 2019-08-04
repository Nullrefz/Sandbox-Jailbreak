if SERVER then
    util.AddNetworkString("ShowButtonNotification")
    util.AddNetworkString("HideButtonNotification")
    util.AddNetworkString("SendNotification")
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

    function JB:SendNotification(time, color, text, textColor, type)
        net.Start("SendNotification")
        net.WriteFloat(time)
        net.WriteColor(color)
        net.WriteString(text)
        net.WriteColor(textColor)

        if type then
            net.WriteInt(type, 32)
        end

        net.Broadcast()
    end
end