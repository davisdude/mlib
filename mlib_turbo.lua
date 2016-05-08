--- A speedier math and collisions library with no error checking and less flexible syntax
--- @module mlib_turbo
--- @author Davis Claiborne
--- @copyright 2016
--- @license MIT

-- {{{ General Functions
local unpack = unpack or table.unpack

local function validateNumber( n )
	if type( n ) ~= 'number' then return false
	elseif n ~= n then return false -- nan
	elseif math.abs( n ) == math.huge then return false
	else return true end
end

local function checkFuzzy( x, y, delta )
	return math.abs( x - y ) <= ( delta or .00001 )
end
-- }}}
-- {{{ turbo.line

--- turbo.line
-- - line functions
-- @section turbo.line

--- Get the slope of a line
-- @function turbo.line.getSlope
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number|boolean m The slope of the line (`false` if the line is vertical)
local function lineGetSlope( x1, y1, x2, y2 )
	if checkFuzzy( x1, x2 ) then return false
	else return ( y1 - y2 ) / ( x1 - x2 ) end
end

--- Get the perpendicular slope of a line
-- @function turbo.line.getPerpendicularSlope
-- @tparam number|boolean m The slope of the line (`false` if the line is vertical)
-- @treturn number|booean pm The perpendicular slope (`false` if the new slope is vertical)
local function lineGetPerpendicularSlope( m )
	if not m then return 0
	elseif checkFuzzy( m, 0 ) then return false
	else return -1 / m end
end

--- Get the y-intercept of a line
-- @function turbo.line.getIntercept
-- @tparam number|boolean m slope
-- @tparam number x
-- @tparam number y
-- @treturn number|boolean b The y-intercept (`false` if the line is vertical)
local function lineGetIntercept( m, x, y )
	if not m then return false
	else return y - m * x end
end

--- Get the intersection of two lines
-- @function turbo.line.getLineIntersection
-- @tparam table line1 A line in the form { slope, b }
-- @tparam table line2 Another line in the same form
-- @treturn boolean|number x The x-coordinate of the intersection (`false` if they don't intersect)
-- @terturn number y The y-coordinate of the intersection
local function lineGetLineIntersection( line1, line2 )
	local m1, b1 = unpack( line1 )
	local m2, b2 = unpack( line2 )
	local x = ( b1 - b2 ) / ( m2 - m1 )
	local y = m1 * x + b1
	return x, y
end
-- @section end
-- }}}
-- {{{ turbo.segment

--- turbo.segment
-- - segment functions
-- @section turbo.segment

--- Get the midpoint between two points
-- @function turbo.segment.getMidpoint
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number mx
-- @treturn number my
local function segmentGetMidpoint( x1, y1, x2, y2 )
	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

--- Get the distance between two points
-- @function turbo.segment.getLength
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number d
local function segmentGetLength( x1, y1, x2, y2 )
	return ( ( x1 - x2 ) ^ 2 + ( y1 - y2 ) ^ 2 ) ^ .5
end
-- }}}

return {
	line = {
		getSlope = lineGetSlope,
		getPerpendicularSlope = lineGetPerpendicularSlope,
		getIntercept = lineGetIntercept,
		getLineIntersection = lineGetLineIntersection,
	},
	segment = {
		getMidpoint = segmentGetMidpoint,
		getLength = segmentGetLength,
	}
}
