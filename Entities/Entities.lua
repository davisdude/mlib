local Entity = {
	Registered = {}, 
	Created = {}, 
}

local ScriptPath = 'Entities/Scripts/'
local ImagePath = 'Entities/Images/'

function Entity.Load()
	-- Examples
	Entity.Registered['Base'] = { Script = love.filesystem.load( ScriptPath .. 'Base.lua' ), Image = love.graphics.newImage( ImagePath .. 'Base.png' ) }
	Entity.Registered['Test'] = { Script = love.filesystem.load( ScriptPath .. 'Test.lua' ), Image = love.graphics.newImage( ImagePath .. 'Base.png' ) }
	
	-- Actual Entities
	Entity.Registered['Player'] = { Script = love.filesystem.load( ScriptPath .. 'Player.lua' ), Image = love.graphics.newImage( ImagePath .. 'Player.png' ) }
end

function Entity.Derive( Path )
	return Entity.Registered[Path].Script()
end

function Entity.New( Name, x, y, Rotation, ScaleX, ScaleY, OffsetX, OffsetY, ShearX, ShearY ) -- Image is not truly necessary, unless using base entity. 
	if Entity.Registered[Name] then
		local Ent = Entity.Registered[Name].Script()
		
		print( 'Entity: Success - ' .. Name .. ' loaded successfully.' )
		
		Ent:Load( Name, x, y, Entity.Registered[Name].Image, Rotation, ScaleX, ScaleY, OffsetX, OffsetY, ShearX, ShearY )
		Entity.Created[#Entity.Created + 1] = Ent
		
		return Ent
	else
		print( 'Entity: Error - ' .. Name .. ' not registered.' )
		return false
	end
end

function Entity.Draw()
	for a = 1, #Entity.Created do
		local Ent = Entity.Created[a]
		Ent:Draw()
	end
end

function Entity.Update( dt )
	for a = 1, #Entity.Created do
		local Ent = Entity.Created[a]
		Ent:Update( dt )
	end
end

function Entity.KeyPressed( Key, IsRepeat )
	for a = 1, #Entity.Created do
		local Ent = Entity.Created[a]
		if Ent.CanControl then
			Ent:KeyPressed( Key, IsRepeat )
		end
	end
end

function Entity.KeyReleased( Key, IsRepeat )
	for a = 1, #Entity.Created do
		local Ent = Entity.Created[a]
		if Ent.CanControl then
			Ent:KeyReleased( Key, IsRepeat )
		end
	end
end

function Entity.MousePressed( x, y, Button )
	for a = 1, #Entity.Created do
		local Ent = Entity.Created[a]
		Ent:MousePressed( x, y, Button )
	end
end

function Entity.MouseReleased( x, y, Button )
	for a = 1, #Entity.Created do
		local Ent = Entity.Created[a]
		Ent:MouseReleased( x, y, Button )
	end
end

function Entity.Register( Name, ScriptPath, ImagePath )
	Entity.Registered[Name] = { Script = love.filesystem.load( Path ), Image = love.graphics.newImage( ImagePath ) }
end

return Entity