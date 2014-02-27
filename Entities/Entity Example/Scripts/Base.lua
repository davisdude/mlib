local Ent = {}

-- Picture Informations
Ent.x = 0
Ent.y = 0
Ent.Image = love.graphics.newImage( 'Entities/Images/Base.png' )
Ent.Rotation = 0
Ent.ScaleX = 1
Ent.ScaleY = 1
Ent.OffsetX	= Ent.Image:getWidth() / 2
Ent.OffsetY = Ent.Image:getHeight() / 2
Ent.ShearX = 0
Ent.ShearY = 0
Ent.CanControl = true

-- Entity Information
Ent.Name = 'Based Entity'

function Ent:Load()
end

function Ent:Draw()
	love.graphics.setColor( 255, 255, 255, 255 )
	love.graphics.draw( self.Image, self.x, self.y, self.Rotation, self.ScaleX, self.ScaleY, self.OffsetX, self.OffsetY, self.ShearX, self.ShearY )
end

function Ent:Update( dt )
end

function Ent:KeyPressed( Key, IsRepeat )
end

function Ent:KeyReleased( Key, IsRepeat )
end

function Ent:MousePressed( x, y, Button )
end

function Ent:MouseReleased( x, y, Button )
end

function Ent:SetX( x )
	self.x = x
end

function Ent:SetY( y )
	self.y = y
end

function Ent:SetPosition( x, y )
	self.x, self.y = x, y
end

function Ent:SetImage( Image )
	self.Image = Image
end

function Ent:Rotate( dt, Radians )
	self.Rotation = self.Rotation + Radians * dt
end

function Ent:SetScale( ScaleX, ScaleY )
	self.ScaleX, self.ScaleY = ScaleX, ScaleY
end

function Ent:SetOffset( OffsetX, OffsetY )
	self.OffsetX, self.OffsetY = OffsetX, OffsetY
end

function Ent:SetShear( ShearX, ShearY )
	self.ShearX, self.ShearY = ShearX, ShearY
end

function Ent:Rename( Name )
	self.Name = Name
end

function Ent:ChangeControl()
	if self.CanControl then 
		self.CanControl = false
	else
		self.CanControl = true
	end
end

function Ent:SetContol( Boolean )
	self.Control = Boolean
end

return Ent