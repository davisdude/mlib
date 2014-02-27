local Animations = {}
Animations.__index = Animations

function Animations.New( Image, Data )
	--[[
		Data format:
		Data = {
			Name = {
				Quad1, 
				Quad2, 
				etc., 
				Delay = Number, 
			}, 
		}
	]]
	
	local Animation = {}
	
	for Name, State in pairs( Data ) do
		Animation[Name] = State
		Animation[Name].TileSet = Image
		
		if State.Delay then 
			Animation[Name].Delay = State.Delay 
		else 
			Animation[Name].Delay = 0.1
		end
		
		Animation[Name].AnimationTimer = 0
		Animation[Name].PictureNumber = 1
		Animation[Name].CurrentImage = Animation[Name][1]
		
		setmetatable( Animation[Name], Animations )
	end
	
	return Animation
end

function Animations:Draw( x, y, Rotation, ScaleX, ScaleY, OffsetX, OffsetY, ShearingX, ShearingY )
	-- Get all the variables registered correctly (make sure none are nil).
	local x = x or 0
	local y = y or 0
	local Rotation = Rotation or 0
	local ScaleX = ScaleX or 1
	local ScaleY = ScaleY or 1
	local OffsetX = OffsetX or 1
	local OffsetY = OffsetY or 1
	local ShearingX = ShearingX or 0
	local ShearingY = ShearingY or 0
	
	love.graphics.draw( self.TileSet, self.CurrentImage, x, y, Rotation, ScaleX, ScaleY, OffsetX, OffsetY, ShearingX, ShearingY )
end

local function Loop( Number, Length )
	if Number > Length then 
		return 1
	end
	return Number
end

function Animations:Update( dt )
	self.CurrentImage = self[self.PictureNumber]
	self.AnimationTimer = self.AnimationTimer + dt 
	
	if self.AnimationTimer > self.Delay then
		self.PictureNumber = Loop( self.PictureNumber + 1, #self )
		self.AnimationTimer = 0
	end
end

return Animations