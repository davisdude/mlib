-- MLib 0.12.0
-- https://github.com/davisdude/mlib
-- mlib/segment.lua
-- MIT License

-- Load Utils
local path = (...):gsub( '/', '.' ):gsub( '%.[^%.]+$', '' ) .. '.'
local Util = require( path .. 'util' )
local Line = require( path .. 'line' )
local module = 'segment'

-- Get the squared distance between two points
-- When just comparing which distance is greater, sqrt is not needed
local function getDistance2( x1, y1, x2, y2 )
	-- Verify params
	Util.checkPoint( x1, y1, 'x1', 'y1', module, 'getDistance2' )
	Util.checkPoint( x2, y2, 'x2', 'y2', module, 'getDistance2' )

	local dx, dy = x1 - x2, y1 - y2
	return dx * dx + dy * dy
end

-- Get the distance between two points
local function getDistance( x1, y1, x2, y2 )
	-- Verify params
	Util.checkPoint( x1, y1, 'x1', 'y1', module, 'getDistance' )
	Util.checkPoint( x2, y2, 'x2', 'y2', module, 'getDistance' )

	return math.sqrt( getDistance2( x1, y1, x2, y2 ) )
end

-- Get the midpoint of two points
local function getMidpoint( x1, y1, x2, y2 )
	-- Verify params
	Util.checkPoint( x1, y1, 'x1', 'y1', module, 'getMidpoint' )
	Util.checkPoint( x2, y2, 'x2', 'y2', module, 'getMidpoint' )

	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

-- Check if a point is on a line segment
local function checkPoint( px, py, x1, y1, x2, y2 )
	-- Verify params
	Util.checkPoint( px, py, 'px', 'py', module, 'checkPoint' )
	Util.checkPoint( x1, y1, 'x1', 'y1', module, 'checkPoint' )
	Util.checkPoint( x2, y2, 'x2', 'y2', module, 'checkPoint' )

	-- If a point is not on the line defined by the segment, then
	-- it's not on the segment
	if not Line.checkPoint( px, py, x1, y1, x2, y2 ) then
		return false
	else
		return Util.checkFuzzy( getDistance( x1,y1, px,py ) + getDistance( px,py, x2,y2 ), getDistance( x1,y1, x2,y2 ) )
	end
end

-- Get intersection with a line
local function getLineIntersection( segment, line )
	-- Verify params
	local tsegment, tline = type( segment ), type( line )
	Util.checkParam( tsegment == 'table', module, 'getLineIntersection', 'segment: Expected table, got %1.', tsegment )
	Util.checkParam( tline == 'table', module, 'getLineIntersection', 'line: Expected table, got %1.', tline )

	-- Parse segment
	local x1, y1, x2, y2 = Util.unpack( segment )
	Util.checkPoint( x1, y1, 'segment: x1', 'segment: y1', module, 'getLineIntersection' )
	Util.checkPoint( x2, y2, 'segment: x2', 'segment: y2', module, 'getLineIntersection' )

	-- Parse line
	local m, x, y
	-- Given slope, x, y
	if #line == 3 then
		m, x, y = Util.unpack( line )

		-- Verify params
		Util.checkSlope( m, 'line: m', module, 'getLineIntersection' )
		Util.checkPoint( x, y, 'line: x', 'line: y', module, 'getLineIntersection' )
	-- Given x1, y1, x2, y2
	else
		local lx1, ly1, lx2, ly2 = Util.unpack( line )

		-- Verify params
		Util.checkPoint( lx1, ly1, 'line: x1', 'line: y1', module, 'getLineIntersection' )
		Util.checkPoint( lx2, ly2, 'line: x2', 'line: y2', module, 'getLineIntersection' )

		m = Line.getSlope( lx1, ly1, lx2, ly2 )
		x, y = lx1, ly1
	end

	-- Get intersection
	local ix, iy = Line.getLineIntersection( { x1, y1, x2, y2 }, { m, x, y } )

	-- Check if lines intersect
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

local function getSegmentIntersection( segment1, segment2 )
	-- Validate params
	local tsegment1, tsegment2 = type( segment1 ), type( segment2 )
	Util.checkParam( tsegment1 == 'table', module, 'getSegmentIntersection',
		'segment1: Expected table, got %1.', tsegment1
	)
	Util.checkParam( tsegment2 == 'table', module, 'getSegmentIntersection',
		'segment2: Expected table, got %1.', tsegment2
	)

	local x1, y1, x2, y2 = Util.unpack( segment1 )
	local x3, y3, x4, y4 = Util.unpack( segment2 )
	Util.checkPoint( x1, y1, 'segment1: x1', 'segment1: y1', module, 'getSegmentIntersection' )
	Util.checkPoint( x2, y2, 'segment1: x2', 'segment1: y2', module, 'getSegmentIntersection' )
	Util.checkPoint( x3, y3, 'segment2: x1', 'segment2: y1', module, 'getSegmentIntersection' )
	Util.checkPoint( x4, y4, 'segment2: x2', 'segment2: y2', module, 'getSegmentIntersection' )

	-- Get intersection of lines created by segments
	local ix, iy = Line.getLineIntersection( segment1, segment2 )

	-- Check if lines created by segments intersect
	if ix then
		-- Non-overlapping lines
		if ix ~= true then
			-- Ensure point is on both segments
			if checkPoint( ix, iy, x1, y1, x2, y2 ) and checkPoint( ix, iy, x3, y3, x4, y4 ) then
				return ix, iy
			end
		-- Overlapping segments
		else
			-- Segments intersect if one's points lies the other segment
			return checkPoint( x1, y1, x3, y3, x4, y4 ) or checkPoint( x2, y2, x3, y3, x4, y4 )
			    or checkPoint( x3, y3, x1, y1, x2, y2 ) or checkPoint( x4, y4, x1, y1, x2, y2 )
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
	getSegmentIntersection = getSegmentIntersection,
}
