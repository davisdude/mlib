local Maps = {}

function Maps.New( File )
	local Map = love.filesystem.load( File )()
	Map.TileTable = Maps.ConvertString( Map.TileString )
	
	if love.graphics.isSupported( 'canvas' ) then
		Maps.SetToCanvas( Map )
	end
	
	return Map
end

function Maps.Draw( self )
	if self.Canvas then
		love.graphics.draw( self.Canvas )
	else
		for ColumnIndex, Column in ipairs( self.TileTable ) do
			for RowIndex, Char in ipairs( Column ) do
				local x = ( ColumnIndex - 1 ) * self.TileWidth
				local y = ( RowIndex - 1 ) * self.TileHeight
			end
		end
	end
end

function Maps.SetToCanvas( self )
	local Width = #( self.TileString:match( '[^\n]+' ) ) * self.TileWidth
	local Height = ( #self.TileString / #( self.TileString:match( '[^\n]+' ) ) ) * self.TileHeight
	
	if not love.graphics.isSupported( 'npot' ) then 
		Width, Height = Maps.FormatP02( Width, Height )
	end
	
	local Canvas = love.graphics.newCanvas( Width, Height )
	
	love.graphics.setCanvas( Canvas )
		local PreviousBlendMode = love.graphics.getBlendMode()
		local PreviousRed, PreviousGreen, PreviousBlue, PreviousAlpha = love.graphics.getColor()
		
		Canvas:clear()
		love.graphics.setBlendMode( 'alpha' )
		
		love.graphics.setColor( 255, 255, 255, 255 )
		
		for ColumnIndex, Column in ipairs( self.TileTable ) do
			for RowIndex, Char in ipairs( Column ) do
				local x = ( ColumnIndex - 1 ) * self.TileWidth
				local y = ( RowIndex - 1 ) * self.TileHeight
				
				love.graphics.draw( self.TileSetImage, self.Quads[Char], x, y )
			end
		end
		
		love.graphics.setBlendMode( PreviousBlendMode )
		love.graphics.setColor( PreviousRed, PreviousGreen, PreviousBlue, PreviousAlpha )
	love.graphics.setCanvas()
	
	self.Canvas = Canvas
end

function Maps.FormatP02( Width, Height )
	local a = 1
	local b = 1
	
	while a < Width do
		a = a * 2
	end
	while b < Height do
		b = b * 2
	end
	
	return a, b
end

function Maps.ConvertString( String )
	local TileTable = {}
	
	local Width = #( String:match( '[^\n]+' ) )
	
	for x = 1, Width do 
		TileTable[x] = {} 
	end
	
	local x, y = 1, 1
	
	for Row in String:gmatch( '[^\n]+' ) do
		x = 1
		
		for Character in Row:gmatch( '.' ) do
			TileTable[x][y] = Character
			x = x + 1
		end
		
		y = y + 1
	end
	
	return TileTable
end

return Maps