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
local _compatibilityModeString = 'in compatibility mode '

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
mlib.line = {}
-- {{{ line.getSlope

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
-- @tparam table points The points of the line in the form `{ x1, y1, x2, y2 }`
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical
function mlib.line.getSlope( ... )
	local condition1, condition2, x1, y1, x2, y2 = '', ''

	if mlib.compatibilityMode then
		x1, y1, x2, y2 = ...
		condition1 = 'arg '
		condition2 = ': ' .. _compatibilityModeString .. 'expected '
	else
		if select( '#', ... ) <= 1 then
			local points = select( 1, ... )
			err( 'line.getSlope: arg 1: with <= 1 arg expected a table, got %type%', points, 'table' )
			x1, y1, x2, y2 = unpack( points )
			condition1 = 'arg 1: with <= 1 arg expected ['
			condition2 = '] to be '
		else
			x1, y1, x2, y2 = ...
			condition1 = 'arg '
			condition2 = ': with > 1 arg expected '
		end
	end

	err( 'line.getSlope: ' .. condition1 .. '1' .. condition2 .. 'a number, got %type%, %1', x1, validateNumber )
	err( 'line.getSlope: ' .. condition1 .. '2' .. condition2 .. 'a number, got %type%, %1', y1, validateNumber )
	err( 'line.getSlope: ' .. condition1 .. '3' .. condition2 .. 'a number, got %type%, %1', x2, validateNumber )
	err( 'line.getSlope: ' .. condition1 .. '4' .. condition2 .. 'a number, got %type%, %1', y2, validateNumber )

	return turbo.line.getSlope( x1, y1, x2, y2 )
end
-- }}}
-- {{{ line.getPerpendicularSlope

--- Get the perpendicular slope of a line given slope
-- @function line.getPerpendicularSlope
-- @tparam number|boolean m The slope of the line (`false` if the line is vertical)
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical

--- Get the perpendicular slope of a line
-- @function line.getPerpendicularSlope
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn[1] number The slope of the line
-- @treturn[2] boolean `false` if the line is vertical
function mlib.line.getPerpendicularSlope( ... )
	local condition, slope = ''

	if mlib.compatibilityMode then
		slope = ...
		condition = _compatibilityModeString
		err( 'line.getPerpendicularSlope: in compatibility mode expected 1 arg, got %1', select( '#', ... ),
			function( len ) return len <= 1, len end
		)
	else
		local args = { ... }
		if #args <= 1 then
			slope = args[1]
			condition = 'with <= 1 arg '
		else
			err( 'line.getPerpendicularSlope: arg 1: with > 1 arg expected a number, got %type%, %1', args[1], validateNumber )
			err( 'line.getPerpendicularSlope: arg 2: with > 1 arg expected a number, got %type%, %1', args[2], validateNumber )
			err( 'line.getPerpendicularSlope: arg 3: with > 1 arg expected a number, got %type%, %1', args[3], validateNumber )
			err( 'line.getPerpendicularSlope: arg 4: with > 1 arg expected a number, got %type%, %1', args[4], validateNumber )
			slope = mlib.line.getSlope( unpack( args ) )
		end
	end

	err( 'line.getPerpendicularSlope: arg 1: ' .. condition .. 'expected a number or boolean (false), got %type%, %1', slope, validateSlope )

	return turbo.line.getPerpendicularSlope( slope )
end
-- }}}
-- {{{ line.getIntercept

--- Get the y-intercept of a line given slope, x, and y
-- @function line.getIntercept
-- @tparam number|boolean m The slope of the line
-- @tparam number x An x-coordinate on the line
-- @tparam number y A y-coordinate on the line
-- @treturn number|boolean b The y-intercept (`false` if the line is vertical)

--- Get the y-intercept of a line
-- @function line.getIntercept
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number|boolean b The y-intercept (`false` if the line is vertical)
function mlib.line.getIntercept( ... )
	local args = { ... }
	local condition, m, x, y = ''

	if mlib.compatibilityMode then
		m, x, y = unpack( args )
		condition = _compatibilityModeString
	else
		if #args == 3 then
			m, x, y = unpack( args )
			condition = 'with 3 args '
		else
			err( 'line.getIntercept: arg 1: with > 3 args expected a number, got %type%, %1', args[1], validateNumber )
			err( 'line.getIntercept: arg 2: with > 3 args expected a number, got %type%, %1', args[2], validateNumber )
			err( 'line.getIntercept: arg 3: with > 3 args expected a number, got %type%, %1', args[3], validateNumber )
			err( 'line.getIntercept: arg 4: with > 3 args expected a number, got %type%, %1', args[4], validateNumber )
			m = mlib.line.getSlope( unpack( args ) )
			x, y = unpack( args )
		end
	end

	err( 'line.getIntercept: arg 1: ' .. condition .. 'expected a number or boolean (false), got %type%, %1', m, validateSlope )
	err( 'line.getIntercept: arg 2: ' .. condition .. 'expected a number, got %type%, %1', x, validateNumber )
	err( 'line.getIntercept: arg 3: ' .. condition .. 'expected a number, got %type%, %1', y, validateNumber )

	return turbo.line.getIntercept( m, x, y )
end
-- }}}
-- {{{ line.getLineIntersection

--- Get the intersection of two lines in the form of `{ slope, x1, y1 }`
-- @function mlib.line.getLineIntersection
-- @tparam table line1 A line in the form `{ slope, x1, y1 }`
-- @tparam table line2 Another line in the same form
-- @treturn[1] number x The x-coordinate of the intersection
-- @treturn[1] number y The y-coordinate of the intersection
-- @treturn[2] boolean intersects `true`/`false` if the lines do/don't intersect (vertical/horizontal)

--- Get the intersection of two lines in the forms of `{ x1, y1, x2, y2 }` or `{ slope, x, y }`
-- @function mlib.line.getLineIntersection
-- @tparam table line1 The first line, in any either form
-- @tparam table line2 The second line, in any either form
-- @treturn[1] number x The x-coordinate of the intersection
-- @treturn[1] number y The y-coordinate of the intersection
-- @treturn[2] boolean intersects `true`/`false` if the lines do/don't intersect (vertical/horizontal)
function mlib.line.getLineIntersection( line1, line2 )
	err( 'line.getLineIntersection: arg 1: expected a table, got %type%', line1, 'table' )
	err( 'line.getLineIntersection: arg 2: expected a table, got %type%', line2, 'table' )
	local condition, m1, x1, y1, m2, x2, y2 = ''

	if mlib.compatibilityMode then
		m1, x1, y1 = unpack( line1 )
		m2, x2, y2 = unpack( line2 )
		condition = _compatibilityModeString
	else
		-- line 1
		if #line1 <= 3 then
			m1, x1, y1 = unpack( line1 )
		else
			err( 'line.getLineIntersection: arg 1: with # > 3 expected [1] to be a number, got %type%, %1', line1[1], validateNumber )
			err( 'line.getLineIntersection: arg 1: with # > 3 expected [2] to be a number, got %type%, %1', line1[2], validateNumber )
			err( 'line.getLineIntersection: arg 1: with # > 3 expected [3] to be a number, got %type%, %1', line1[3], validateNumber )
			err( 'line.getLineIntersection: arg 1: with # > 3 expected [4] to be a number, got %type%, %1', line1[4], validateNumber )
			m1 = mlib.line.getSlope( unpack( line1 ) )
			x1, y1 = unpack( line1 )
		end
		-- line 2
		if #line2 <= 3 then
			m2, x2, y2 = unpack( line2 )
		else
			err( 'line.getLineIntersection: arg 2: with # > 3 expected [1] to be a number with # > 3, got %type%, %1', line2[1], validateNumber )
			err( 'line.getLineIntersection: arg 2: with # > 3 expected [2] to be a number, got %type%, %1', line2[2], validateNumber )
			err( 'line.getLineIntersection: arg 2: with # > 3 expected [3] to be a number, got %type%, %1', line2[3], validateNumber )
			err( 'line.getLineIntersection: arg 2: with # > 3 expected [4] to be a number, got %type%, %1', line2[4], validateNumber )
			m2 = mlib.line.getSlope( unpack( line2 ) )
			x2, y2 = unpack( line2 )
		end
	end

	-- line 1
	err( 'line.getLineIntersection: arg 1: ' .. condition .. 'expected [1] to be a number or boolean (false), got %type%, %1', m1, validateSlope )
	err( 'line.getLineIntersection: arg 1: ' .. condition .. 'expected [2] to be a number, got %type%, %1', x1, validateNumber )
	err( 'line.getLineIntersection: arg 1: ' .. condition .. 'expected [3] to be a number, got %type%, %1', y1, validateNumber )
	-- line 2
	err( 'line.getLineIntersection: arg 2: ' .. condition .. 'expected [1] to be a number or boolean (false), got %type%, %1', m2, validateSlope )
	err( 'line.getLineIntersection: arg 2: ' .. condition .. 'expected [2] to be a number, got %type%, %1', x2, validateNumber )
	err( 'line.getLineIntersection: arg 2: ' .. condition .. 'expected [3] to be a number, got %type%, %1', y2, validateNumber )

	return turbo.line.getLineIntersection( { m1, x1, y1 }, { m2, x2, y2 } )
end
-- }}}
-- {{{ line.getClosestPoint

--- Get the point on a line closest to a given point
-- @function mlib.line.getClosestPoint
-- @tparam number px The x-coordinate of the point to which the closest point on the line should lie
-- @tparam number py The y-coordiate of the point to which the closest point on the line should lie
-- @tparam number m The slope of the line
-- @tparam number x An x-coordinate on the line (needed for vertical lines)
-- @tparam number y A y-coordinate on the line
-- @treturn number cx The x-coordinate of the closest point to `( px, py )` which lies on the line
-- @treturn number cy The y-coordinate of the closest point to `( px, py )` which lies on the line

--- Get the point on a line closest to a given point
-- @function mlib.line.getClosestPoint
-- @tparam px number The x-coordinate of the point to which the closest point on the line should lie
-- @tparam py number The y-coordinate of the point to which the closest point on the line should lie
-- @tparam table points A table of points, given in the form `{ x1, y1, x2, y2 }`
-- @treturn number cx The x-coordinate of the closest point to `( px, py )` which lies on the line
-- @treturn number cy The y-coordinate of the closest point to `( px, py )` which lies on the line
function mlib.line.getClosestPoint( px, py, ... )
	local condition, m, x, y = ''
	err( 'line.getClosestPoint: arg 1: expected a number, got %type%, %1', px, validateNumber )
	err( 'line.getClosestPoint: arg 2: expected a number, got %type%, %1', py, validateNumber)

	if mlib.compatibilityMode then
		m, x, y = ...
		condition = _compatibilityModeString
	else
		local args = { ... }
		if #args <= 1 then
			condition = 'with <= 3 args '
			err( 'line.getClosestPoint: arg 3: ' .. condition .. 'expected a table, got %type%', args[1], 'table' )
			err( 'line.getClosestPoint: arg 3: ' .. condition .. 'expected [1] to be a number, got %type%, %1', args[1][1], validateNumber )
			err( 'line.getClosestPoint: arg 3: ' .. condition .. 'expected [2] to be a number, got %type%, %1', args[1][2], validateNumber )
			err( 'line.getClosestPoint: arg 3: ' .. condition .. 'expected [3] to be a number, got %type%, %1', args[1][3], validateNumber )
			err( 'line.getClosestPoint: arg 3: ' .. condition .. 'expected [4] to be a number, got %type%, %1', args[1][4], validateNumber )
			m = mlib.line.getSlope( unpack( args[1] ) )
			x, y = unpack( args[1] )
		else
			m, x, y = unpack( args )
			condition = 'with > 3 args '
		end
	end

	err( 'line.getClosestPoint: arg 3: ' .. condition .. 'expected a number or boolean, got %type%, %1', m, validateSlope )
	err( 'line.getClosestPoint: arg 4: ' .. condition .. 'expected a number, got %type%, %1', x, validateNumber )
	err( 'line.getClosestPoint: arg 5: ' .. condition .. 'expected a number, got %type%, %1', y, validateNumber )

	return turbo.line.getClosestPoint( px, py, m, x, y )
end
-- }}}
-- {{{ line.checkPoint

--- Check if a point lies on a line
-- @function mlib.line.checkPoint
-- @tparam number px The x-coordinate of the point to check
-- @tparam number py The y-coordinate of the point to check
-- @tparam number|boolean m The slope of the line
-- @tparam number x An x-coordinate on the line
-- @tparam number y A y-coordinate on the line
-- @treturn boolean onLine Whether the point is on the line or not

--- Check if a point lies on a line
-- @function mlib.line.checkPoint
-- @tparam number px The x-coordinate of the point to check
-- @tparam number py The y-coordinate of the point to check
-- @tparam table line The line in the form `{ x1, y1, x2, y2 }`
-- @treturn boolean onLine Whether the point is on the line or not
function mlib.line.checkPoint( px, py, ... )
	err( 'line.checkPoint: arg 1: expected a number, got %type%, %1', px, validateNumber )
	err( 'line.checkPoint: arg 2: expected a number, got %type%, %1', py, validateNumber )
	local condition, m, x, y = ''

	if mlib.compatibilityMode then
		m, x, y = ...
		condition = _compatibilityModeString
	else
		local args = { ... }
		if #args <= 1 then
			args = args[1]
			err( 'line.checkPoint: arg 3: with 3 args expected a table, got %type%', args, 'table' )
			err( 'line.checkPoint: arg 3: with 3 args expected [1] to be a number, got %type%, %1', args[1], validateNumber )
			err( 'line.checkPoint: arg 3: with 3 args expected [2] to be a number, got %type%, %1', args[2], validateNumber )
			err( 'line.checkPoint: arg 3: with 3 args expected [3] to be a number, got %type%, %1', args[3], validateNumber )
			err( 'line.checkPoint: arg 3: with 3 args expected [4] to be a number, got %type%, %1', args[4], validateNumber )
			m = mlib.line.getSlope( unpack( args ) )
			x, y = unpack( args )
		else
			m, x, y = unpack( args )
			condition = 'with > 3 args '
		end
	end

	err( 'line.checkPoint: arg 3: ' .. condition .. 'expected a number or boolean, got %type%, %1', m, validateSlope )
	err( 'line.checkPoint: arg 4: ' .. condition .. 'expected a number, got %type%, %1', x, validateNumber )
	err( 'line.checkPoint: arg 5: ' .. condition .. 'expected a number, got %type%, %1', y, validateNumber )

	return turbo.line.checkPoint( px, py, m, x, y )
end
-- }}}
-- }}}
-- {{{ mlib.segment

--- mlib.segment
-- - segment functions
-- @section milb.segment
mlib.segment = {}
-- {{{ segment.getMidpoint

--- Get the midpoint between two points
-- @function mlib.segment.getMidpoint
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint

--- Get the midpoint between two points
-- @function mlib.segment.getMidpoint
-- @tparam table points The points of the line in the form `{ x1, y1, x2, y2 }`
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint
function mlib.segment.getMidpoint( ... )
	local condition1, condition2, x1, y1, x2, y2 = '', ''

	if mlib.compatibilityMode then
		x1, y1, x2, y2 = ...
		condition1 = 'arg '
		condition2 = ': ' .. _compatibilityModeString .. 'expected '
	else
		if select( '#', ... ) <= 1 then
			local points = select( 1, ... )
			err( 'segment.getMidpoint: arg 1: with <= 1 arg expected a table, got %type%', points, 'table' )
			x1, y1, x2, y2 = unpack( points )
			condition1 = 'arg 1: with <= 1 arg expected ['
			condition2 = '] to be '
		else
			x1, y1, x2, y2 = ...
			condition1 = 'arg '
			condition2 = ': with > 1 arg expected '
		end
	end

	err( 'segment.getMidpoint: ' .. condition1 .. '1' .. condition2 .. 'a number, got %type%, %1', x1, validateNumber )
	err( 'segment.getMidpoint: ' .. condition1 .. '2' .. condition2 .. 'a number, got %type%, %1', y1, validateNumber )
	err( 'segment.getMidpoint: ' .. condition1 .. '3' .. condition2 .. 'a number, got %type%, %1', x2, validateNumber )
	err( 'segment.getMidpoint: ' .. condition1 .. '4' .. condition2 .. 'a number, got %type%, %1', y2, validateNumber )

	return turbo.segment.getMidpoint( x1, y1, x2, y2 )
end
-- }}}
-- {{{ segment.getLength

--- Get the midpoint between two points
-- @function mlib.segment.getLength
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint

--- Get the midpoint between two points
-- @function mlib.segment.getLength
-- @tparam table points The points of the line in the form `{ x1, y1, x2, y2 }`
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint
function mlib.segment.getLength( ... )
	local condition1, condition2, x1, y1, x2, y2 = '', ''

	if mlib.compatibilityMode then
		x1, y1, x2, y2 = ...
		condition1 = 'arg '
		condition2 = ': ' .. _compatibilityModeString .. 'expected '
	else
		if select( '#', ... ) <= 1 then
			local points = select( 1, ... )
			err( 'segment.getLength: arg 1: with <= 1 arg expected a table, got %type%', points, 'table' )
			x1, y1, x2, y2 = unpack( points )
			condition1 = 'arg 1: with <= 1 arg expected ['
			condition2 = '] to be '
		else
			x1, y1, x2, y2 = ...
			condition1 = 'arg '
			condition2 = ': with > 1 arg expected '
		end
	end

	err( 'segment.getLength: ' .. condition1 .. '1' .. condition2 .. 'a number, got %type%, %1', x1, validateNumber )
	err( 'segment.getLength: ' .. condition1 .. '2' .. condition2 .. 'a number, got %type%, %1', y1, validateNumber )
	err( 'segment.getLength: ' .. condition1 .. '3' .. condition2 .. 'a number, got %type%, %1', x2, validateNumber )
	err( 'segment.getLength: ' .. condition1 .. '4' .. condition2 .. 'a number, got %type%, %1', y2, validateNumber )

	return turbo.segment.getLength( x1, y1, x2, y2 )
end
-- }}}
-- {{{ segment.getLength2

--- Get the midpoint between two points
-- @function mlib.segment.getLength2
-- @tparam number x1 The x-coordinate of the first point
-- @tparam number y1 The y-coordinate of the first point
-- @tparam number x2 The x-coordinate of the second point
-- @tparam number y2 The y-coordinate of the second point
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint

--- Get the midpoint between two points
-- @function mlib.segment.getLength2
-- @tparam table points The points of the line in the form `{ x1, y1, x2, y2 }`
-- @treturn number mx The x-coordinate of the midpoint
-- @treturn number my The y-coordinate of the midpoint
function mlib.segment.getLength2( ... )
	local condition1, condition2, x1, y1, x2, y2 = '', ''

	if mlib.compatibilityMode then
		x1, y1, x2, y2 = ...
		condition1 = 'arg '
		condition2 = ': ' .. _compatibilityModeString .. 'expected '
	else
		if select( '#', ... ) <= 1 then
			local points = select( 1, ... )
			err( 'segment.getLength2: arg 1: with <= 1 arg expected a table, got %type%', points, 'table' )
			x1, y1, x2, y2 = unpack( points )
			condition1 = 'arg 1: with <= 1 arg expected ['
			condition2 = '] to be '
		else
			x1, y1, x2, y2 = ...
			condition1 = 'arg '
			condition2 = ': with > 1 arg expected '
		end
	end

	err( 'segment.getLength2: ' .. condition1 .. '1' .. condition2 .. 'a number, got %type%, %1', x1, validateNumber )
	err( 'segment.getLength2: ' .. condition1 .. '2' .. condition2 .. 'a number, got %type%, %1', y1, validateNumber )
	err( 'segment.getLength2: ' .. condition1 .. '3' .. condition2 .. 'a number, got %type%, %1', x2, validateNumber )
	err( 'segment.getLength2: ' .. condition1 .. '4' .. condition2 .. 'a number, got %type%, %1', y2, validateNumber )

	return turbo.segment.getLength2( x1, y1, x2, y2 )
end
-- }}}
-- {{{ segment.checkPoint

--- Check if a point lies on a line
-- @function mlib.segment.checkPoint
-- @tparam number px The x-coordinate of the point to check
-- @tparam number py The y-coordinate of the point to check
-- @tparam number x1 The x-coordinate of one of the endpoints of the line segment
-- @tparam number y1 The y-coordinate of one of the endpoints of the line segment
-- @tparam number x2 The x-coordinate of the other endpoint of the line segment
-- @tparam number y2 The y-coordinate of the other endpoint of the line segment
-- @treturn boolean onSegment Whether the point is on the line segment or not

--- Check if a point lies on a line
-- @function mlib.segment.checkPoint
-- @tparam number px The x-coordinate of the point to check
-- @tparam number py The y-coordinate of the point to check
-- @tparam table points The points of the line segment in the form of `{ x1, y1, x2, y2 }`
-- @treturn boolean onSegment Whether the point is on the line segment or not
function mlib.segment.checkPoint( px, py, ... )
	err( 'segment.checkPoint: arg 1: expected a number, got %type%, %1', px, validateNumber )
	err( 'segment.checkPoint: arg 2: expected a number, got %type%, %1', py, validateNumber )
	local condition1, condition2, i, x1, y1, x2, y2 = '', ''

	if mlib.compatibilityMode then
		x1, y1, x2, y2 = ...
		condition1 = 'arg '
		condition2 = ': ' .. _compatibilityModeString .. 'expected '
		i = 2
	else
		if select( '#', ... ) <= 1 then
			local points = select( 1, ... )
			err( 'segment.checkPoint: arg 3: with <= 3 args expected a table, got %type%', points, 'table' )
			x1, y1, x2, y2 = unpack( points )
			condition1 = 'arg 3: with <= 3 args expected ['
			condition2 = '] to be '
			i = 0
		else
			x1, y1, x2, y2 = ...
			condition1 = 'arg '
			condition2 = ': with > 3 args expected '
			i = 2
		end
	end

	err( 'segment.checkPoint: ' .. condition1 .. tostring( 1 + i ) .. condition2 .. 'a number, got %type%, %1', x1, validateNumber )
	err( 'segment.checkPoint: ' .. condition1 .. tostring( 2 + i ) .. condition2 .. 'a number, got %type%, %1', y1, validateNumber )
	err( 'segment.checkPoint: ' .. condition1 .. tostring( 3 + i ) .. condition2 .. 'a number, got %type%, %1', x2, validateNumber )
	err( 'segment.checkPoint: ' .. condition1 .. tostring( 4 + i ).. condition2 .. 'a number, got %type%, %1', y2, validateNumber )

	return turbo.segment.checkPoint( px, py, x1, y1, x2, y2 )
end
-- }}}
-- {{{ segment.getLineIntersection

--- Get the intersection of a line and a segment
-- @function segment.getLineIntersection
-- @tparam table line The line in the format of `{ m, x, y }`
-- @tparam table segment The segment in the form of `{ x1, y1, x2, y2 }`
-- @treturn[1] number x The x-coordinate of the intersection
-- @treturn[1] number y The y-coordinate of the intersection
-- @treturn[2] boolean intersects `false` if the line and segment don't intersect

--- Get the intersection of a line and a segment
-- @function segment.getLineIntersection
-- @tparam table line The line in the form of `{ x1, y1, x2, y2 }`
-- @tparam table segment The segment in the form of `{ x1, y1, x2, y2 }`
-- @treturn[1] number y The y-coordinate of the intersection
-- @treturn[2] boolean intersects `false` if the line and segment don't intersect
function mlib.segment.getLineIntersection( line, segment )
	err( 'segment.getLineIntersection: arg 1: expected a table, got %type%', line, 'table' )
	err( 'segment.getLineIntersection: arg 2: expected a table, got %type%', segment, 'table' )
	local condition, m, x, y, x1, y1, x2, y2 = ''

	if mlib.compatibilityMode then
		m, x, y = unpack( line )
		condition = _compatibilityModeString
	else
		if #line <= 3 then
			condition = 'with # <= 3 '
			m, x, y = unpack( line )
		else
			condition = 'with # > 3 '
			local x1, y1, x2, y2 = unpack( line )
			err( 'segment.getLineIntersection: arg 1: ' .. condition .. 'expected [1] to be a number, got %type%, %1', x1, validateNumber )
			err( 'segment.getLineIntersection: arg 1: ' .. condition .. 'expected [2] to be a number, got %type%, %1', y1, validateNumber )
			err( 'segment.getLineIntersection: arg 1: ' .. condition .. 'expected [3] to be a number, got %type%, %1', x2, validateNumber )
			err( 'segment.getLineIntersection: arg 1: ' .. condition .. 'expected [4] to be a number, got %type%, %1', y2, validateNumber )
			m = mlib.line.getSlope( x1, y1, x2, y2 )
			x, y = unpack( line )
		end
	end
	x1, y1, x2, y2 = unpack( segment )

	err( 'segment.getLineIntersection: arg 1: ' .. condition .. 'expected [1] to be a number or boolean (false), got %type%, %1', m, validateSlope )
	err( 'segment.getLineIntersection: arg 1: ' .. condition .. 'expected [2] to be a number, got %type%, %1', x, validateSlope )
	err( 'segment.getLineIntersection: arg 1: ' .. condition .. 'expected [3] to be a number, got %type%, %1', y, validateSlope )

	err( 'segment.getLineIntersection: arg 2: expected [1] to be a number, got %type%, %1', x1, validateNumber )
	err( 'segment.getLineIntersection: arg 2: expected [2] to be a number, got %type%, %1', y1, validateNumber )
	err( 'segment.getLineIntersection: arg 2: expected [3] to be a number, got %type%, %1', x2, validateNumber )
	err( 'segment.getLineIntersection: arg 2: expected [4] to be a number, got %type%, %1', y2, validateNumber )

	return turbo.segment.getLineIntersection( { m, x, y }, { x1, y1, x2, y2 } )
end
-- }}}
-- {{{ segment.getSegmentIntersection

--- Get the intersection between two segments
-- @function segment.getSegmentIntersection
-- @tparam table segment1 The first segment in the form `{ x1, y1, x2, y2 }`
-- @tparam table segment2 The second segment in the form `{ x1, y1, x2, y2 }`
-- @treturn[1] numbers intersections The table of intersections:
--
-- - `x, y`: one intersection
--
-- - `x1, y1, x2, y2`: colinear intersection (same slope/y-intercept and cross)
function mlib.segment.getSegmentIntersection( segment1, segment2 )
	err( 'segment.getSegmentIntersection: arg 1: expected a table, got %type%', segment1, 'table' )
	err( 'segment.getSegmentIntersection: arg 2: expected a table, got %type%', segment2, 'table' )
	err( 'segment.getSegmentIntersection: arg 1: expected [1] to be a number, got %type%, %1', segment1[1], validateNumber )
	err( 'segment.getSegmentIntersection: arg 1: expected [2] to be a number, got %type%, %1', segment1[2], validateNumber )
	err( 'segment.getSegmentIntersection: arg 1: expected [3] to be a number, got %type%, %1', segment1[3], validateNumber )
	err( 'segment.getSegmentIntersection: arg 1: expected [4] to be a number, got %type%, %1', segment1[4], validateNumber )
	err( 'segment.getSegmentIntersection: arg 2: expected [1] to be a number, got %type%, %1', segment2[1], validateNumber )
	err( 'segment.getSegmentIntersection: arg 2: expected [2] to be a number, got %type%, %1', segment2[2], validateNumber )
	err( 'segment.getSegmentIntersection: arg 2: expected [3] to be a number, got %type%, %1', segment2[3], validateNumber )
	err( 'segment.getSegmentIntersection: arg 2: expected [4] to be a number, got %type%, %1', segment2[4], validateNumber )
	return turbo.segment.getSegmentIntersection( segment1, segment2 )
end
-- }}}
-- {{{ segment.getClosestPoint

--- Get the closest point on a segment
-- @function segment.getClosestPoint
-- @tparam number px The point to which the closest point on the line should lie
-- @tparam number py
-- @tparam number x1 The x-coordinate of one of the endpoints of the line segment
-- @tparam number y1 The y-coordinate of one of the endpoints of the line segment
-- @tparam number x2 The x-coordinate of the other endpoint of the line segment
-- @tparam number y2 The y-coordinate of the other endpoint of the line segment
-- @treturn number cx The x-coordinate of the closest point to `( px, py )` which lies on the line
-- @treturn number cy The y-coordinate of the closest point to `( px, py )` which lies on the line 

--- Get the closest point on a segment
-- @function segment.getClosestPoint
-- @tparam number px The x-coordinate of the point to which the closest point on the line should lie
-- @tparam number py The y-coordinate of the point to which the closest point on the line should lie
-- @tparam table points The points of the line segment in the form of `{ x1, y1, x2, y2 }`
-- @treturn number cx The x-coordinate of the closest point to `( px, py )` which lies on the line
-- @treturn number cy The y-coordinate of the closest point to `( px, py )` which lies on the line 
function mlib.segment.getClosestPoint( px, py, ... )
	err( 'segment.getClosestPoint: arg 1: expected a number, got %type%, %1', px, validateNumber )
	err( 'segment.getClosestPoint: arg 2: expected a number, got %type%, %1', py, validateNumber )
	local condition1, condition2, i, x1, y1, x2, y2 = '', ''

	if mlib.compatibilityMode then
		x1, y1, x2, y2 = ...
		condition1 = 'arg '
		condition2 = ': ' .. _compatibilityModeString .. 'expected '
		i = 2
	else
		if select( '#', ... ) <= 1 then
			local points = select( 1, ... )
			err( 'segment.getClosestPoint: arg 3: with <= 3 args expected a table, got %type%', points, 'table' )
			x1, y1, x2, y2 = unpack( points )
			condition1 = 'arg 3: with <= 3 args expected ['
			condition2 = '] to be '
			i = 0
		else
			x1, y1, x2, y2 = ...
			condition1 = 'arg '
			condition2 = ': with > 3 args expected '
			i = 2
		end
	end

	err( 'segment.getClosestPoint: ' .. condition1 .. tostring( 1 + i ) ..  condition2 .. 'a number, got %type%, %1', x1, validateNumber )
	err( 'segment.getClosestPoint: ' .. condition1 .. tostring( 2 + i ) ..  condition2 .. 'a number, got %type%, %1', y1, validateNumber )
	err( 'segment.getClosestPoint: ' .. condition1 .. tostring( 3 + i ) ..  condition2 .. 'a number, got %type%, %1', x2, validateNumber )
	err( 'segment.getClosestPoint: ' .. condition1 .. tostring( 4 + i ) ..  condition2 .. 'a number, got %type%, %1', y2, validateNumber )

	return turbo.segment.getClosestPoint( px, py, x1, y1, x2, y2 )
end
-- }}}
-- }}}

return mlib
