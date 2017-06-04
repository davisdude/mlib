-- MLib/line.lua

-- Load utils
local path = (...):gsub( '%.[^%.]+$', '' ) .. '.'
local util = require( path .. 'util' )
local module = 'line'

-- Get the slope of a line given its points
local function getSlope( x1, y1, x2, y2 )
	-- Validate params
	util.checkPoint( x1, y1, 'x1', 'y1', module, 'getSlope' )
	util.checkPoint( x2, y2, 'x2', 'y2', module, 'getSlope' )

	-- `false` is used for vertical lines instead of `nil` to
	-- avoid ambiguity
	if util.checkFuzzy( x1, x2 ) then
		return false
	else
		return ( y2 - y1 ) / ( x2 - x1 )
	end
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
		util.checkSlope( m, 'm', module, 'getPerpendicularSlope' )
	-- Given x1, y1, x2, y2
	else
		local x1, y1, x2, y2 = ...

		-- Validate params
		util.checkPoint( x1, y1, 'x1', 'y1', module, 'getPerpendicularSlope' )
		util.checkPoint( x2, y2, 'x2', 'y2', module, 'getPerpendicularSlope' )

		m = getSlope( x1, y1, x2, y2 )
	end

	-- Get perpendicular slope
	-- Non-vertical line
	if type( m ) == 'number' then
		-- Non-horizontal line
		if not util.checkFuzzy( m, 0 ) then
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
		util.checkSlope( m, 'm', module, 'getYIntercept' )
		util.checkPoint( x, y, 'x', 'y', module, 'getYIntercept' )
	else
	-- Given x1, y1, x2, y2
		local x1, y1, x2, y2 = ...

		-- Validate params
		util.checkPoint( x1, y1, 'x1', 'y1', module, 'getYIntercept' )
		util.checkPoint( x2, y2, 'x2', 'y2', module, 'getYIntercept' )

		m = getSlope( x1, y1, x2, y2 )
		x, y = x1, y1
	end

	-- Get y-intercept
	-- Non-vertical line
	if type( m ) == 'number' then
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
	util.checkPoint( px, py, 'px', 'py', module, 'checkPoint' )

	-- Allow for varargs
	local len = select( '#', ... )

	-- Slope, y-intercept, and x (for vertical lines); assigned later
	local m, b, x

	-- Handle varargs
	-- Given slope, y-intercept
	if len == 2 then
		m, b = ...

		-- Validate params
		util.checkSlope( m, 'm', module, 'checkPoint' )
		util.checkYIntercept( b, 'b', module, 'checkPoint' )

		-- Cannot have vertical lines with two params (no way to check)
		local mtype = type( m )
		util.checkParam( mtype == 'number', module, 'checkPoint',
			'Cannot use two parameter variation to check point for vertical lines.'
		)
	-- Given slope, x, y
	elseif len == 3 then
		-- x can be used for checking vertical lines
		local y
		m, x, y = ...

		-- Validate params
		util.checkSlope( m, 'm', module, 'checkPoint' )
		util.checkPoint( x, y, 'x', 'y', module, 'checkPoint' )

		b = getYIntercept( m, x, y )
	-- Given x1, y1, x2, y2
	else
		local x1, y1, x2, y2 = ...

		-- Validate params
		util.checkPoint( x1, y1, 'x1', 'y1', module, 'checkPoint' )
		util.checkPoint( x2, y2, 'x2', 'y2', module, 'checkPoint' )

		m = getSlope( x1, y1, x2, y2 )
		b = getYIntercept( x1, y1, x2, y2 )
		x = x1
	end

	-- Check if point is on line
	-- Non-vertical line
	if type( m ) == 'number' then
		return util.checkFuzzy( py, m * px + b )
	else
	-- Vertical line
		return util.checkFuzzy( px, x )
	end
end

return {
	getSlope = getSlope,
	getPerpendicularSlope = getPerpendicularSlope,
	getYIntercept = getYIntercept,
	checkPoint = checkPoint,
}
