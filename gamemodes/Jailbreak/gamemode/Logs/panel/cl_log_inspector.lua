local LOGINSPECTOR = {}

function LOGINSPECTOR:Init()

end


function LOGINSPECTOR:Paint(width, height)
	draw.DrawRect(0, 0, width, height, Color(30, 30, 30, 255))
end

vgui.Register("JailbreakLogInspector", LOGINSPECTOR)