if SERVER then
    util.AddNetworkString("OpenURL")

    --
    hook.Add("PlayerSay", "SendURL", function(sender, text, teamChat)
        if text == "!apply" then
            JB:OpenURL("https://forms.gle/txPrhcyvKXqsyqhT7", sender)
        elseif text == "!bug" then
            JB:OpenURL("https://forms.gle/xcVqqAr5okAFf8DR9", sender)
        elseif text == "!suggest" then
            JB:OpenURL("https://forms.gle/8Umv3cyg1QC7YPT16", sender)
        end
    end)

    function JB:OpenURL(url, ply)
        net.Start("OpenURL")
        net.WriteString(url)
        net.Send(ply)
    end
end

if CLIENT then
    net.Receive("OpenURL", function()
        gui.OpenURL(net.ReadString())
    end)
end