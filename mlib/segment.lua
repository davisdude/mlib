-- MLib 0.12.0
-- https://github.com/davisdude/mlib
-- mlib/segment.lua
-- MIT License

-- Load utils
local path = (...):gsub( '%.[^%.]+$', '' ) .. '.'
local util = require( path .. 'util' )
local line = require( path .. 'line' )
local module = 'segment'

-- Get the squared distance between two points
-- When just comparing which distance is greater, sqrt is not needed
local function getDistance2( x1, y1, x2, y2 )
	-- Verify params
	util.checkPoint( x1, y1, 'x1', 'y1', module, 'getDistance2' )
	util.checkPoint( x2, y2, 'x2', 'y2', module, 'getDistance2' )

	local dx, dy = x1 - x2, y1 - y2
	return dx * dx + dy * dy
end

-- Get the distance between two points
local function getDistance( x1, y1, x2, y2 )
	-- Verify params
	util.checkPoint( x1, y1, 'x1', 'y1', module, 'getDistance' )
	util.checkPoint( x2, y2, 'x2', 'y2', module, 'getDistance' )

	return math.sqrt( getDistance2( x1, y1, x2, y2 ) )
end

-- Get the midpoint of two points
local function getMidpoint( x1, y1, x2, y2 )
	-- Verify params
	util.checkPoint( x1, y1, 'x1', 'y1', module, 'getMidpoint' )
	util.checkPoint( x2, y2, 'x2', 'y2', module, 'getMidpoint' )

	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

-- Check if a point is on a line segment
local function checkPoint( px, py, x1, y1, x2, y2 )
	-- Verify params
	util.checkPoint( px, py, 'px', 'py', module, 'checkPoint' )
	util.checkPoint( x1, y1, 'x1', 'y1', module, 'checkPoint' )
	util.checkPoint( x2, y2, 'x2', 'y2', module, 'checkPoint' )

	-- If a point is not on the line defined by the segment, then
	-- it's not on the segment
	if not line.checkPoint( px, py, x1, y1, x2, y2 ) then
		return false
	else
		return util.checkFuzzy( getDistance( x1,y1, px,py ) + getDistance( px,py, x2,y2 ), getDistance( x1,y1, x2,y2 ) )
	end
end

-- Get intersection with a line
local function getLineIntersection( x1, y1, x2, y2, ... )
	-- Verify params
	util.checkPoint( x1, y1, 'x1', 'y1', module, 'getLineIntersection' )
	util.checkPoint( x2, y2, 'x2', 'y2', module, 'getLineIntersection' )

	local len = select( '#' , ... )
	local m, x, y

	-- Given slope, x, y
	if len == 3 then
		m, x, y = ...

		-- Verify params
		util.checkSlope( m, 'line: m', module, 'getLineIntersection' )
		util.checkPoint( x, y, 'line: x', 'line: y', module, 'getLineIntersection' )
	-- Given x1, y1, x2, y2
	else
		local lx1, ly1, lx2, ly2 = ...

		-- Verify params
		util.checkPoint( lx1, ly1, 'line: x1', 'line: y1', module, 'getLineIntersection' )
		util.checkPoint( lx2, ly2, 'line: x2', 'line: y2', module, 'getLineIntersection' )

		m = line.getSlope( lx1, ly1, lx2, ly2 )
		x, y = lx1, ly1
	end

	-- Get intersection
	local ix, iy = line.getLineIntersection( { x1, y1, x2, y2 }, { m, x, y } )

	-- Check if intersection point is on segment
	if ix then
		-- Non-overlapping lines
		if ix ~= true then
			if checkPoint( ix, iy, x1, y1, x2, y2 ) then
				return ix, iy
			end
		-- Overlapping lines
		else
			return true
		end
	end
	return false
end

return {
	getDistance2 = getDistance2,
	getDistance = getDistance,
	getMidpoint = getMidpoint,
	checkPoint = checkPoint,
	getLineIntersection = getLineIntersection,
}
