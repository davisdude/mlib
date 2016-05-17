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
-- @function line.getSlope
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
-- @function line.getPerpendicularSlope
-- @tparam number|boolean m The slope of the line (`false` if the line is vertical)
-- @treturn number|booean pm The perpendicular slope (`false` if the new slope is vertical)
local function lineGetPerpendicularSlope( m )
	if not m then return 0
	elseif checkFuzzy( m, 0 ) then return false
	else return -1 / m end
end

--- Get the y-intercept of a line
-- @function line.getIntercept
-- @tparam number|boolean m slope
-- @tparam number x
-- @tparam number y
-- @treturn number|boolean b The y-intercept (`false` if the line is vertical)
local function lineGetIntercept( m, x, y )
	if not m then return false
	else return y - m * x end
end

--- Get the intersection of two lines
-- @function line.getLineIntersection
-- @tparam table line1 A line in the form { slope, x1, y1 }. x and y coordinates are required for handling vertical lines
-- @tparam table line2 Another line in the same form
-- @treturn[1] number x The x-coordinate of the intersection
-- @treturn[1] number y The y-coordinate of the intersection
-- @treturn[2] boolean intersects `false` if the lines don't intersect (vertical and horizontal lines)
local function lineGetLineIntersection( line1, line2 )
	local m1, x1, y1 = unpack( line1 )
	local m2, x2, y2 = unpack( line2 )
	local x, y
	local b1, b2 = lineGetIntercept( m1, x1, y1 ), lineGetIntercept( m2, x2, y2 )
	if type( m1 ) == 'number' and type( m2 ) == 'number' then
		if m1 == m2 then
			return b1 == b2
		end
		x = ( b1 - b2 ) / ( m2 - m1 )
		y = m1 * x + b1
	else
		local m, b
		if type( m1 ) == 'boolean' and type( m2 ) == 'number' then
			x = x1
			m, b = m2, b2
		elseif type( m1 ) == 'number' and type( m2 ) == 'boolean' then
			x = x2
			m, b = m1, b1
		else
			if x1 ~= x2 then return false
			else return true end
		end
		return x, m * x + b
	end
	return x, y
end

--- Get the point on a line closest to a given point
-- @function line.getClosestPoint
-- @tparam number px The point to which the closest point on the line should lie
-- @tparam number py
-- @tparam number m
-- @tparam number x
-- @tparam number y
-- @treturn number cx The closest point to `( px, py )` which lies on the line
-- @treturn number cy
local function lineGetClosestPoint( px, py, m, x, y )
	local pm = lineGetPerpendicularSlope( m )
	return lineGetLineIntersection( { pm, px, py }, { m, x, y } )
end

--- Check if a point lies on a line
-- @function line.checkPoint
-- @tparam number px The coordinates of the point to check
-- @tparam number py
-- @tparam number|boolean m
-- @tparam number x
-- @tparam number y
-- @treturn boolean onLine
local function lineCheckPoint( px, py, m, x, y )
	if m then
		local b = lineGetIntercept( m, x, y )
		return checkFuzzy( py, m * px + b )
	else
		return checkFuzzy( px, x )
	end
end
-- @section end
-- }}}
-- {{{ turbo.segment

--- turbo.segment
-- - segment functions
-- @section turbo.segment

--- Get the midpoint between two points
-- @function segment.getMidpoint
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
-- @function segment.getLength
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number d
local function segmentGetLength( x1, y1, x2, y2 )
	return ( ( x1 - x2 ) ^ 2 + ( y1 - y2 ) ^ 2 ) ^ .5
end

--- Get the squared length between two points
-- @function segment.getLength2
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number d
local function segmentGetLength2( x1, y1, x2, y2 )
	return ( x1 - x2 ) ^ 2 + ( y1 - y2 ) ^ 2
end

--- Check if a point lies on a segment
-- @function segment.checkPoint
-- @tparam number px The coordinates of the point to check
-- @tparam number py
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn boolean onSegment
local function segmentCheckPoint( px, py, x1, y1, x2, y2 )
	local d = segmentGetLength( x1, y1, x2, y2 )
	local d1 = segmentGetLength( x1, y1, px, py )
	local d2 = segmentGetLength( px, py, x2, y2 )
	return checkFuzzy( d, d1 + d2 )
end

--- Get the intersection of a line and a segment
-- @function segment.getLineIntersection
-- @tparam table line `{ m, x, y }`
-- @tparam table segment `{ x1, y1, x2, y2 }`
-- @treturn[1] number x The x-coordinate of the intersection
-- @treturn[1] number y The y-coordinate of the intersection
-- @treturn[2] boolean intersects `false` if the line and segment don't intersect
local function segmentGetLineIntersection( line, segment )
	local sm = lineGetSlope( unpack( segment ) )
	local x, y = lineGetLineIntersection( line, { sm, segment[1], segment[2] } )
	if not x then return false end
	if segmentCheckPoint( x, y, unpack( segment ) ) then return x, y
	else return false end
end

--- Get the intersection between two segments
-- @function segment.getSegmentIntersection
-- @tparam table segment1 `{ x1, y1, x2, y2 }`
-- @tparam table segment2
-- @treturn[1] numbers intersections The Intersections of the segments
--
-- - `x, y`: one intersection
--
-- - `x1, y1, x2, y2`: colinear intersection (same slope/y-intercept and cross)
--
-- __NOTE__ That these are *not* in tables.
--
-- @treturn[2] boolean intersects `false` if the segments don't intersect
local function segmentGetSegmentIntersection( segment1, segment2 )
	local x, y = lineGetLineIntersection(
		{ lineGetSlope( unpack( segment1 ) ), segment1[1], segment1[2] },
		{ lineGetSlope( unpack( segment2 ) ), segment2[1], segment2[2] }
	)
	-- No intersection
	if not x then return false
	-- Same slope and y-intercept
	elseif x == true then
		local a = segmentCheckPoint( segment1[1], segment1[2], unpack( segment2 ) )
		local b = segmentCheckPoint( segment1[3], segment1[4], unpack( segment2 ) )
		local c = segmentCheckPoint( segment2[1], segment2[2], unpack( segment1 ) )
		local d = segmentCheckPoint( segment2[3], segment2[4], unpack( segment1 ) )
		-- segment1 lies completely within segment2
		if a and b then
			return unpack( segment1 )
		elseif a and c then
			return segment1[1], segment1[2], segment2[1], segment2[2]
		elseif a and d then
			return segment1[1], segment1[2], segment2[3], segment2[4]
		elseif b and c then
			return segment1[3], segment1[4], segment2[1], segment2[2]
		elseif b and d then
			return segment1[3], segment1[4], segment2[3], segment2[4]
		-- segment2 lies completely within segment1
		elseif c and d then
			return unpack( segment2 )
		else
			return false
		end
	-- Regular intersection
	else
		if segmentCheckPoint( x, y, unpack( segment1 ) ) and segmentCheckPoint( x, y, unpack( segment2 ) ) then
			return x, y
		else
			return false
		end
	end
end

--- Get the closest point on a segment
-- @function segment.getClosestPoint
-- @tparam number px The point to which the closest point on the line should lie
-- @tparam number py
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number cx The closest point to `( px, py )` which lies on the line
-- @treturn number cy
local function segmentGetClosestPoint( px, py, x1, y1, x2, y2 )
	local m, b = lineGetSlope( x1, y1, x2, y2 ), lineGetIntercept( x1, y1, x2, y2 )
	local pm = lineGetPerpendicularSlope( m )
	local x, y = lineGetLineIntersection( { m, x1, y1 }, { pm, px, py } )
	if not x then return false end
	if segmentCheckPoint( x, y, x1, y1, x2, y2 ) then
		return x, y
	else
		local d1, d2 = segmentGetLength2( px, py, x1, y1 ), segmentGetLength( px, py, x2, y2 )
		if d1 < d2 then
			return x1, y1
		else
			return x2, y2
		end
	end
end
-- @section end
-- }}}

return {
	line = {
		getSlope = lineGetSlope,
		getPerpendicularSlope = lineGetPerpendicularSlope,
		getIntercept = lineGetIntercept,
		getLineIntersection = lineGetLineIntersection,
		getClosestPoint = lineGetClosestPoint,
		checkPoint = lineCheckPoint,
	},
	segment = {
		getMidpoint = segmentGetMidpoint,
		getLength = segmentGetLength,
		getLength2 = segmentGetLength2,
		checkPoint = segmentCheckPoint,
		getLineIntersection = segmentGetLineIntersection,
		getSegmentIntersection = segmentGetSegmentIntersection,
		getClosestPoint = segmentGetClosestPoint,
	}
}
