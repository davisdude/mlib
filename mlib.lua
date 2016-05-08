--- A math and collisions library
--- @module mlib
--- @author Davis Claiborne
--- @copyright 2016
--- @license MIT

local mlib = {
	_LICENSE = 'MIT. See LICENSE.md for more',
	_URL = 'https://github.com/davisdude/mlib',
	_VERSION = '0.11.0',
	_DESCRIPTION = 'A math and collisions library for Lua.',
}
--- Set whether mlib should be compatible to turbo or not.
--
-- If `true`, all functions must be called as if they are [turbo](mlib_turbo.html) functions.
--
-- If `false`, functions can be called in any way listed above.
--
-- Use this option if you want to have better speed later, but need error checking now or to enforce a coding style.
--
-- For the purpose of documentation, the first given syntax for a function is the "correct" way to call it.
mlib.compatibilityMode = true

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

local function check4Points( name, args, condition )
	condition = condition or ''
	err( name .. ': point %1: ' .. condition .. 'expected a number, got %2', args, function( arg )
		for i = 1, 4 do
			if type( arg[i] ) ~= 'number' then return false, i, type( arg[i] ) end
		end
		return true
	end )
end
-- }}}
-- {{{ mlib.line

--- mlib.line
-- - line functions
-- @section milb.line
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
	local points
	if not mlib.compatibilityMode then
		points = varargs( ... )
		points = flattenPoints( points )
		check4Points( 'line.getSlope', points )
	else
		points = { ... }
		check4Points( 'line.getSlope', points, ' in compatibility mode ' )
	end
	return turbo.line.getSlope( unpack( points ) )
end

--- Get the perpendicular slope of a line
-- @function line.getPerpendicularSlope
-- @tparam number|boolean m The slope of the line (`false` if the line is vertical)
-- @treturn number|booean pm The perpendicular slope (`false` if the new slope is vertical)

--- Get the perpendicular slope of a line (see [line.getSlope](#line.getSlope) for other formats)
-- @function line.getPerpendicularSlope
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical
-- @see line.getSlope
function line.getPerpendicularSlope( ... )
	local args = varargs( ... )
	local slope
	if #args == 1 then
		slope = args[1]
	elseif not mlib.compatibilityMode then
		local points = flattenPoints( args )
		check4Points( 'line.getPerpendicularSlope', points )
		slope = mlib.line.getSlope( points )
	else
		check4Points( 'line.getPerpendicularSlope', points, ' in compatibilty mode' )
	end
	return turbo.line.getPerpendicularSlope( slope )
end

--- Get the y-intercept of a line
-- @tparam number|boolean m The slope of the line
-- @tparam number x An x-coordinate on the line
-- @tparam number y An y-coordinate on the line
-- @treturn number|boolean b The y-intercept (`false` if the line is vertical)
--
-- @function line.getIntercept (see [line.getSlope](#line.getSlope) for other formats)
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number b The y-intercept of the line
-- @see line.getSlope
function line.getIntercept( ... )
	local points = varargs( ... )
	if not mlib.compatibilityMode then points = flattenPoints( points ) end
	check4Points( 'line.getIntercept', points )
	return turbo.line.getIntercept( mlib.line.getSlope( points ), points[1], points[2] )
end

--- Get the intersection of two lines
-- @function line.getLineIntersection
-- @tparam table line1 A line in the form `{ slope, y-intercept }`
-- @tparam table line2 Another line in the same form
-- @treturn boolean|number x The x-coordinate of the intersection (`false` if they don't intersect)
-- @terturn number y The y-coordinate of the intersection

--- Get the intersection of two lines
-- @function line.getLineIntersection
-- @tparam table line1 The first line, in any form acceptable to [line.getSlope](#line.getSlope)
-- @tparam table line2 The second line
-- @see line.getSlope
function line.getLineIntersection( line1, line2 )
	err( 'line.getLineIntersection: arg 1: expected a table, got %type%', line1, 'table' )
	err( 'line.getLineIntersection: arg 1: expected a table, got %type%', line2, 'table' )
	local points1 = flattenPoints( line1 )
	local points2 = flattenPoints( line2 )
	local m1, b1, m2, b2

	-- line 1
	if #points1 == 2 then
		m1, b1 = unpack( points1 )
		err( 'line.getLineIntersection: arg 1: index 1: expected a number, got %type%', m1, 'number' )
		err( 'line.getLineIntersection: arg 1: index 2: expected a number, got %type%', b1, 'number' )
	elseif not mlib.compatibilityMode then
		check4Points( 'line.getLineIntersection', points1 )
		m1, b1 = mlib.line.getSlope( points1 ), mlib.line.getIntercept( points1 )
	else
		error( 'mlib: line.getLineIntersection: arg 1: expected a table with length 2 in compatibility mode, got a table with length ' .. #points1, nil, 'true' )
	end

	-- line 2
	if #points2 == 2 then
		m2, b2 = unpack( points2 )
		err( 'line.getLineIntersection: arg 2: index 1: expected a number, got %type%', m2, 'number' )
		err( 'line.getLineIntersection: arg 2: index 2: expected a number, got %type%', b2, 'number' )
	elseif not mlib.compatibilityMode then
		check4Points( 'line.getLineIntersection', points2 )
		m2, b2 = mlib.line.getSlope( points2 ), mlib.line.getIntercept( points2 )
	else
		error( 'mlib: line.getLineIntersection: arg 1: expected a table with length 2 in compatibility mode, got a table with length ' .. #points1, nil, 'true' )
	end
	return turbo.line.getLineIntersection( { m1, b1 }, { m2, b2 } )
end

mlib.line = line
-- @section end
-- }}}
-- {{{ mlib.vector

--- mlib.vector
-- - vector functions
-- @section milb.vector
local vector = {}

--- Get the midpoint between two points (see [line.getSlope](#line.getSlope) for other formats)
-- @tparam table point1 The first point in the form `{ x1, y1 }`
-- @tparam table point2 The second point in the form `{ x2, y2 }`
-- @treturn table midpoint The midpoint in the form `{ mx, my }`
-- @see line.getSlope
function vector.getMidpoint( ... )
	local points
	if mlib.compatibilityMode then
		local p1, p2 = ...
		err( 'vector.getMidpoint: arg 1: expected a table in compatibility mode, got %type%', p1, 'table' )
		err( 'vector.getMidpoint: arg 2: expected a table in compatibility mode, got %type%', p2, 'table' )
		err( 'vector.getMidpoint: expected 2 arguments, got %1', { ... }, function( args )
			local i = #i
			return i == 2, i
		end )
		err( 'vector.getMidpoint: arg 1: expected table to have [1] and [2] be numbers, got %1 and %2', p1, function( p1 )
			local t1, t2 = type( p1[1] ), type( p1[2] )
			return t1 == 'number' and t2 == 'number', t1, t2
		end )
		err( 'vector.getMidpoint: arg 2: expected table to have [1] and [2] be numbers, got %1 and %2', p2, function( p2 )
			local t1, t2 = type( p2[1] ), type( p2[2] )
			return t1 == 'number' and t2 == 'number', t1, t2
		end )
		points = { p1, p2 }
	else
		points = varargs( ... )
	end
	points = flattenPoints( points )
	check4Points( 'vector.getMidpoint', points )
	return turbo.vector.getMidpoint( { points[1], points[2] }, { points[3], points[4] } )
end

--- Get the distance between two points (see [line.getSlope](#line.getSlope) for other formats)
-- @tparam table p1 The first point in the form `{ x1, y1 }`
-- @tparam table p1 The second point in the form `{ x2, y2 }`
-- @treturn number d The length of the segment
-- @see line.getSlope
function vector.getLength( ... )
	local points
	if mlib.compatibilityMode then
		local p1, p2 = ...
		err( 'vector.getLength: arg 1: expected a table in compatibility mode, got %type%', p1, 'table' )
		err( 'vector.getLength: arg 2: expected a table in compatibility mode, got %type%', p2, 'table' )
		err( 'vector.getLength: expected 2 arguments, got %1', { ... }, function( args )
			local i = #args
			return i == 2, i
		end )
		err( 'vector.getLength: arg 1: expected table to have [1] and [2] be numbers, got %1 and %2', p1, function( p1 )
			local t1, t2 = type( p1[1] ), type( p1[2] )
			return t1 == 'number' and t2 == 'number', t1, t2
		end )
		err( 'vector.getLength: arg 2: expected table to have [1] and [2] be numbers, got %1 and %2', p2, function( p2 )
			local t1, t2 = type( p2[1] ), type( p2[2] )
			return t1 == 'number' and t2 == 'number', t1, t2
		end )
		points = { p1, p2 }
	else
		points = varargs( ... )
	end
	points = flattenPoints( points )
	check4Points( 'vector.getLength', points )
	return turbo.vector.getLength( { points[1], points[2] }, { points[3], points[4] } )
end

mlib.vector = vector
-- @section end
-- }}}

return mlib
