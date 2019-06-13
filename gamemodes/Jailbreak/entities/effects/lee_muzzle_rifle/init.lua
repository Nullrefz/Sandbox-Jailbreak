function EFFECT:Init(data)

ptp_flash_data 		= CreateClientConVar("ptp_flash_data", 1, true, false)			

 if ptp_flash_data :GetInt() == 1 then 
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

			if !(game.SinglePlayer()) then return end
				particle:SetAirResistance( 400 )
				particle:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

				particle:SetDieTime( 0.15 )

				particle:SetStartAlpha(  math.Rand( 15, 60 ) )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( math.Rand( 5, 10 ) )
						particle:SetEndSize( 1 )

				particle:SetRoll( math.Rand( 180, 480 ) )
						particle:SetRollDelta( math.Rand( -1, 1 ) )

				particle:SetColor( 255, 255, 255, 255 )
			end
		end
	end
	
if ptp_flash_data:GetInt() == 2 then
			self.WeaponEnt = data:GetEntity()
			self.Attachment = data:GetAttachment()
			
			self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
			self.Forward = data:GetNormal()
			self.Angle = self.Forward:Angle()
			self.Right = self.Angle:Right()
			
			
			local emitter = ParticleEmitter(self.Position)
				
				local particle = emitter:Add( "effects/actionflash2", self.Position)

						particle:SetAirResistance( 0 )
						particle:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

						particle:SetDieTime( 0.04 )

						particle:SetStartAlpha(  math.Rand( 75, 75 ) )
						particle:SetEndAlpha( 75 )

						particle:SetStartSize( math.Rand( 10, 10 ) )
								particle:SetEndSize( 10 )

						particle:SetRoll( math.Rand( 180, 480 ) )
								particle:SetRollDelta( math.Rand( -1, 1 ) )

						particle:SetColor( 255, 255, 255, 50 )
				
				for i = 1,4 do
		for j = 1,2 do
		
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

			end
		end
	end
	
if ptp_flash_data:GetInt() == 3 then
			self.WeaponEnt = data:GetEntity()
			self.Attachment = data:GetAttachment()
			
			self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
			self.Forward = data:GetNormal()
			self.Angle = self.Forward:Angle()
			self.Right = self.Angle:Right()
			
			
			local emitter = ParticleEmitter(self.Position)
				
				local particle = emitter:Add( "effects/muzzleflash4p", self.Position)

						particle:SetAirResistance( 0 )
						particle:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

						particle:SetDieTime( 0.04 )

						particle:SetStartAlpha(  math.Rand( 75, 75 ) )
						particle:SetEndAlpha( 75 )

						particle:SetStartSize( math.Rand( 30, 30 ) )
								particle:SetEndSize( 30 )

						particle:SetRoll( math.Rand( 180, 480 ) )
								particle:SetRollDelta( math.Rand( -1, 1 ) )

						particle:SetColor( 255, 255, 255, 50 )
				
				for i = 1,4 do
		for j = 1,2 do

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
			
			end
		end
	end
	
if ptp_flash_data:GetInt() == 4 then
			self.WeaponEnt = data:GetEntity()
			self.Attachment = data:GetAttachment()
			
			self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
			self.Forward = data:GetNormal()
			self.Angle = self.Forward:Angle()
			self.Right = self.Angle:Right()
			
			
			local emitter = ParticleEmitter(self.Position)
				
				myTable={} 
				myTable[1]="effects/multi/muzzleflash1" 
				myTable[2]="effects/multi/muzzleflash2" 
				myTable[3]="effects/multi/muzzleflash3"
				myTable[4]="effects/multi/muzzleflash4"
				myTable[5]="effects/multi/muzzleflashX"
				
				local flash = myTable[math.random(1,5)]
				
				local particle = emitter:Add( flash, self.Position)

						particle:SetAirResistance( 0 )
						particle:SetGravity( Vector(0, 0, 0) )

						particle:SetDieTime( 0.05 )

						particle:SetStartAlpha(  math.Rand( 100, 100 ) )
						particle:SetEndAlpha( 100 )

						particle:SetStartSize( math.Rand( 10, 10 ) )
								particle:SetEndSize( 10 )

						particle:SetRoll( math.Rand( 180, 480 ) )
								particle:SetRollDelta( math.Rand( -1, 1 ) )

						particle:SetColor( 255, 255, 255, 50 )
			
	end
	
if ptp_flash_data:GetInt() == 5 then
			self.WeaponEnt = data:GetEntity()
			self.Attachment = data:GetAttachment()
			
			self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
			self.Forward = data:GetNormal()
			self.Angle = self.Forward:Angle()
			self.Right = self.Angle:Right()
			
			
			local emitter = ParticleEmitter(self.Position)

				local particle = emitter:Add( "effects/muzzle_root", self.Position)

						particle:SetAirResistance( 0 )
						particle:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

						particle:SetDieTime( 0.04 )

						particle:SetStartAlpha(  math.Rand( 75, 75 ) )
						particle:SetEndAlpha( 75 )

						particle:SetStartSize( math.Rand( 13, 13 ) )
								particle:SetEndSize( 13 )

						particle:SetRoll( math.Rand( 180, 480 ) )
								particle:SetRollDelta( math.Rand( -1, 1 ) )

						particle:SetColor( 255, 255, 255, 50 )
				
				for i = 1,4 do
		for j = 1,2 do
		
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

			end
		end
	end

	--emitter:Finish()
end

function EFFECT:Think()

	return false
end


function EFFECT:Render()
end