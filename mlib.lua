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
	if type( n ) ~= 'number' then return false, n
	elseif n ~= n then return false, n -- nan
	elseif math.abs( n ) == math.huge then return false, n
	else return true, n end
end

local function validateSlope( m )
	return validateNumber( m ) or m == false, m
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
		local f = types[1]
		-- Use select() to handle nils passed as a function
		if not select( 1, f( passed ) ) then
			for i = 2, select( '#', f( passed ) ) do
				errCode = errCode:gsub( '%%' .. i - 1, tostring( select( i, f( passed ) ) ) )
			end
			error( 'MLib: ' .. errCode )
		end
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
-- }}}
-- {{{ mlib.line

--- mlib.line
-- - line functions
-- @section milb.line
local line = {}
-- {{{ line.getSlope

--- Get the slope of a line
-- @function line.getSlope
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical
function line.getSlope( x1, y1, x2, y2 )
	err( 'line.getSlope: arg 1: expected a number, got %type%', x1, 'number' )
	err( 'line.getSlope: arg 2: expected a number, got %type%', y1, 'number' )
	err( 'line.getSlope: arg 3: expected a number, got %type%', x2, 'number' )
	err( 'line.getSlope: arg 4: expected a number, got %type%', y2, 'number' )
	return turbo.line.getSlope( x1, y1, x2, y2 )
end
-- }}}
-- {{{ line.getPerpendicularSlope

--- Get the perpendicular slope of a line given slope
-- @function line.getPerpendicularSlope
-- @tparam number|boolean m The slope of the line (`false` if the line is vertical)
-- @treturn number|booean pm The perpendicular slope (`false` if the new slope is vertical)

--- Get the perpendicular slope of a line
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical
function line.getPerpendicularSlope( ... )
	local args = { ... }
	local slope
	if mlib.compatibilityMode then
		slope = args[1]
		err( 'line.getPerpendicularSlope: arg 1: in compatibility mode expected a number or boolean (false), got %type%, %1', slope, validateSlope )
		err( 'line.getPerpendicularSlope: in compatibility mode expected 1 arg, got %1', select( '#', ... ),
			function( len ) return len <= 1, len end
		)
	else
		if #args == 1 then
			slope = args[1]
			err( 'line.getPerpendicularSlope: arg 1: expected a number or boolean (false), got %type%, %1', slope, validateSlope )
		else
			err( 'line.getPerpendicularSlope: arg 1: expected a number with > 1 arg, got %type%, %1', args[1], validateNumber )
			err( 'line.getPerpendicularSlope: arg 2: expected a number, got %type%, %1', args[2], validateNumber )
			err( 'line.getPerpendicularSlope: arg 3: expected a number, got %type%, %1', args[3], validateNumber )
			err( 'line.getPerpendicularSlope: arg 4: expected a number, got %type%, %1', args[4], validateNumber )
			slope = mlib.line.getSlope( unpack( args ) )
		end
	end
	return turbo.line.getPerpendicularSlope( slope )
end
-- }}}
-- {{{ line.getIntercept

--- Get the y-intercept of a line given slope, x, and y
-- @function line.getIntercept
-- @tparam number|boolean m The slope of the line
-- @tparam number x An x-coordinate on the line
-- @tparam number y An y-coordinate on the line
-- @treturn number|boolean b The y-intercept (`false` if the line is vertical)

--- Get the y-intercept of a line
-- @function line.getIntercept
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number b The y-intercept of the line
function line.getIntercept( ... )
	local args = { ... }
	local m, x, y
	if mlib.compatibilityMode then
		m, x, y = unpack( args )
		err( 'line.getIntercept: arg 1: in compatibility mode expected a number or boolean (false), got %type%, %1', m, validateSlope )
		err( 'line.getIntercept: arg 2: in compatibility mode expected a number, got %type%, %1', x, validateNumber )
		err( 'line.getIntercept: arg 3: in compatibility mode expected a number, got %type%, %1', y, validateNumber )
	else
		if #args == 3 then
			m, x, y = unpack( args )
			err( 'line.getIntercept: arg 1: expected a number or boolean (false), got %type%, %1', m, validateSlope )
			err( 'line.getIntercept: arg 2: expected a number, got %type%, %1', x, validateNumber )
			err( 'line.getIntercept: arg 3: expected a number, got %type%, %1', y, validateNumber )
		else
			err( 'line.getIntercept: arg 1: expected a number with > 3 arg, got %type%, %1', args[1], validateNumber )
			err( 'line.getIntercept: arg 2: expected a number, got %type%, %1', args[2], validateNumber )
			err( 'line.getIntercept: arg 3: expected a number, got %type%, %1', args[3], validateNumber )
			err( 'line.getIntercept: arg 4: expected a number, got %type%, %1', args[4], validateNumber )
			m = mlib.line.getSlope( unpack( args ) )
			x, y = unpack( args )
		end
	end
	return turbo.line.getIntercept( m, x, y )
end
-- }}}
-- {{{ line.getLineIntersection

--- Get the intersection of two lines in the form of `{ slope, x1, y1 }`
-- @function line.getLineIntersection
-- @tparam table line1 A line in the form `{ slope, x1, y1 }`
-- @tparam table line2 Another line in the same form
-- @treturn[1] number x The x-coordinate of the intersection
-- @treturn[1] number y The y-coordinate of the intersection
-- @treturn[2] boolean intersects `true`/`false` if the lines do/don't intersect (vertical/horizontal)

--- Get the intersection of two lines in the forms of `{ x1, y1, x2, y2 }` or `{ slope, x, y }`
-- @function line.getLineIntersection
-- @tparam table line1 The first line, in any either form
-- @tparam table line2 The second line, in any either form
function line.getLineIntersection( line1, line2 )
	err( 'line.getLineIntersection: arg 1: expected a table, got %type%', line1, 'table' )
	err( 'line.getLineIntersection: arg 2: expected a table, got %type%', line2, 'table' )
	local m1, x1, y1, m2, x2, y2
	if mlib.compatibilityMode then
		m1, x1, y1 = unpack( line1 )
		m2, x2, y2 = unpack( line2 )
		-- line 1
		err( 'line.getLineIntersection: arg 1: in compatibility mode expected [1] to be a number or boolean (false), got %type%, %1', m1, validateSlope )
		err( 'line.getLineIntersection: arg 1: in compatibility mode expected [2] to be a number, got %type%, %1', x1, validateNumber )
		err( 'line.getLineIntersection: arg 1: in compatibility mode expected [3] to be a number, got %type%, %1', y1, validateNumber )
		-- line 2
		err( 'line.getLineIntersection: arg 2: in compatibility mode expected [1] to be a number or boolean (false), got %type%, %1', m2, validateSlope )
		err( 'line.getLineIntersection: arg 2: in compatibility mode expected [2] to be a number, got %type%, %1', x2, validateNumber )
		err( 'line.getLineIntersection: arg 2: in compatibility mode expected [3] to be a number, got %type%, %1', y2, validateNumber )
	else
		-- line 1
		if #line1 == 3 then
			m1, x1, y1 = unpack( line1 )
			err( 'line.getLineIntersection: arg 1: expected [1] to be a number or boolean (false), got %type%, %1', m1, validateSlope )
			err( 'line.getLineIntersection: arg 1: expected [2] to be a number, got %type%, %1', x1, validateNumber )
			err( 'line.getLineIntersection: arg 1: expected [3] to be a number, got %type%, %1', y1, validateNumber )
		else
			err( 'line.getLineIntersection: arg 1: expected [1] to be a number with # > 3, got %type%, %1', line1[1], validateNumber )
			err( 'line.getLineIntersection: arg 1: expected [2] to be a number, got %type%, %1', line1[2], validateNumber )
			err( 'line.getLineIntersection: arg 1: expected [3] to be a number, got %type%, %1', line1[3], validateNumber )
			err( 'line.getLineIntersection: arg 1: expected [4] to be a number, got %type%, %1', line1[4], validateNumber )
			m1 = mlib.line.getSlope( unpack( line1 ) )
			x1, y1 = unpack( line1 )
		end
		-- line 2
		if #line2 == 3 then
			m2, x2, y2 = unpack( line2 )
			err( 'line.getLineIntersection: arg 2: expected [1] to be a number or boolean (false), got %type%, %1', m2, validateSlope )
			err( 'line.getLineIntersection: arg 2: expected [2] to be a number, got %type%, %1', x2, validateNumber )
			err( 'line.getLineIntersection: arg 2: expected [3] to be a number, got %type%, %1', y2, validateNumber )
		else
			err( 'line.getLineIntersection: arg 2: expected [1] to be a number with # > 3, got %type%, %1', line2[1], validateNumber )
			err( 'line.getLineIntersection: arg 2: expected [2] to be a number, got %type%, %1', line2[2], validateNumber )
			err( 'line.getLineIntersection: arg 2: expected [3] to be a number, got %type%, %1', line2[3], validateNumber )
			err( 'line.getLineIntersection: arg 2: expected [4] to be a number, got %type%, %1', line2[4], validateNumber )
			m2 = mlib.line.getSlope( unpack( line2 ) )
			x2, y2 = unpack( line2 )
		end
	end
	return turbo.line.getLineIntersection( { m1, x1, y1 }, { m2, x2, y2 } )
end
-- }}}
-- {{{ line.getClosestPoint

--- Get the point on a line closest to a given point
-- @function line.getClosestPoint
-- @tparam number m The slope of the line
-- @tparam number b The y-intercept of the line
-- @tparam number x An x-coordinate on the line (needed for vertical lines)
-- @tparam number y A y-coordinate on the line
-- @tparam number px The x-coordinate of the point to which the closest point on the line should lie
-- @tparam number py The y-coordiate of the point to which the closest point on the line should lie
-- @treturn number cx The x-coordinate of the closest point to `( px, py )` which lies on the line
-- @treturn number cy The y-coordinate of the closest point to `( px, py )` which lies on the line

--- Get the point on a line closest to a given point
-- @function line.getClosestPoint
-- @tparam table points A table of points, given in the form `{ x1, y1, x2, y2 }`
-- @tparam px number The x-coordinate of the point to which the closest point on the line should lie
-- @tparam py number The y-coordinate of the point to which the closest point on the line should lie
function line.getClosestPoint( ... )
	local m, b, x, y, px, py
	if mlib.compatibilityMode then
		m, b, x, y, px, py = ...
		err( 'line.getClosestPoint: arg 1: in compatibility mode expected a number or boolean, got %type%', m, 'number', 'boolean' )
		err( 'line.getClosestPoint: arg 2: in compatibility mode expected a number or boolean, got %type%', b, 'number', 'boolean' )
		err( 'line.getClosestPoint: arg 3: in compatibility mode expected a number, got %type%', x, 'number' )
		err( 'line.getClosestPoint: arg 4: in compatibility mode expected a number, got %type%', y, 'number' )
		err( 'line.getClosestPoint: arg 5: in compatibility mode expected a number, got %type%', px, 'number' )
		err( 'line.getClosestPoint: arg 6: in compatibility mode expected a number, got %type%', py, 'number' )
	else
		local args = { ... }
		if #args == 3 then
			err( 'line.getClosestPoint: arg 1: expected a table for 3 args, got %type%', args[1], 'table' )
			err( 'line.getClosestPoint: arg 1: expected [1] to be a number, got %type%, %1', args[1][1], validateNumber )
			err( 'line.getClosestPoint: arg 1: expected [2] to be a number, got %type%, %1', args[1][2], validateNumber )
			err( 'line.getClosestPoint: arg 1: expected [3] to be a number, got %type%, %1', args[1][3], validateNumber )
			err( 'line.getClosestPoint: arg 1: expected [4] to be a number, got %type%, %1', args[1][4], validateNumber )
			m = mlib.line.getSlope( unpack( args[1] ) )
			b = mlib.line.getSlope( unpack( args[1] ) )
			x, y = unpack( args[1] )
			px, py = args[2], args[3]
			err( 'line.getClosestPoint: arg 2: expected a number, got %type%', px, validateNumber )
			err( 'line.getClosestPoint: arg 3: expected a number, got %type%', py, validateNumber )
		else
			m, b, x, y, px, py = unpack( args )
			err( 'line.getClosestPoint: arg 1: expected a number or boolean with > 3 arg, got %type%', m, validateSlope )
			-- Can use validate slope for y-intercept, as it follows same formats
			err( 'line.getClosestPoint: arg 2: expected a number or boolean with > 3 arg, got %type%', b, validateSlope )
			err( 'line.getClosestPoint: arg 3: expected a number, got %type%', x, 'number' )
			err( 'line.getClosestPoint: arg 4: expected a number, got %type%', y, 'number' )
			err( 'line.getClosestPoint: arg 5: expected a number, got %type%', px, 'number' )
			err( 'line.getClosestPoint: arg 6: expected a number, got %type%', py, 'number' )
		end
	end
	return turbo.line.getClosestPoint( m, b, x, y, px, py )
end
-- }}}
mlib.line = line
-- @section end
-- }}}
-- {{{ mlib.segment

--- mlib.segment
-- - segment functions
-- @section milb.segment
local segment = {}
-- {{{ segment.getMidpoint

--- Get the midpoint between two points
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint
function segment.getMidpoint( x1, y1, x2, y2 )
	err( 'segment.getMidpoint: arg 1: expected a number, got %type%', x1, 'number' )
	err( 'segment.getMidpoint: arg 2: expected a number, got %type%', y1, 'number' )
	err( 'segment.getMidpoint: arg 3: expected a number, got %type%', x2, 'number' )
	err( 'segment.getMidpoint: arg 4: expected a number, got %type%', y2, 'number' )
	return turbo.segment.getMidpoint( x1, y1, x2, y2 )
end
-- }}}
-- {{{ segment.getLength

--- Get the distance between two points
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number d the length of the segment
function segment.getLength( x1, y1, x2, y2 )
	err( 'segment.getLength: arg 1: expected a number, got %type%', x1, 'number' )
	err( 'segment.getLength: arg 2: expected a number, got %type%', y1, 'number' )
	err( 'segment.getLength: arg 3: expected a number, got %type%', x2, 'number' )
	err( 'segment.getLength: arg 4: expected a number, got %type%', y2, 'number' )
	return turbo.segment.getLength( x1, y1, x2, y2 )
end
-- }}}
mlib.segment = segment
-- @section end
-- }}}

return mlib
