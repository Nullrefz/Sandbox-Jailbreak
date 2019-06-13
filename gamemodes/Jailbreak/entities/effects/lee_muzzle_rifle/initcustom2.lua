function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	
	local emitter = ParticleEmitter(self.Position)
		
		local particle = emitter:Add( "effects/actionflash2")

				particle:SetAirResistance( 0 )
				particle:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

				particle:SetDieTime( 0.01 )

				particle:SetStartAlpha(  math.Rand( 200, 200 ) )
				particle:SetEndAlpha( 200 )

				particle:SetStartSize( math.Rand( 10, 10 ) )
						particle:SetEndSize( 10 )

				particle:SetRoll( math.Rand( 180, 480 ) )
						particle:SetRollDelta( math.Rand( -1, 1 ) )

				particle:SetColor( 200, 200, 200, 200 )
		
		for i = 1,4 do
for j = 1,2 do

		end
end
		

	emitter:Finish()
end

function EFFECT:Think()

	return false
end


function EFFECT:Render()
end