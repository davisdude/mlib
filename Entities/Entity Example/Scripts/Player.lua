local Ent = Entity.Derive( 'Base', x, y, Image, Rotation, ScaleX, ScaleY, OffsetX, OffsetY, ShearX, ShearY )

function Ent:Load( Name, x, y, Image, Rotation, ScaleX, ScaleY, OffsetX, OffsetY, ShearX, ShearY )
	-- Picture Informations
	self.x = x or 0
	self.y = y or 0
	self.Image = Image or love.graphics.newImage( 'selfities/Images/Base.png' )
	self.Rotation = Rotation or 0
	self.ScaleX = ScaleX or 1
	self.ScaleY = ScaleY or 1
	self.OffsetX = OffsetX or self.Image:getWidth() / 2
	self.OffsetY = OffsetY or self.Image:getHeight() / 2
	self.ShearX = ShearX or 0
	self.ShearY = ShearY or 0
	
	-- Speed Information
	self.Speed = 300
	self.FlipJumpSpeed = math.pi

	self.VelocityX = 0
	self.VelocityY = 0
	
	-- Jump Information
	self.JumpSpeed = 250
	self.MaxJumpHeight = 32
	self.StartJump = self.y
	
	self.Jumps = 0
	self.MaxJumps = 2
	self.MaxBoostTime = .75
	
	self.CanJump = false
	self.ShouldApplyGravity = false 
	
	self.State = 'Standing'

	-- Entity Information
	self.Name = 'Player'
end

function Ent:Update( dt )
	self.x = self.x + self.VelocityX * dt
	self.y = self.y + self.VelocityY * dt
	
	if self.ShouldApplyGravity then self:ApplyGravity( dt ) end
	
	self:Move()
	
	if self.State == 'Jumping' then self:ManageJumpGravity() end
end

function Ent:Move()
	if self.Jumps < self.MaxJumps then 
		self:ManageJump()
	end
	
	if KeyManager.KeyPressed['a'].Status then 
		self.VelocityX = -self.Speed
	end
	if KeyManager.KeyPressed['d'].Status then 
		self.VelocityX = self.Speed
	end
end

function Ent:KeyReleased( Key, IsRepeat )
	if Key == 'a' or Key == 'd' then 
		self.VelocityX = 0
	end
end

function Ent:ManageJump()
	if not KeyManager.KeyPressed['w'].Status then
		self.WaitForRelease = nil
	end

	if not self.WaitForRelease then
		if KeyManager.KeyPressed['w'].Status and ( self.VelocityY == 0 or -- Y velocity 0 means that the player is standing (or not falling, etcetera).
		( self.State == 'Jumping' and self.ShouldApplyGravity and self.CanJump ) ) then 
			self:RegularJump()
			self.WaitForRelease = true
		end
	end
   
	if self.State == 'Jumping' then
		self:ManageJumpGravity()
	end
end

function Ent:ManageJumpGravity()
	if self:HasRegularJumpStopped() and not self.ShouldApplyGravity then 
		self:EndRegularJump()
	elseif self.ShouldApplyGravity and KeyManager.KeyPressed['w'].Status then
		if KeyManager.KeyPressed['w'].Time < self.MaxBoostTime then
			self:BoostedJump()
		end
	end
end

function Ent:EndRegularJump()
	self.ShouldApplyGravity = true 
	self.CanJump = true
	KeyManager.ChangePressedTimeTo( 'w', 0 )
end

function Ent:BoostedJump()
	self.VelocityY = self.VelocityY - 1
end

function Ent:HasRegularJumpStopped()
	if self.y < ( self.StartJump - self.MaxJumpHeight ) then
		return true
	end
end

function Ent:RegularJump()
	self.CanJump = false
	self.Jumps = self.Jumps + 1
	self.State = 'Jumping'
	self.ShouldApplyGravity = false
	self.VelocityY = -self.JumpSpeed
	self.StartJump = self.y
end

function Ent:ApplyGravity( dt )
	self.VelocityY = self.VelocityY + WorldGravity * dt
end

return Ent