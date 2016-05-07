--- @author Davis Claiborne
--- @copyright 2016
--- @license MIT

local mlib = {
	_LICENSE = 'MIT. See LICENSE.md for more',
	_URL = 'https://github.com/davisdude/mlib',
	_VERSION = '0.11.0',
	_DESCRIPTION = 'A math and collisions library for Lua.',
}

-- {{{ General Functions
local turbo = require 'mlib_turbo'
local unpack = unpack or table.unpack

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
	local errCode = errCode:gsub( '%%type%%', typeOfPassed )
	-- Function passed
	if type( types[1] ) == 'function' then
		local returns = { types[1]( passed ) }
		for i = 2, #returns do errCode = errCode:gsub( '%%' .. i - 1, returns[i] ) end
		assert( returns[1], errCode )
		return true
	end
	-- Types passed
	local passed = false
	for i = 1, #types do
		if types[i] == typeOfPassed then
			passed = true
			break
		end
	end
	assert( passed, 'MLib: ' .. errCode )
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
	err( 'line.getSlope: point %1: Expected a number, got %2.', args, function( arg )
		for i = 1, 4 do 
			if type( arg[i] ) ~= 'number' then return false, i, type( arg[i] ) end
		end
		return true
	end )
end
-- }}}

-- {{{ mlib.line
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
	local args = varargs( ... )
	local points = flattenPoints( args )
	check4Points( 'line.getSlope', points )
	return turbo.line.getSlope( unpack( points ) )
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
	local slope
	if #args == 1 then
		slope = args[1]
	else
		local points = flattenPoints( args )
		check4Points( 'line.getPerpendicularSlope', points )
		slope = mlib.line.getSlope( points )
	end
	return turbo.line.getPerpendicularSlope( slope )
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
	local points = flattenPoints( args )
	check4Points( 'line.getMidpoint', points )
	return turbo.line.getMidpoint( unpack( points ) )
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
	local points = flattenPoints( args )
	check4Points( 'line.getLength', points )
	return turbo.line.getLength( unpack( points ) )
end

--- Get the y-intercept of a line (see [line.getSlope](index.html#line.getSlope) for other formats)
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number b The y-intercept of the line
-- @see line.getSlope for other formats
function line.getIntercept( ... )
	local args = varargs( ... )
	local points = flattenPoints( args )
	check4Points( 'line.getIntercept', points )
	return turbo.line.getIntercept( mlib.line.getSlope( points ), points[1], points[2] )
end

--- Get the intersection between two lines
-- @tparam table line1 The first line, in any form acceptable to [line.getSlope](index.html#line.getSlope)
-- @tparam table line2 The second line
-- @see line.getSlope for other formats
function line.getLineIntersection( line1, line2 )
	local points1 = flattenPoints( line1 )
	local points2 = flattenPoints( line2 )
	check4Points( 'line.getLineIntersection', points1 )
	check4Points( 'line.getLineIntersection', points2 )
	local m1, m2 = mlib.line.getSlope( points1 ), mlib.line.getSlope( points2 )
	local b1, b2 = mlib.line.getIntercept( points1 ), mlib.line.getIntercept( points2 )
	return turbo.line.getLineIntersection( { m1, b1 }, { m2, b2 } )
end

mlib.line = line
--- @section end
-- }}}

return mlib
