-- MLib 0.12.0
-- https://github.com/davisdude/mlib
-- mlib/line.lua
-- MIT License

-- Load Utils
local path = (...):gsub( '/', '.' ):gsub( '%.[^%.]+$', '' ) .. '.'
local Util = require( path .. 'util' )
local module = 'line'

-- Get the slope of a line given its points
local function getSlope( x1, y1, x2, y2 )
	-- Validate params
	Util.checkPoint( x1, y1, 'x1', 'y1', module, 'getSlope' )
	Util.checkPoint( x2, y2, 'x2', 'y2', module, 'getSlope' )

	-- `false` is used for vertical lines instead of `nil` to
	-- avoid ambiguity
	if Util.checkFuzzy( x1, x2 ) then
		return false
	else
		return ( y2 - y1 ) / ( x2 - x1 )
	end
end

-- Check if a line is vertical
local function isVertical( ... )
	local len = select( '#', ... )

	-- Slope of the line; assigned later
	local m

	-- Given:
	-- 	- m
	-- 	- m, x, y
	-- 	- (m, b is not included to avoid possibility of (x1, y1, nil, nil))
	if len == 1 or len == 3 then
		m = ...

		-- Validate params
		Util.checkSlope( m, 'm', module, 'isVertical' )
	-- Given x1, y1, x2, y2
	else
		local x1, y1, x2, y2 = ...

		-- Validate params
		Util.checkPoint( x1, y1, 'x1', 'y1', module, 'isVertical' )
		Util.checkPoint( x2, y2, 'x2', 'y2', module, 'isVertical' )

		m = getSlope( x1, y1, x2, y2 )
	end

	return m == false
end

-- Get the perpendicular slope of a line
local function getPerpendicularSlope( ... )
	-- Allow for varargs
	local len = select( '#', ... )

	-- Slope of the line; assigned below
	local m

	-- Handle varargs
	-- Given slope
	if len == 1 then
		m = ...

		-- Validate params
		-- Slope can be number or boolean (false = parallel)
		Util.checkSlope( m, 'm', module, 'getPerpendicularSlope' )
	-- Given x1, y1, x2, y2
	else
		local x1, y1, x2, y2 = ...

		-- Validate params
		Util.checkPoint( x1, y1, 'x1', 'y1', module, 'getPerpendicularSlope' )
		Util.checkPoint( x2, y2, 'x2', 'y2', module, 'getPerpendicularSlope' )

		m = getSlope( x1, y1, x2, y2 )
	end

	-- Get perpendicular slope
	-- Non-vertical line
	if not isVertical( m ) then
		-- Non-horizontal line
		if not Util.checkFuzzy( m, 0 ) then
			return -1 / m
		-- Horizontal line
		else
			return false
		end
	-- Vertical line
	else
		return 0
	end
end

local function getYIntercept( ... )
	-- Allow for varargs
	local len = select( '#', ... )

	-- Slope and points; assigned later
	local m, x, y

	-- Handle varargs
	-- Given slope, x, y
	if len == 3 then
		m, x, y = ...

		-- Validate params
		Util.checkSlope( m, 'm', module, 'getYIntercept' )
		Util.checkPoint( x, y, 'x', 'y', module, 'getYIntercept' )
	else
	-- Given x1, y1, x2, y2
		local x1, y1, x2, y2 = ...

		-- Validate params
		Util.checkPoint( x1, y1, 'x1', 'y1', module, 'getYIntercept' )
		Util.checkPoint( x2, y2, 'x2', 'y2', module, 'getYIntercept' )

		m = getSlope( x1, y1, x2, y2 )
		x, y = x1, y1
	end

	-- Get y-intercept
	-- Non-vertical line
	if not isVertical( m ) then
		-- y = mx + b --> b = y - mx
		return y - m * x
	-- Vertical line
	else
		-- Vertical lines don't have y-intercepts
		return false
	end
end

-- Check if a point is on a line
local function checkPoint( px, py, ... )
	-- Validate test points
	Util.checkPoint( px, py, 'px', 'py', module, 'checkPoint' )

	-- Allow for varargs
	local len = select( '#', ... )

	-- Slope, y-intercept, and x (for vertical lines); assigned later
	local m, b, x

	-- Handle varargs
	-- Given slope, y-intercept
	if len == 2 then
		m, b = ...

		-- Validate params
		Util.checkSlope( m, 'm', module, 'checkPoint' )
		Util.checkYIntercept( b, 'b', module, 'checkPoint' )

		-- Cannot have vertical lines with two params (no way to check)
		local mtype = type( m )
		Util.checkParam( mtype == 'number', module, 'checkPoint',
			'Cannot use two parameter variation to check point for vertical lines.'
		)
	-- Given slope, x, y
	elseif len == 3 then
		-- x can be used for checking vertical lines
		local y
		m, x, y = ...

		-- Validate params
		Util.checkSlope( m, 'm', module, 'checkPoint' )
		Util.checkPoint( x, y, 'x', 'y', module, 'checkPoint' )

		b = getYIntercept( m, x, y )
	-- Given x1, y1, x2, y2
	else
		local x1, y1, x2, y2 = ...

		-- Validate params
		Util.checkPoint( x1, y1, 'x1', 'y1', module, 'checkPoint' )
		Util.checkPoint( x2, y2, 'x2', 'y2', module, 'checkPoint' )

		m = getSlope( x1, y1, x2, y2 )
		b = getYIntercept( x1, y1, x2, y2 )
		x = x1
	end

	-- Check if point is on line
	-- Non-vertical line
	if not isVertical( m ) then
		return Util.checkFuzzy( py, m * px + b )
	else
	-- Vertical line
		return Util.checkFuzzy( px, x )
	end
end

-- Check if two lines are parallel
local function areLinesParallel( line1, line2 )
	-- Check params
	local t1, t2 = type( line1 ), type( line2 )
	Util.checkParam( t1 == 'table', module, 'areLinesParallel', 'line1: Expected table, got %1', t1 )
	Util.checkParam( t2 == 'table', module, 'areLinesParallel', 'line2: Expected table, got %1', t2 )

	-- Slope 1 and 2; assigned later
	local m1, m2

	local len1, len2 = #line1, #line2
	if len1 == 1 or len1 == 3 then
		m1 = Util.unpack( line1 )
		Util.checkSlope( m1, 'line1: m', module, 'areLinesParallel' )
	else
		local x1, y1, x2, y2 = Util.unpack( line1 )
		Util.checkPoint( x1, y1, 'line1: x1', 'line1: y1', module, 'areLinesParallel' )
		Util.checkPoint( x2, y2, 'line1: x2', 'line1: y2', module, 'areLinesParallel' )
		m1 = getSlope( x1, y1, x2, y2 )
	end

	if len2 == 1 or len2 == 2 or len2 == 3 then
		m2 = Util.unpack( line2 )
		Util.checkSlope( m2, 'line2: m', module, 'areLinesParallel' )
	else
		local x1, y1, x2, y2 = Util.unpack( line2 )
		Util.checkPoint( x1, y1, 'line2: x1', 'line2: y1', module, 'areLinesParallel' )
		Util.checkPoint( x2, y2, 'line2: x2', 'line2: y2', module, 'areLinesParallel' )
		m2 = getSlope( x1, y1, x2, y2 )
	end

	-- Check slopes
	local v1, v2 = isVertical( m1 ), isVertical( m2 )
	-- Both non-vertical lines
	if ( not v1 ) and ( not v2 ) then
		return Util.checkFuzzy( m1, m2 )
	-- One vertical and one non-vertical
	elseif ( not v1 ) or ( not v2 ) then
		-- These lines will never be parallel
		return false
	-- Two vertical lines
	else
		-- These line will always be parallel
		return true
	end
end

-- Get the intersection of two lines
local function getLineIntersection( line1, line2 )
	-- Check params
	local t1, t2 = type( line1 ), type( line2 )
	Util.checkParam( t1 == 'table', module, 'getLineIntersection', 'line1: Expected table, got %1', t1 )
	Util.checkParam( t2 == 'table', module, 'getLineIntersection', 'line2: Expected table, got %1', t2 )

	-- Slope 1 and 2, x and y point on line1 and line2; assigned later
	local m1, m2, x1, y1, x2, y2

	local len1, len2 = #line1, #line2
	if len1 == 3 then
		m1, x1, y1 = Util.unpack( line1 )
		Util.checkSlope( m1, 'line1: m', module, 'getLineIntersection' )
		Util.checkPoint( x1, y1, 'line1: x', 'line1: y', module, 'getLineIntersection' )
	else
		local p1x2, p1y2
		x1, y1, p1x2, p1y2 = Util.unpack( line1 )
		Util.checkPoint( x1, y1, 'line1: x1', 'line1: y1', module, 'getLineIntersection' )
		Util.checkPoint( p1x2, p1y2, 'line1: x2', 'line1: y2', module, 'getLineIntersection' )
		m1 = getSlope( x1, y1, p1x2, p1y2 )
	end

	if len2 == 3 then
		m2, x2, y2 = Util.unpack( line2 )
		Util.checkSlope( m2, 'line2: m', module, 'getLineIntersection' )
		Util.checkPoint( x2, y2, 'line2: x', 'line2: y', module, 'getLineIntersection' )
	else
		local p2x1, p2y1
		p2x1, p2y1, x2, y2 = Util.unpack( line2 )
		Util.checkPoint( p2x1, p2y1, 'line2: x1', 'line2: y1', module, 'getLineIntersection' )
		Util.checkPoint( x2, y2, 'line2: x2', 'line2: y2', module, 'getLineIntersection' )
		m2 = getSlope( p2x1, p2y1, x2, y2 )
	end

	-- Get y-intercept
	local b1, b2 = getYIntercept( m1, x1, y1 ), getYIntercept( m2, x2, y2 )

	-- Get intersection
	-- Parallel lines only intersect if they're the same y-intercept
	if not areLinesParallel( { m1 }, { m2 } ) then
		local v1, v2 = isVertical( m1 ), isVertical( m2 )
		-- Both non-vertical lines
		if ( not v1 ) and ( not v2 ) then
			-- Both non-horizontal lines
			local line1equals0, line2equals0 = Util.checkFuzzy( m1, 0 ), Util.checkFuzzy( m2, 0 )
			if not line1equals0 and not line2equals0 then
				-- m1 x + b1 = m2 x + b2
				-- x ( m1 - m2 ) = b2 - b1
				-- x = ( b2 - b1 ) / ( m1 - m2 )
				local x = ( b2 - b1 ) / ( m1 - m2 )
				return x, m1 * x + b1
			-- One non-horizontal line
			else
				local y, m, b

				-- line1 is horizontal
				if line1equals0 then
					y = y1
					m, b = m2, b2
				-- line2 is horizontal
				else
					y = y2
					m, b = m1, b1
				end

				-- y = mx + b
				-- x = ( y - b ) / m
				local x = ( y - b ) / m
				return x, y
			end
		-- One non-vertical line
		elseif ( not v1 ) or ( not v2 ) then
			local m, x, b

			-- line1 is vertical
			if v1 then
				x = x1
				m, b = m2, b2
			-- line2 is vertical
			else
				x = x2
				m, b = m1, b1
			end

			local y = m * x + b
			return x, y
		-- Two vertical lines
		else
			return Util.checkFuzzy( x1, x2 )
		end
	-- Parallel lines
	else
		-- Non-vertical lines
		if not isVertical( m1 ) then
			return Util.checkFuzzy( b1, b2 )
		-- Vertical lines
		else
			return Util.checkFuzzy( x1, x2 )
		end
	end
end

-- Get closest point on the line to point
local function getClosestPoint( px, py, ... )
	-- Validate params
	Util.checkPoint( px, py, 'px', 'py', module, 'getClosestPoint' )
	local len = select( '#', ... )
	local m, x, y

	-- Given slope
	if len == 3 then
		m, x, y = ...

		-- Validate params
		Util.checkSlope( m, 'm', module, 'getClosestPoint' )
		Util.checkPoint( x, y, 'x', 'y', module, 'getClosestPoint' )
	-- Given x1, y1, x2, y2
	elseif len == 4 then
		local x1, y1, x2, y2 = ...

		-- Validate params
		Util.checkPoint( x1, y1, 'x1', 'y1', module, 'getClosestPoint' )
		Util.checkPoint( x2, y2, 'x2', 'y2', module, 'getClosestPoint' )

		m = getSlope( x1, y1, x2, y2 )
		x, y = x1, y1
	end

	local pm = getPerpendicularSlope( m )
	return getLineIntersection( { m, x, y }, { pm, px, py } )
end

return {
	getSlope = getSlope,
	isVertical = isVertical,
	getPerpendicularSlope = getPerpendicularSlope,
	getYIntercept = getYIntercept,
	checkPoint = checkPoint,
	areLinesParallel = areLinesParallel,
	getLineIntersection = getLineIntersection,
	getClosestPoint = getClosestPoint,
}
