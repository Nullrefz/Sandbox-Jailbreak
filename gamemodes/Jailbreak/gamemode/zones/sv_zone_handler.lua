local ply = FindMetaTable("Player")
util.AddNetworkString("SendKOSWarning")

function ply:SetInKOSZone(zone)
    net.Start("SendKOSWarning")
    net.WriteString(zone)
    net.Send(self)
end