function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	
	local emitter = ParticleEmitter(self.Position)
		
		local particle = emitter:Add( "particle/particle_smokegrenade", self.Position - self.Forward * 4)

				particle:SetAirResistance( 400 )
				particle:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

				particle:SetDieTime( math.Rand( 0.1, 0.3 ) )

				particle:SetStartAlpha( math.Rand( 80, 120 ) )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( math.Rand( 2, 3 ) )
				particle:SetEndSize( math.Rand( 6, 8 ) )

				particle:SetRoll( math.Rand( -25, 25 ) )
				particle:SetRollDelta( math.Rand( -0.05, 0.05 ) )

				particle:SetColor( 145, 145, 145 )
		
		for i = 1,4 do
for j = 1,2 do
			local particle = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Position )
			local particle2 = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Position )
			
				particle:SetAirResistance( 400 )
				particle:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

				particle:SetDieTime( 0.15 )

				particle:SetStartAlpha(  math.Rand( 15, 60 ) )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( math.Rand( 5, 10 ) )
						particle:SetEndSize( 1 )

				particle:SetRoll( math.Rand( 180, 480 ) )
						particle:SetRollDelta( math.Rand( -1, 1 ) )

				particle:SetColor( 244, 0, 220, 255 )
				
				particle2:SetAirResistance( 400 )
				particle2:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

				particle2:SetDieTime( 0.15 )

				particle2:SetStartAlpha(  math.Rand( 15, 60 ) )
				particle2:SetEndAlpha( 0 )

				particle2:SetStartSize( math.Rand( 5, 10 ) )
						particle2:SetEndSize( 1 )

				particle2:SetRoll( math.Rand( 180, 480 ) )
						particle2:SetRollDelta( math.Rand( -1, 1 ) )

				particle2:SetColor( 255, 0, 0, 255 )
		end
end
		

	emitter:Finish()
end

function EFFECT:Think()

	return false
end


function EFFECT:Render()
end