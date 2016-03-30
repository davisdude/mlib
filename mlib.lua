--- @author Davis Claiborne
--- @copyright 2016
--- @license MIT

local mlib = {
	_LICENSE = 'MIT. See LICENSE.md for more',
	_URL = 'https://github.com/davisdude/mlib',
	_VERSION = '0.11.0',
	_DESCRIPTION = 'A math and collisions library for Lua.',
}

-- General Functions {{{
local function validateNumber( n )
	if type( n ) ~= 'number' then return false
	elseif n ~= n then return false -- nan
	elseif math.abs( n ) == math.huge then return false
	else return true end
end

-- Convert varargs into a table
local function varargs( ... )
	local args = {}
	if select( '#', ... ) > 1 or type( ... ) ~= 'table' then args = { ... }
	else args = ... end
	return args
end

-- Handle errors
--  err( 'expected a number or string, got %type%.', arg, 'number', 'string' )
--  err( 'variable not registered.', var, function( t ) return tab[t] end )
local function err( errCode, passed, ... )
	local types = { ... }
	local typeOfPassed = type( passed )
	if type( types[1] ) == 'function' then
		assert( types[1]( passed ), errCode:gsub( '%%type%%', typeOfPassed ) )
		return true
	end
	local passed = false
	for i = 1, #types do
		if types[i] == typeOfPassed then
			passed = true
			break
		end
	end
	errCode = errCode:gsub( '%%type%%', typeOfPassed )
	assert( passed, 'Camera Error: ' .. errCode )
end

local function checkFuzzy( x, y, delta )
	return math.abs( x - y ) <= ( delta or .00001 )
end

local function validatePoint( arg )
	return ( type( arg ) == 'number' ) or ( type( arg ) == 'table' and validateNumber( arg[1] ) and validateNumber( arg[2] ) )
end

-- Converts points to a flat table
local function flattenPoints( tab )
	local points = {}
	for _, v in ipairs( tab ) do
		if type( v ) == 'table' then
			points[#points + 1] = v[1]
			points[#points + 1] = v[2]
		else
			points[#points + 1] = v
		end
	end
	return points
end

local function check4Points( name, args )
	err( name .. ': arg 1: should be a number (x1) or a table in the form of { x1, y1 }, got %type%.', args[1], validatePoint )
	err( name .. ': arg 2: should be a number (y1) or a table in the form of { x2, y2 }, got %type%.', args[2], validatePoint )
	err( name .. ': arg 3: should be a number (x2) or a table in the form of { x2, y2 }, got %type%.', args[3], function( arg )
		return validatePoint( arg ) or arg == nil
	end )
	err( name .. ': arg 4: should be a number (y2), got %type%.', args[4], 'number', 'nil' )
end
-- }}}

-- mlib.line {{{

--- Line functions
-- @section line
local line = {}

--- Get the slope of a line
-- @function line.getSlope
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical

--- Get the slope of a line
-- @function line.getSlope
-- @tparam table p1 The coordinates in the form `{ x1, y1 }`
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point

--- Get the slope of a line
-- @function line.getSlope
-- @tparam number x1 The x-coordinate of the second point
-- @tparam number y1 The y-coordinate of the second point
-- @tparam table p2 The coordinates in the form `{ x2, y2 }`

--- Get the slope of a line
-- @function line.getSlope
-- @tparam table p1 The coordinates in the form `{ x1, y1 }`
-- @tparam table p2 The coordinates in the form `{ x2, y2 }`
function line.getSlope( ... )
	local args = varargs( 'line.getSlope', ... )
	check4Points( args )
	local points = flattenPoints( args )
	if checkFuzzy( points[1], points[3] ) then return false
	else return ( points[2] - points[4] ) / ( points[1] - points[3] ) end
end

--- Get the perpendicular slope of a line (see [line.getSlope](index.html#line.getSlope) for other formats)
-- @function line.getPerpendicularSlope
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical
-- @see line.getSlope for other formats

--- Get the perpendicular slope of a line
-- @function line.getPerpendicularSlope
-- @tparam number|boolean m The slope of the line (`false` if the line is vertical)
function line.getPerpendicularSlope( ... )
	local args = varargs( ... )
	check4Points( 'line.getPerpendicularSlope', args )
	local slope
	if #args == 1 then
		slope = args[1]
	else
		slope = mlib.line.getSlope( args )
	end
	if not slope then return 0 -- Vertical lines become horizontal
	elseif checkFuzzy( slope, 0 ) then return false -- Horizontal lines become vertical
	else return -1 / slope end
end

--- Get the midpoint between two points (see [line.getSlope](index.html#line.getSlope) for other formats)
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number x The x-coordinate of the midpoint
-- @treturn number y The y-coordinate of the midpoint
-- @see line.getSlope for other formats
function line.getMidpoint( ... )
	local args = varargs( ... )
	check4Points( 'line.getMidpoint', args )
	local points = flattenPoints( args )
	return ( points[1] + points[3] ) / 2, ( points[2] + points[4] ) / 2
end

--- Get the distance between two points (see [line.getSlope](index.html#line.getSlope) for other formats)
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number d The x-coordinate of the midpoint
-- @see line.getSlope for other formats
function line.getLength( ... )
	local args = varargs( ... )
	check4Points( 'line.getLength', args )
	local points = flattenPoints( args )
	return ( ( points[1] - points[3] ) ^ 2 + ( points[2] - points[4] ) ^ 2 ) ^ .5
end

--- Get the y-intercept of a line (see [line.getSlope](index.html#line.getSlope) for other formats)
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number b The y-intercept of the line
-- @see line.getSlope for other formats

--- Get the y-intercept of a line (see [line.getSlope](index.html#line.getSlope) for other formats)
-- @function line.getIntercept
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number m The y-intercept of the line

--- Get the y-intercept of a line (see [line.getSlope](index.html#line.getSlope) for other formats)
-- @function line.getIntercept
-- @tparam table p1 The coordinates in the form `{ x1, y1 }`
-- @tparam number m The y-intercept of the line
function line.getIntercept( ... )
	local args = varargs( ... )
	err( name .. ': arg 1: should be a number (x1) or a table in the form of { x1, y1 }, got %type%.', args[1], validatePoint )
	err( name .. ': arg 2: should be a number (y1 or slope) or a table in the form of { x2, y2 }, got %type%.', args[2], validatePoint )
	--
	--
	--
	-- finish checking points
	--
	--
	--
	--
	local pass, m = pcall( function() mlib.line.getSlope( args ) end )
	local points = flattenPoints( args )
	if not points then
		-- x1, y1, m; { x1, y1 }, m
		m = flattenPoints( args )[3]
		points[3] = nil
	end
	-- Vertical lines don't intercept the y-axis
	if not m then return false
	-- y = mx + b
	else return points[2] - m * points[1] end
end

function line.getLineIntersection( ... )
	local args = varargs( ... )
	check4Points( 'line.getLineIntersection', args )
	check4Points( 'line.getLineIntersection', { args[5], args[6], args[7], args[8] } )
end

mlib.line = line
--- @section end
-- }}}

return mlib
