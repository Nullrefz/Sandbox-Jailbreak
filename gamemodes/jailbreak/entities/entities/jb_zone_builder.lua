AddCSLuaFile()

ENT.Type             = "anim"
ENT.Base             = "base_anim"

function ENT:Initialize()

	local Radius = 5

	if ( SERVER ) then

		self:SetModel( "models/maxofs2d/hover_classic.mdl" )

		local min = Vector( 1, 1, 1 ) * Radius * -0.1
		local max = Vector( 1, 1, 1 ) * Radius * 0.1

		self:PhysicsInitBox( min, max )

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys) ) then

			phys:Wake()
			phys:EnableGravity( false )
			phys:EnableDrag( false )

		end

		self:SetCollisionBounds( min, max )
		self:DrawShadow( false )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

		self.isPositioned=false

	else

		self.GripMaterial = Material( "sprites/grip" )
		self:SetCollisionBounds( Vector( -Radius, -Radius, -Radius ), Vector( Radius, Radius, Radius ) )

	end


end

function ENT:SetZoneEntity(obj)
    self.obj = obj
end

function ENT:Draw()

	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	if ( !IsValid( wep ) ) then return end

	local weapon_name = wep:GetClass()

	if ( weapon_name ~= "weapon_physgun" ) then
		return
	end

	render.SetMaterial( self.GripMaterial )
	render.DrawSprite( self:GetPos(), 16, 16, color_white )

end

function ENT:PhysicsUpdate( physobj )

	if ( CLIENT ) then return end

	if ( !self:IsPlayerHolding() and !self:IsConstrained() ) then

		physobj:SetVelocity( Vector(0,0,0) )
		physobj:Sleep()

	end

end
