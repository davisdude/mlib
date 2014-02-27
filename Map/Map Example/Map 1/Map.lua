local Map = {
	TileWidth = 16, 
	TileHeight = 16, 
	
	QuadInformation = {
		{ ' ', 0, 0 }, 		-- Air
		{ '#', 16, 0 }, 	-- Wall
		{ '!', 0, 16 }, 	-- Obstacle
		{ 'g', 16, 16 },	-- Ground
	}, 
	
	TileSetImage = love.graphics.newImage( 'Maps/Map 1/Tile Set.png' ), 
	
	TileString = [[
  #     #  #  #   # ####      ##    ###     
  #      ##   #   # #           #   #  #    
  #     #  #  #   # ####        #   #  #    
  #     #  #   # #  #          #    #  #    
  ####   ##     #   ####      ####  ###     

]], 
	
	Quads = {}, 
}
Map.TileSetWidth = Map.TileSetImage:getWidth()
Map.TileSetHeight = Map.TileSetImage:getHeight() 

for _, Information in ipairs( Map.QuadInformation ) do
	Map.Quads[Information[1]] = love.graphics.newQuad( Information[2], Information[3], Map.TileWidth, Map.TileHeight, Map.TileSetWidth, Map.TileSetHeight )
end

return Map