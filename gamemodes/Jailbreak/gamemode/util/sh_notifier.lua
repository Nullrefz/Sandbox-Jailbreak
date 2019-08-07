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

    function JB:SendNotification(params)
        net.Start("SendNotification")
        net.WriteFloat(params.TIME or 3)
        net.WriteColor(params.COLOR or Color(255,255,255,100))
        net.WriteString(params.TEXT or "")
        net.WriteColor(params.TEXTCOLOR or Color(255,255,255))
        net.WriteInt(params.TYPE or 1, 32)
        net.Broadcast()
    end
end