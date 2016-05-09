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

-- checkTypes( { 'a', 'b', 'c' }, { 'string', 'string', 'string' } ) -- true, 'string', 'string', 'string'
local function checkTypes( args, types )
	local pass = true
	local returns = {}
	for i = 1, #types do
		local t = type( args[i] )
		pass = pass and t == types[i]
		table.insert( returns, t )
	end
	return pass, unpack( returns )
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
		assert( returns[1], 'MLib: ' .. errCode )
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
-- @tparam table points Table in the form `{ x1, y1, x2, y2 }`

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
		check4Points( 'line.getSlope', points, 'in compatibility mode ' )
	end
	return turbo.line.getSlope( unpack( points ) )
end

--- Get the perpendicular slope of a line given slope
-- @function line.getPerpendicularSlope
-- @tparam number|boolean m The slope of the line (`false` if the line is vertical)
-- @treturn number|booean pm The perpendicular slope (`false` if the new slope is vertical)

--- Get the perpendicular slope of a line in the forms of [`line.getSlope`](#line.getSlope)
-- @function line.getPerpendicularSlope
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical
-- @see line.getSlope
function line.getPerpendicularSlope( ... )
	local slope
	if not mlib.compatibilityMode then
		local points = flattenPoints( varargs( ... ) )
		if #points == 1 then
			slope = points[1]
		else
			check4Points( 'line.getPerpendicularSlope', points )
			slope = mlib.line.getSlope( points )
		end
	else
		local args = { ... }
		err( 'line.getPerpendicularSlope: arg 1: in compatibility mode expected a number, got %type%', args[1], 'number' )
		err( 'line.getPerpendicularSlope: arg 2: in compatibility mode expected nil, got %type%', args[2], 'nil' )
		slope = args[1]
	end
	return turbo.line.getPerpendicularSlope( slope )
end

--- Get the y-intercept of a line given slope, x, and y
-- @function line.getIntercept
-- @tparam number|boolean m The slope of the line
-- @tparam number x An x-coordinate on the line
-- @tparam number y An y-coordinate on the line
-- @treturn number|boolean b The y-intercept (`false` if the line is vertical)

--- Get the y-intercept of a line in the forms of [`line.getSlope`](#line.getSlope)
-- @function line.getIntercept
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number b The y-intercept of the line
-- @see line.getSlope
function line.getIntercept( ... )
	local m, x, y
	if not mlib.compatibilityMode then
		local points = flattenPoints( varargs( ... ) )
		if #points == 3 then
			m, x, y = unpack( points )
		else
			check4Points( 'line.getIntercept', points )
			m = mlib.line.getSlope( points )
			x, y = points[1], points[2]
		end
	else
		m, x, y = ...
		err( 'line.getIntercept: arg 1: in compatibility mode expected a number or boolean, got %type%', m, 'number', 'boolean' )
		err( 'line.getIntercept: arg 2: in compatibility mode expected a number, got %type%', x, 'number' )
		err( 'line.getIntercept: arg 3: in compatibility mode expected a number, got %type%', y, 'number' )
	end
	return turbo.line.getIntercept( m, x, y )
end

--- Get the intersection of two lines in the form of `{ slope, x1, y1 }`
-- @function line.getLineIntersection
-- @tparam table line1 A line in the form `{ slope, x1, y1 }`
-- @tparam table line2 Another line in the same form
-- @treturn[1] number x The x-coordinate of the intersection
-- @treturn[1] number y The y-coordinate of the intersection
-- @treturn[2] boolean intersects `true`/`false` if the lines do/don't intersect (vertical/horizontal)

--- Get the intersection of two lines in the forms of [`line.getSlope`](#line.getSlope)
-- @function line.getLineIntersection
-- @tparam table line1 The first line, in any form acceptable to [`line.getSlope`](#line.getSlope)
-- @tparam table line2 The second line, in any form acceptable to [`line.getSlope`](#line.getSlope)
-- @see line.getSlope
function line.getLineIntersection( line1, line2 )
	err( 'line.getLineIntersection: arg 1: expected a table, got %type%', line1, 'table' )
	err( 'line.getLineIntersection: arg 2: expected a table, got %type%', line2, 'table' )
	local m1, x1, x2, m2, x2, y2

	if mlib.compatibilityMode then
		err( 'line.getLineIntersection: arg 1: in compatibility mode expected a table with [1], [2], and [3] to all be numbers, got %1, %2, %3', line1, function( line )
			return checkTypes( line, { 'number', 'number', 'number' } )
		end )
		err( 'line.getLineIntersection: arg 2: in compatibility mode expected a table with [1], [2], and [3] to all be numbers, got %1, %2, %3', line2, function( line )
			return checkTypes( line, { 'number', 'number', 'number' } )
		end )
		assert( #line1 == 3, 'MLib: line.getLineIntersection: arg 1: in compatibility mode expected a table with a length of 3, got a table with a length of ' .. #line1 )
		assert( #line2 == 3, 'MLib: line.getLineIntersection: arg 2: in compatibility mode expected a table with a length of 3, got a table with a length of ' .. #line2 )
		m1, x1, y1 = unpack( line1 )
		m2, x2, y2 = unpack( line2 )
	else
		-- line 1
		if #line1 == 3 then
			err( 'line.getLineIntersection: arg 1: expected a table with [1], [2], and [3] to all be numbers, got %1, %2, %3', line1, function( line )
				return checkTypes( line, { 'number', 'number', 'number' } )
			end )
			m1, x1, y1 = unpack( line1 )
		elseif #line1 == 4 then
			err( 'line.getLineIntersection: arg 1: expected a table with [1], [2], [3], and [4] to all be numbers, got %1, %2, %3, %4', line1, function( line )
				return checkTypes( line, { 'number', 'number', 'number', 'number' } )
			end )
			local a, b, c, d = unpack( line1 )
			x1, y1 = a, b
			m1 = mlib.line.getSlope( a, b, c, d )
		else
			error( 'mlib: line.getLineIntersection: arg 1: incorrect table format' )
		end

		-- line 2
		if #line2 == 3 then
			err( 'line.getLineIntersection: arg 1: expected a table with [1], [2], and [3] to all be numbers, got %1, %2, %3 in compatibility mode', line2, function( line )
				return checkTypes( line, { 'number', 'number', 'number' } )
			end )
			m2, x2, y2 = unpack( line2 )
		elseif #line2 == 4 then
			err( 'line.getLineIntersection: arg 1: expected a table with [1], [2], [3], and [4] to all be numbers, got %1, %2, %3, %4', line2, function( line )
				return checkTypes( line, { 'number', 'number', 'number', 'number' } )
			end )
			local a, b, c, d = unpack( line2 )
			x2, y2 = a, b
			m2 = mlib.line.getSlope( a, b, c, d )
		else
			error( 'mlib: line.getLineIntersection: arg 1: incorrect table format' )
		end
	end

	return turbo.line.getLineIntersection( { m1, x1, y1 }, { m2, x2, y2 } )
end

mlib.line = line
-- @section end
-- }}}
-- {{{ mlib.segment

--- mlib.segment
-- - segment functions
-- @section milb.segment
local segment = {}

--- Get the midpoint between two points (see [`line.getSlope`](#line.getSlope) for other formats)
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint
-- @see line.getSlope
function segment.getMidpoint( ... )
	local points
	if mlib.compatibilityMode then
		points = { ... }
		check4Points( 'segment.getMidpoint', points, 'in compatibility mode ' )
	else
		points = flattenPoints( varargs( ... ) )
		check4Points( 'segment.getMidpoint', points )
	end
	return turbo.segment.getMidpoint( unpack( points ) )
end

--- Get the distance between two points (see [`line.getSlope`](#line.getSlope) for other formats)
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint
-- @see line.getSlope
function segment.getLength( ... )
	local points
	if mlib.compatibilityMode then
		points = { ... }
		check4Points( 'segment.getLength', points, 'in compatibility mode ' )
	else
		points = flattenPoints( varargs( ... ) )
		check4Points( 'segment.getLength', points )
	end
	return turbo.segment.getLength( unpack( points ) )
end

mlib.segment = segment
-- @section end
-- }}}

return mlib
