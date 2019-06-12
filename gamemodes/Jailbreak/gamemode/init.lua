AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")

include("sh_init.lua")

activeCommands = {}

net.Receive("UpdateCommands", function()
    activeCommands = net.ReadTable()
end)

hook.Add( "HUDPaint", "3d_camera_example", function()
	cam.Start3D()
		for id, ply in pairs( player.GetAll() ) do
			ply:DrawModel()
		end
	cam.End3D()
end )