local Ent = Entity.Derive( 'Base', x, y, Image, Rotation, ScaleX, ScaleY, OffsetX, OffsetY, ShearX, ShearY )

function Ent:Load( Name, x, y, Image, Rotation, ScaleX, ScaleY, OffsetX, OffsetY, ShearX, ShearY )
	-- Picture Informations
	Ent.x = x or 0
	Ent.y = y or 0
	Ent.Image = Image or love.graphics.newImage( 'Entities/Images/Base.png' )
	Ent.Rotation = Rotation or 0
	Ent.ScaleX = ScaleX or 1
	Ent.ScaleY = ScaleY or 1
	Ent.OffsetX	= OffsetX or Ent.Image:getWidth() / 2
	Ent.OffsetY = OffsetY or Ent.Image:getHeight() / 2
	Ent.ShearX = ShearX or 0
	Ent.ShearY = ShearY or 0

	-- Entity Information
	Ent.Name = 'Test Entity'
end

return Ent