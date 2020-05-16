local PLAYERLOG = {}

function PLAYERLOG:Init()
end

function PLAYERLOG:Paint(width, height)
    draw.DrawRect(0, 0, width, height, Color(100, 100, 100, 255))
end

vgui.Register("JailbreakPlayerLog", PLAYERLOG)