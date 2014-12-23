------------ Local Utility Functions ------------
local unpack = table.unpack or unpack

-- Used to handle variable-argument functions and whether they are passed as func{ table } or func( unpack( table ) )
local function checkUserdata( ... )
	local userdata = {}
	if type( ... ) ~= 'table' then userdata = { ... } else userdata = ... end
	return userdata
end

--[[
	Returns a number and an index given a local function. If the local function returns true it updates the key.
	
	Example:
	
	Numbers = { 1, 2, 3, 4, 10 }
	largestNumber, reference = GetIndex( Numbers, local function ( Value1, Value2 ) return Value1 > Value2 end ) 
	print( largestNumber, reference ) --> 10, 5
]]
local function sortWithReference( tab, func )
    if #tab == 0 then return nil, nil end
    local key, value = 1, tab[1]
    for i = 2, #tab do
        if func( value, tab[i] ) then
            key, value = i, tab[i]
        end
    end
    return value, key
end

-- Deals with floats / very false false values. This can happen because of significant figures.
local function checkFuzzy( number1, number2 )
	return ( number1 - .00001 <= number2 and number2 <= number1 + .00001 )
end

-- Remove multiple occurrences from a table.
local function removeDuplicatePairs( tab ) 
	for index1 = #tab, 1, -1 do
		local first = tab[index1]
		for index2 = #tab, 1, -1 do
			local second = tab[index2]
			if index1 ~= index2 then
				if type( first[1] ) == 'number' and type( second[1] ) == 'number' and type( first[2] ) == 'number' and type( second[2] ) == 'number' then
					if checkFuzzy( first[1], second[1] ) and checkFuzzy( first[2], second[2] ) then
						table.remove( tab, index1 )
					end
				elseif first[1] == second[1] and first[2] == second[2] then
					table.remove( tab, index1 )
				-- else
					-- if type( first[1] ) == 'table' and type( second[1] ) == 'table' then
						-- if ( first[1][1] == second[1][1] or first[1][1] == second[1][3] ) and ( first[1][2] == second[1][2] or first[1][2] == second[1][4] )
						-- and ( first[1][3] == second[1][1] or first[1][3] == second[1][1] ) and ( first[1][4] == second[1][4] or first[1][4] == second[1][2] ) then
							-- table.remove( tab, index1 )
						-- end
					-- end
				end
			end
		end
	end
	return tab
end

-- Make a deep copy of the table.
local function copy( tab, cache )
    if type( tab ) ~= 'table' then
        return tab
    end

    cache = cache or {}
    if cache[tab] then
        return cache[tab]
    end

    local new = {}
    cache[tab] = new
    for key, value in pairs( tab ) do
        new[copy( key, cache )] = copy( value, cache )
    end

    return new
end

-------------------  Lines  --------------------
-- Returns the length of a line.
local function getLength( x1, y1, x2, y2 ) 
	return math.sqrt( ( x1 - x2 ) * ( x1 - x2 ) + ( y1 - y2 ) * ( y1 - y2 ) )
end

-- Gives the midpoint of a line.
local function getMidpoint( x1, y1, x2, y2 )
	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

-- Gives the slope of a line.
local function getSlope( x1, y1, x2, y2 )
	if x1 == x2 then return false end -- Technically it's infinity, but this is easier to program.
	return ( y1 - y2 ) / ( x1 - x2 )
end

-- Gives the perpendicular slope of a line.
-- x1, y1, x2, y2
-- slope
local function getPerpendicularSlope( ... )
	local userdata = checkUserdata( ... )
	local Slope
	
	if #userdata ~= 1 then 
		slope = getSlope( unpack( userdata ) ) 
	else
		slope = unpack( userdata ) 
	end
	
	if slope == 0 then return false  	-- Horizontal lines become vertical.
	elseif not slope then return 0 end	-- Vertical lines become horizontal.
	return -1 / slope 
end

-- Gives the perpendicular bisector of a line.
local function getPerpendicularBisector( x1, y1, x2, y2 )
	local slope = getSlope( x1, y1, x2, y2 )
	local midpointX, midpointY = getMidpoint( x1, y1, x2, y2 )
	return midpointX, midpointY, getPerpendicularSlope( slope )
end

-- Gives the y-intercept of a line.
-- x1, y1, x2, y2
-- x1, y1, slope
local function getIntercept( x, y, ... )
	local userdata = checkUserdata( ... )
	local slope
	
	if #userdata == 1 then 
		slope = userdata[1] 
	else
		slope = getSlope( x, y, unpack( userdata ) ) 
	end
	
	if not slope then return false end
	return y - slope * x
end

-- Gives the intersection of two lines.
-- slope1, 	slope2, 		x1, 	y1, 		x2, y2
-- slope1, 	intercept1, 	slope2, intercept2
-- x1, 		y1, 			x2, 	y2, 		x3, y3, x4, y4
local function getLineLineIntersection( ... )
	local userdata = checkUserdata( ... )
	local x1, y1, x2, y2, x3, y3, x4, y4
	local slope1, intercept1
	local slope2, intercept2
	local x, y
	
	if #userdata == 4 then -- Given slope1, intercept1, slope2, intercept2. 
		slope1, intercept1, slope2, intercept2 = unpack( userdata ) 
		
		-- Since these are lines, not segments, we can use arbitrary points, such as ( 1, y ), ( 2, y )
		y1 = slope1 * 1 + intercept1
		y2 = slope1 * 2 + intercept1
		y3 = slope2 * 1 + intercept2
		y4 = slope2 * 2 + intercept2
		x1 = ( y1 - intercept1 ) / slope1
		x2 = ( y2 - intercept1 ) / slope1
		x3 = ( y3 - intercept1 ) / slope1
		x4 = ( y4 - intercept1 ) / slope1
	elseif #userdata == 6 then -- Given slope1, intercept1, and 2 points on the other line. 
		slope1 = userdata[1]
		intercept1 = userdata[2]
		slope2 = getSlope( userdata[3], userdata[4], userdata[5], userdata[6] )
		intercept2 =  getIntercept( userdata[3], userdata[4], userdata[5], userdata[6] )
		
		y1 = slope1 * 1 + intercept1
		y2 = slope1 * 2 + intercept1
		y3 = userdata[4]
		y4 = userdata[6]
		x1 = ( y1 - intercept1 ) / slope1
		x2 = ( y2 - intercept1 ) / slope1
		x3 = userdata[3]
		x4 = userdata[5]
	elseif #userdata == 8 then -- Given 2 points on line 1 and 2 points on line 2.
		slope1 = getSlope( userdata[1], userdata[2], userdata[3], userdata[4] )
		intercept1 = getIntercept( userdata[1], userdata[2], userdata[3], userdata[4] )
		slope2 = getSlope( userdata[5], userdata[6], userdata[7], userdata[8] )
		intercept2 = getIntercept( userdata[5], userdata[6], userdata[7], userdata[8] ) 
		
		x1, y1, x2, y2, x3, y3, x4, y4 = unpack( userdata )
	end
	
	if not slope1 and not slope2 then -- Both are vertical lines
		if x1 == x3 then -- Have to have the same x and y positions to intersect
			return true
		else
			return false
		end
	elseif not slope1 then -- First is vertical
		x = x1 -- They have to meet at this x, since it is this line's only x
		y = slope2 * x + intercept2
	elseif not slope2 then -- Second is vertical
		x = x3 -- Vice-Versa
		y = slope1 * x + intercept1
	elseif slope1 == slope2 then -- Parallel (not vertical)
		if intercept1 == intercept2 then -- Same intercept
			return true
		else
			return false
		end
	else -- Regular lines
		-- 		y = m1 * x + b1
		-- 	  - y = m2 * x + b2
		--		---------------
		--      0 = x * ( m1 - m2 ) + ( b1 - b2 )
		--     -( b1 - b2 ) = x * ( m1 - m2 )
		--      x = ( -b1 + b2 ) / ( m1 - m2 )
		
		x = ( -intercept1 + intercept2 ) / ( slope1 - slope2 )
		y = slope1 * x + intercept1
	end
	
	return x, y
end

-- Gives the closest point to a line.
-- perpendicularX, perpendicularY, x1, 		y1, 		x2, y2
-- perpendicularX, perpendicularY, slope, 	intercept
local function getClosestPoint( perpendicularX, perpendicularY, ... )
	local userdata = checkUserdata( ... )
	local x1, y1, x2, y2, slope, intercept
	local x, y
	
	if #userdata == 4 then -- Given perpendicularX, perpendicularY, x1, y1, x2, y2
		x1, y1, x2, y2 = unpack( userdata )
		slope = getSlope( x1, y1, x2, y2 )
		intercept = getIntercept( x1, y1, x2, y2 )
	elseif #userdata == 2 then -- Given perpendicularX, perpendicularY, slope, intercept
		slope, intercept = unpack( userdata )
	end
	
	if not slope then -- Vertical line
		x, y = x1, perpendicularY -- Closest point is always perpendicular, so you know where the point is.
	elseif slope == 0 then -- Horizontal line
		x, y = perpendicularX, y1
	else
		local perpendicularSlope = getPerpendicularSlope( slope )
		local perpendicularIntercept = getIntercept( perpendicularX, perpendicularY, perpendicularSlope )
		x, y = getLineLineIntersection( slope, intercept, perpendicularSlope, perpendicularIntercept )
	end
	
	return x, y
end

-- Gives the intersection of a line and a line segment.
-- x1, y1, x2, y2, x3, 		y3, x4, y4
-- x1, y1, x2, y2, slope, 	intercept
local function getLineSegmentIntersection( x1, y1, x2, y2, ... )
	local userdata = checkUserdata( ... )
	
	local slope1, intercept1
	local slope2, intercept2 = getSlope( x1, y1, x2, y2 ), getIntercept( x1, y1, x2, y2 )
	local x, y
	
	if #userdata == 2 then -- Given slope, intercept
		slope1, intercept1 = userdata[1], userdata[2]
	else -- Given x3, y3, x4, y4
		slope1 = getSlope( unpack( userdata ) )
		intercept1 = getIntercept( unpack( userdata ) )
	end
	
	if not slope1 and not slope2 then -- Vertical lines
		if x1 == userdata[1] then
			return x1, y1, x2, y2
		else
			return false
		end
	elseif not slope1 then -- slope1 is vertical
		x, y = userdata[1], slope2 * userdata[1] + intercept2
	elseif not slope2 then -- slope2 is vertical
		x, y = x1, slope1 * x1 + intercept1
	else
		x, y = getLineLineIntersection( slope1, intercept1, slope2, intercept2 )
	end
	
	local length1, length2, distance
	if x == true then -- Lines are collinear. 
		return x1, y1, x2, y2
	elseif x then -- There is an intersection
		length1, length2 = getLength( x1, y1, x, y ), getLength( x2, y2, x, y )
		distance = getLength( x1, y1, x2, y2 )
	else -- Lines are parallel but not collinear.
		if intercept1 == intercept2 then
			return x1, y1, x2, y2
		else
			return false
		end
	end
	
	if length1 <= distance and length2 <= distance then return x, y else return false end
end

-- Checks if a point is on a line.
-- Does not support the format using slope because vertical lines would be impossible to check.
local function checkLinePoint( x, y, x1, y1, x2, y2 )
	local m = getSlope( x1, y1, x2, y2 )
	local b = getIntercept( x1, y1, m )
	
	if not m then -- Vertical 
		return x == x1
	end
	
	return checkFuzzy( y, m * x + b )
end

----------------  Line Segment  ----------------
-- Gives whether or not a point lies on a line segment.
local function checkSegmentPoint( px, py, x1, y1, x2, y2 )
	-- Explanation around 5:20
	-- https://www.youtube.com/watch?v=A86COO8KC58
	local x = checkLinePoint( px, py, x1, y1, x2, y2 )
	if not x then return false end
	
	local lengthX = x2 - x1
	local lengthY = y2 - y1
	
	if lengthX == 0 then -- Vertical line
		if px == x1 then
			local low, high
			if y1 > y2 then low = y2; high = y1 
			else low = y1; high = y2 end
			
			if py >= low and py <= high then return true 
			else return false end
		else
			return false
		end
	elseif lengthY == 0 then -- Horizontal line
		if py == y1 then
			local low, high
			if x1 > x2 then low = x2; high = x1 
			else low = x1; high = x2 end
			
			if px >= low and px <= high then return true 
			else return false end
		else
			return false
		end
	end
	
	local distanceToPointX = ( px - x1 )
	local distanceToPointY = ( py - y1 )
	local scaleX = distanceToPointX / lengthX
	local scaleY = distanceToPointY / lengthY
	
	if ( scaleX >= 0 and scaleX <= 1 ) and ( scaleY >= 0 and scaleY <= 1 ) then -- Intersection
		return true
	end
	return false
end

-- Gives the point of intersection between two line segments.
local function getSegmentSegmentIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )
	local slope1, intercept1 = getSlope( x1, y1, x2, y2 ), getIntercept( x1, y1, x2, y2 )
	local slope2, intercept2 = getSlope( x3, y3, x4, y4 ), getIntercept( x3, y3, x4, y4 )
	
	-- Add points to the table.
	local function addPoints( tab, x, y )
		tab[#tab + 1] = x
		tab[#tab + 1] = y
	end
	
	local function removeDuplicatePairs( tab )
		for i = #tab - 1, 1, -2 do
			local x1, y1 = tab[i], tab[i + 1]
			for ii = #tab - 1, 1, -2 do 
				local x2, y2 = tab[ii], tab[ii + 1]
				if i ~= ii then
					if x1 == x2 and y1 == y2 then
						table.remove( tab, i )
						table.remove( tab, i )
					end
				end
			end
		end
		return tab
	end
	
	if slope1 == slope2 then -- Parallel lines
		if intercept1 == intercept2 then -- The same lines, possibly in different points. 
			local points = {}
			if checkSegmentPoint( x1, y1, x3, y3, x4, y4 ) then addPoints( points, x1, y1 ) end
			if checkSegmentPoint( x2, y2, x3, y3, x4, y4 ) then addPoints( points, x2, y2 ) end
			if checkSegmentPoint( x3, y3, x1, y1, x2, y2 ) then addPoints( points, x3, y3 ) end
			if checkSegmentPoint( x4, y4, x1, y1, x2, y2 ) then addPoints( points, x4, y4 ) end
			
			points = removeDuplicatePairs( points )
			if #points == 0 then return false end
			return unpack( points )
		else
			return false
		end
	end	

	local x, y = getLineLineIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )
	if x and checkSegmentPoint( x, y, x1, y1, x2, y2 ) and checkSegmentPoint( x, y, x3, y3, x4, y4 ) then
		return x, y
	end
	
	return false
end

--------------------- Math ---------------------
-- Get the root of a number (i.e. the 2nd (square) root of 4 is 2)
local function getRoot( number, root )
	local num = number ^ ( 1 / root )
	return num
end

-- Checks if a number is prime.
local function isPrime( number )	
	if number < 2 then return false end
		
	for i = 2, math.sqrt( number ) do
		if number % i == 0 then
			return false
		end
	end
	
	return true
end

-- Rounds a number to the xth place (round( 3.14159265359, 4 ) --> 3.1416)
local function round( number, place )
	local place, returnValue = place and 10 ^ place or 1
	
	local high = math.ceil( number * place )
	local low = math.floor( number * place )
	
	local highDifferance = high - ( number * place ) 
	local lowDifferance = ( number * place ) - low
	
	if high == number then
		returnValue = number
	else
		if highDifferance <= lowDifferance then returnValue = high 
		else returnValue = low end
	end
	
	return returnValue / place
end

-- Gives the summation given a local function
local function getSummation( start, stop, func )
	if stop == 1 / 0 or stop == -1 / 0 then return false end
	
	local returnValue = {}
	local value = 0
	
	for i = start, stop do
		local new = func( i, returnValue )
		
		returnValue[i] = new
		value = value + new
	end
	
	return value
end

-- Gives the percent of change.
local function getPercentOfChange( old, new )
	if old == 0 and new == 0 then
		return 0
	elseif old == 0 then 
		return false
	else 
		return ( new - old ) / math.abs( old ) 
	end
end

-- Gives the percentage of a number.
local function getPercentage( percent, number )
	return percent * number
end

-- Returns the quadratic roots of an equation. 
local function getQuadraticRoots( a, b, c )
	local discriminant = b ^ 2 - ( 4 * a * c )
	if discriminant < 0 then return false end
	
	discriminant = math.sqrt( discriminant )
	local denominator = ( 2 * a )
	
	return ( -b - discriminant ) / denominator, ( -b + discriminant ) / denominator
end

-- Gives the angle between three points. 
local function getAngle( x1, y1, x2, y2, x3, y3 )	
    local a = getLength( x3, y3, x2, y2 )
    local b = getLength( x1, y1, x2, y2 )
    local c = getLength( x1, y1, x3, y3 )

   return math.acos( ( a * a + b * b - c * c ) / ( 2 * a * b ) )
end

-------------------  Circle  -------------------
-- Gives the area of the circle.
local function getCircleArea( radius )
	return math.pi * ( radius * radius )
end

-- Checks if a point is on the radius of a circle.
local function checkCirclePoint( x, y, circleX, circleY, radius )
	return getLength( circleX, circleY, x, y ) <= radius
end

-- Checks if a point is inside a circle. 
local function isPointOnCircle( x, y, circleX, circleY, radius )
	return checkFuzzy( getLength( circleX, circleY, x, y ), radius )
end

-- Gives the circumference of a circle.
local function getCircumference( radius )
	return 2 * math.pi * radius
end

-- Gives the intersection of a line and a circle. 
local function getCircleLineIntersection( circleX, circleY, radius, x1, y1, x2, y2 )
	slope = getSlope( x1, y1, x2, y2 ) 
	intercept = getIntercept( x1, y1, slope ) 
	
	if slope then 
		local a = ( 1 + slope ^ 2 )
		local b = ( -2 * ( circleX ) + ( 2 * slope * intercept ) - ( 2 * circleY * slope ) )
		local c = ( circleX ^ 2 + intercept ^ 2 - 2 * ( circleY ) * ( intercept ) + circleY ^ 2 - radius ^ 2 )
		
		x1, x2 = getQuadraticRoots( a, b, c )
		
		if not x1 then return false end
		
		y1 = slope * x1 + intercept
		y2 = slope * x2 + intercept
		
		if x1 == x2 and y1 == y2 then 
			return 'tangent', x1, y1
		else 
			return 'secant', x1, y1, x2, y2 
		end
	else -- Vertical Lines
		-- Theory: *see Reference Pictures/Circle.png for information on how it works.
		local lengthToPoint1 = circleX - x1
		local remainingDistance = lengthToPoint1 - radius
		local intercept = math.sqrt( -( lengthToPoint1 ^ 2 - radius ^ 2 ) )
		
		if -( lengthToPoint1 ^ 2 - radius ^ 2 ) < 0 then return false end
		
		local bottomX, bottomY = x1, circleY - intercept
		local topX, topY = x1, circleY + intercept
		
		if topY ~= bottomY then 
			return 'secant', topX, topY, bottomX, bottomY 
		else 
			return 'tangent', topX, topY 
		end
	end
end

-- Gives the type of intersection of a line segment. 
local function getCircleSegmentIntersection( circleX, circleY, radius, x1, y1, x2, y2 )
	local Type, x3, y3, x4, y4 = getCircleLineIntersection( circleX, circleY, radius, x1, y1, x2, y2 )
	if not Type then return false end
	
	local slope, intercept = getSlope( x1, y1, x2, y2 ), getIntercept( x1, y1, x2, y2 )
	
	if isPointOnCircle( x1, y1, circleX, circleY, radius ) and isPointOnCircle( x2, y2, circleX, circleY, radius ) then -- Both points are on line-segment. 
		return 'chord', x1, y1, x2, y2
	end
	
	if slope then 
		if checkCirclePoint( x1, y1, circleX, circleY, radius ) and checkCirclePoint( x2, y2, circleX, circleY, radius ) then -- Line-segment is fully in circle. 
			return 'enclosed', x1, y1, x2, y2
		elseif x3 and x4 then
			if checkSegmentPoint( x3, y3, x1, y1, x2, y2 ) and not checkSegmentPoint( x4, y4, x1, y1, x2, y2 ) then -- Only the first of the points is on the line-segment. 
				return 'tangent', x3, y3
			elseif checkSegmentPoint( x4, y4, x1, y1, x2, y2 ) and not checkSegmentPoint( x3, y3, x1, y1, x2, y2 ) then -- Only the second of the points is on the line-segment. 
				return 'tangent', x4, y4
			else -- Neither of the points are on the circle (means that the segment is not on the circle, but "encasing" the circle)
				if checkSegmentPoint( x3, y3, x1, y1, x2, y2 ) and checkSegmentPoint( x4, y4, x1, y1, x2, y2 ) then
					return 'secant', x3, y3, x4, y4
				else
					return false
				end
			end
		elseif not x4 then -- Is a tangent. 
			if checkSegmentPoint( x3, y3, x1, y1, x2, y2 ) then
				return 'tangent', x3, y3
			else -- Neither of the points are on the line-segment (means that the segment is not on the circle or "encasing" the circle).
				local length = getLength( x1, y1, x2, y2 )
				local distance1 = getLength( x1, y1, x3, y3 )
				local distance2 = getLength( x2, y2, x3, y3 )
				
				if length > distance1 or length > distance2 then 
					return false
				elseif length < distance1 and length < distance2 then 
					return false 
				else
					return 'tangent', x3, y3
				end
			end
		end
	else
		-- Theory: *see Reference Images/Circle.png for information on how it works.
		local lengthToPoint1 = circleX - x1
		local remainingDistance = lengthToPoint1 - radius
		local intercept = math.sqrt( -( lengthToPoint1 ^ 2 - radius ^ 2 ) )
		
		if -( lengthToPoint1 ^ 2 - radius ^ 2 ) < 0 then return false end
		
		local topX, topY = x1, circleY - intercept
		local bottomX, bottomY = x1, circleY + intercept
		
		local length = getLength( x1, y1, x2, y2 )
		local distance1 = getLength( x1, y1, topX, topY )
		local distance2 = getLength( x2, y2, topX, topY )
		
		if bottomY ~= topY then -- Not a tangent
			if checkSegmentPoint( topX, topY, x1, y1, x2, y2 ) and checkSegmentPoint( bottomX, bottomY, x1, y1, x2, y2 ) then
				return 'chord', topX, topY, bottomX, bottomY
			elseif checkSegmentPoint( topX, topY, x1, y1, x2, y2 ) then
				return 'tangent', topX, topX
			elseif checkSegmentPoint( bottomX, bottomY, x1, y1, x2, y2 ) then
				return 'tangent', bottomX, bottomY
			else
				return false
			end
		else -- Tangent
			if checkSegmentPoint( topX, topY, x1, y1, x2, y2 ) then
				return 'tangent', topX, topY
			else
				return false
			end
		end
	end
end

-- Checks if one circle intersects another circle.
local function getCircleCircleIntersection( circle1x, circle1y, radius1, circle2x, circle2y, radius2 )
	local length = getLength( circle1x, circle1y, circle2x, circle2y )
	if length > radius1 + radius2 then return false end -- If the distance is greater than the two radii, they can't intersect.
	if checkFuzzy( length, 0 ) and radius1 == radius2 then return 'equal' end	
	if circle1x == circle2x and circle1y == circle2y then return 'collinear' end
	
	local a = ( radius1 * radius1 - radius2 * radius2 + length * length ) / ( 2 * length )
	local h = math.sqrt( radius1 * radius1 - a * a )
	
	local p2x = circle1x + a * ( circle2x - circle1x ) / length
	local p2y = circle1y + a * ( circle2y - circle1y ) / length
	local p3x = p2x + h * ( circle2y - circle1y ) / length
	local p3y = p2y - h * ( circle2x - circle1x ) / length
	local p4x = p2x - h * ( circle2y - circle1y ) / length
	local p4y = p2y + h * ( circle2x - circle1x ) / length
	
	if checkFuzzy( length, radius1 + radius2 ) then return 'tangent', p3x, p3y end 
	return 'intersection', p3x, p3y, p4x, p4y 
end

-------------------- Polygon  --------------------
-- Gives the signed area.
-- If the points are clockwise the number is negative, otherwise, it's positive.
local function getSignedPolygonArea( ... ) 
	local points = checkUserdata( ... )
	
	-- Shoelace formula (https://en.wikipedia.org/wiki/Shoelace_formula).
	points[#points + 1] = points[1]
	points[#points + 1] = points[2]
	
	return ( .5 * getSummation( 1, #points / 2, 
		function( index ) 
			index = index * 2 - 1 -- Convert it to work properly.
			if points[index + 3] then 
				return ( ( points[index] * points[index + 3] ) - ( points[index + 2] * points[index + 1] ) ) 
			else 
				return ( ( points[index] * points[2] ) - ( points[1] * points[index + 1] ) )
			end 
		end 
	) )
end

-- Simply returns the area of the polygon.
local function getPolygonArea( ... ) 
	return math.abs( getSignedPolygonArea( ... ) )
end

-- Gives the height of a triangle, given the base.
-- base, x1, 	y1, x2, y2, x3, y3, x4, y4
-- base, area
local function getTriangleHeight( base, ... )
	local userdata = checkUserdata( ... )
	local area

	if #userdata == 1 then area = userdata[1] -- Given area.
	else area = getPolygonArea( userdata ) end -- Given coordinates.
	
	-- area = ( base * height ) / 2
	-- 2 * area = base * height
	-- height = ( 2 * area ) / base
	return ( 2 * area ) / base, area
end

-- Gives the centroid of the polygon.
local function getCentroid( ... ) 
	local points = checkUserdata( ... )
	
	points[#points + 1] = points[1]
	points[#points + 1] = points[2]
	
	local area = getSignedPolygonArea( points ) -- Needs to be signed here in case points are counter-clockwise. 
	
	-- This formula: https://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon
	local centroidX = ( 1 / ( 6 * area ) ) * ( getSummation( 1, #points / 2, 
		function( index ) 
			index = index * 2 - 1 -- Convert it to work properly.
			if points[index + 3] then
				return ( ( points[index] + points[index + 2] ) * ( ( points[index] * points[index + 3] ) - ( points[index + 2] * points[index + 1] ) ) )
			else
				return ( ( points[index] + points[1] ) * ( ( points[index] * points[2] ) - ( points[1] * points[index + 1] ) ) )
			end
		end
	) )
	
	local centroidY = ( 1 / ( 6 * area ) ) * ( getSummation( 1, #points / 2, 
		function( index ) 
			index = index * 2 - 1 -- Convert it to work properly.
			if points[index + 3] then
				return ( ( points[index + 1] + points[index + 3] ) * ( ( points[index] * points[index + 3] ) - ( points[index + 2] * points[index + 1] ) ) )
			else
				return ( ( points[index + 1] + points[2] ) * ( ( points[index] * points[2] ) - ( points[1] * points[index + 1] ) ) )
			end
		end 
	) )

	return centroidX, centroidY
end

-- Checks if the point lies INSIDE the polygon not on the polygon.
local function checkPolygonPoint( px, py, ... )
	local points = checkUserdata( ... )
	
	local function getGreatestPoint( points )
		local greatest = points[1]
		for i = 2, #points / 2 do
			i = i * 2 - 1
			if points[i] > greatest then
				greatest = points[i]
			end
		end
		return greatest
	end
	
	
	local greatest = getGreatestPoint( points )
	if greatest < px then return false end -- Speeds up process and prevents false positives (segment will always intersect).	
	
	local count = 0
	for i = 1, #points, 2 do
		local x1, y1, x2, y2
		if points[i + 3] then
			x1, y1, x2, y2 = points[i], points[i + 1], points[i + 2], points[i + 3]
		else
			x1, y1, x2, y2 = points[i], points[i + 1], points[1], points[2]
		end
		if getSegmentSegmentIntersection( px, py, greatest, py, x1, y1, x2, y2 ) then count = count + 1 end
	end
	
	return count % 2 ~= 0
end

-- Returns whether or not a line intersects a polygon.
-- x1, y1, x2, y2, polygonPoints
local function getPolygonLineIntersection( x1, y1, x2, y2, ... )
	local userdata = checkUserdata( ... )
	local choices = {}
	
	local slope = getSlope( x1, y1, x2, y2 )
	local intercept = getIntercept( x1, y1, slope )
	
	local x3, y3, x4, y4
	if slope then
		x3, x4 = 1, 2
		y3, y4 = slope * x3 + intercept, slope * x4 + intercept
	else
		x3, x4 = x1, x1
		y3, y4 = y1, y2
	end
	
	for i = 1, #userdata, 2 do
		if userdata[i + 2] then
			local x1, y1, x2, y2 = getLineSegmentIntersection( userdata[i], userdata[i + 1], userdata[i + 2], userdata[i + 3], x3, y3, x4, y4 )
			if x1 and not x2 then choices[#choices + 1] = { x1, y1 } 
			elseif x2 then choices[#choices + 1] = { x1, y1, x2, y2 } end
		else
			local x1, y1, x2, y2 = getLineSegmentIntersection( userdata[i], userdata[i + 1], userdata[1], userdata[2], x3, y3, x4, y4 )
			if x1 and not x2 then choices[#choices + 1] = { x1, y1 } 
			elseif x2 then choices[#choices + 1] = { x1, y1, x2, y2 } end
		end
	end
	
	local final = removeDuplicatePairs( choices )
	return #final > 0 and final or false
end

-- Returns if the line segment intersects the polygon.
-- x1, y1, x2, y2, polygonPoints
local function getPolygonSegmentIntersection( x1, y1, x2, y2, ... )
	local userdata = checkUserdata( ... )
	local choices = {}
	
	for i = 1, #userdata, 2 do
		-- if checkSegmentPoint( x1, y1, x2, y2, userdata[i], userdata[i + 1] ) then return true end
		if userdata[i + 2] then
			local x1, y1, x2, y2 = getSegmentSegmentIntersection( userdata[i], userdata[i + 1], userdata[i + 2], userdata[i + 3], x1, y1, x2, y2 )
			if x1 and not x2 then choices[#choices + 1] = { x1, y1 } 
			elseif x2 then choices[#choices + 1] = { x1, y1, x2, y2 } end
		else
			local x1, y1, x2, y2 = getSegmentSegmentIntersection( userdata[i], userdata[i + 1], userdata[1], userdata[2], x1, y1, x2, y2 )
			if x1 and not x2 then choices[#choices + 1] = { x1, y1 } 
			elseif x2 then choices[#choices + 1] = { x1, y1, x2, y2 } end
		end
	end

	local final = removeDuplicatePairs( choices )
	return #final > 0 and final or false
end

-- Returns if the line segment is fully or partially inside. 
-- x1, y1, x2, y2, polygonPoints
local function isSegmentInsidePolygon( x1, y1, x2, y2, ... )
	local userdata = checkUserdata( ... )
	
	local choices = getPolygonSegmentIntersection( x1, y1, x2, y2, userdata ) -- If it's partially enclosed that's all we need.
	if choices then return true end
	
	if checkPolygonPoint( x1, y1, userdata ) or checkPolygonPoint( x2, y2, userdata ) then return true end
	return false
end

-- Returns whether two polygons intersect.
local function getPolygonPolygonIntersection( polygon1, polygon2 )
	local choices = {}
	
	for index1 = 1, #polygon1, 2 do
		if polygon1[index1 + 2] then
			local intersections = getPolygonSegmentIntersection( polygon1[index1], polygon1[index1 + 1], polygon1[index1 + 2], polygon1[index1 + 3], polygon2 )
			if intersections and #intersections > 0 then
				for index2 = 1, #intersections do
					choices[#choices + 1] = { unpack( intersections[index2] ) }
				end
			end
		else
			local intersections = getPolygonSegmentIntersection( polygon1[index1], polygon1[index1 + 1], polygon1[1], polygon1[2], polygon2 )
			if intersections and #intersections > 0 then
				for index2 = 1, #intersections do
					choices[#choices + 1] = { unpack( intersections[index2] ) }
				end
			end
		end
	end
	
	for index1 = 1, #polygon2, 2 do
		if polygon2[index1 + 2] then
			local intersections = getPolygonSegmentIntersection( polygon2[index1], polygon2[index1 + 1], polygon2[index1 + 2], polygon2[index1 + 3], polygon1 )
			if intersections and #intersections > 0 then
				for index2 = 1, #intersections do
					choices[#choices + 1] = { unpack( intersections[index2] ) }
				end
			end
		else
			local intersections = getPolygonSegmentIntersection( polygon2[index1], polygon2[index1 + 1], polygon2[1], polygon2[2], polygon1 )
			if intersections and #intersections > 0 then
				for index2 = 1, #intersections do
					choices[#choices + 1] = { unpack( intersections[index2] ) }
				end
			end
		end
	end	

	local final = removeDuplicatePairs( choices )
	for i = #final, 1, -1 do
		if type( final[i][1] ) == 'table' then -- Remove co-linear pairs.
			table.remove( final, i )
		end
	end
	
	return #final > 0 and final
end

-- Returns whether the circle intersects the polygon.
-- x, y, radius, polygonPoints
local function getPolygonCircleIntersection( x, y, radius, ... )
	local userdata = checkUserdata( ... )
	local choices = {}
	
	local function removeDuplicates( tab ) 
		for index1 = #tab, 1, -1 do
			local first = tab[index1]
			for index2 = #tab, 1, -1 do
				local second = tab[index2]
				if index1 ~= index2 then
					if type( first[1] ) ~= type( second[1] ) then return false end
					if type( first[2] ) == 'number' and type( second[2] ) == 'number' and type( first[3] ) == 'number' and type( second[3] ) == 'number' then
						if checkFuzzy( first[2], second[2] ) and checkFuzzy( first[3], second[3] ) then
							table.remove( tab, index1 )
						end
					elseif first[1] == second[1] and first[2] == second[2] and first[3] == second[3] then
						table.remove( tab, index1 )
					end
				end
			end
		end
		return tab
	end
	
	for i = 1, #userdata, 2 do
		if userdata[i + 2] then 
			local Type, x1, y1, x2, y2 = getCircleSegmentIntersection( x, y, radius, userdata[i], userdata[i + 1], userdata[i + 2], userdata[i + 3] )
			if x2 then 
				choices[#choices + 1] = { Type, x1, y1, x2, y2 } 
			elseif x1 then choices[#choices + 1] = { Type, x1, y1 } end
		else
			local Type, x1, y1, x2, y2 = getCircleSegmentIntersection( x, y, radius, userdata[i], userdata[i + 1], userdata[1], userdata[2] )
			if x2 then 
				choices[#choices + 1] = { Type, x1, y1, x2, y2 } 
			elseif x1 then choices[#choices + 1] = { Type, x1, y1 } end
		end
	end
	
	local final = removeDuplicates( choices )
	
	return #final > 0 and final
end

-- Returns whether the circle is inside the polygon. 
-- x, y, radius, polygonPoints
local function isCircleInsidePolygon( x, y, radius, ... )
	local userdata = checkUserdata( ... )
	return checkPolygonPoint( x, y, userdata )
end

-- Returns whether the polygon is inside the polygon. 
local function isPolygonInsidePolygon( polygon1, polygon2 )
	local bool = false
	for i = 1, #polygon2, 2 do
		local result = false
		if polygon2[i + 3] then
			result = isSegmentInsidePolygon( polygon2[i], polygon2[i + 1], polygon2[i + 2], polygon2[i + 3], polygon1 )
		else
			result = isSegmentInsidePolygon( polygon2[i], polygon2[i + 1], polygon2[1], polygon2[2], polygon1 )
		end
		if result then bool = true; break end
	end
	return bool
end

------------------ Statistics ------------------
-- Gets the average of a list of points
-- points
local function getMean( ... )
	local userdata = checkUserdata( ... )
	
	mean = getSummation( 1, #userdata, 
		function( i, t )
			return userdata[i]
		end 
	) / #userdata
	
	return mean
end

local function getMedian( ... )
	local userdata = checkUserdata( ... )
	
	table.sort( userdata )
	
	local median
	if #userdata % 2 == 0 then -- If you have an even number of terms, you need to get the average of the middle 2.
		median = getMean( userdata[#userdata / 2], userdata[#userdata / 2 + 1] )
	else
		median = userdata[#userdata / 2 + .5]
	end
	
	return median
end

-- Gets the mode of a number.
local function getMode( ... ) 
	local userdata = checkUserdata( ... )

	table.sort( userdata )
	local sorted = {}
	for i = 1, #userdata do
		local value = userdata[i]
		sorted[value] = sorted[value] and sorted[value] + 1 or 1
	end
	
	local occurrences, least = 0, {} 
	for i, value in pairs( sorted ) do
		if value > occurrences then
			least = { i }
			occurrences = value
		elseif value == occurrences then
			least[#least + 1] = i
		end
	end
	
	if #least >= 1 then return least, occurrences
	else return false end
end

-- Gets the range of the numbers.
local function getRange( ... )
	local userdata = checkUserdata( ... )
	local high, low = math.max( unpack( userdata ) ), math.min( unpack( userdata ) )
	return high - low
end

return {
	_VERSION = 'MLib 0.9.0', 
	_DESCRIPTION = 'A math and collisions library aimed at LÖVE.', 
	_URL = 'https://github.com/davisdude/mlib', 
	_LICENSE = [[
		A math library made in Lua

		copyright (C) 2014 Davis Claiborne

		This program is free software; you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation; either version 2 of the License, or
		(at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along
		with this program; if not, write to the Free Software Foundation, Inc.,
		51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

		Contact me at davisclaib@gmail.com
	]], 
	line = {
		getLength = 				getLength, 
		getDistance = 				getLength, -- Alias
		getMidpoint = 				getMidpoint, 
		getSlope = 					getSlope, 
		getPerpendicularSlope = 	getPerpendicularSlope, 
		getPerpendicularBisector = 	getPerpendicularBisector, 
		getIntercept = 				getIntercept, 
		getIntersection = 			getLineLineIntersection, 
		getClosestPoint = 			getClosestPoint, 
		getSegmentIntersection = 	getLineSegmentIntersection, 
		checkPoint = 				checkLinePoint, 
		
		segment = {
			checkPoint = 			checkSegmentPoint, 
			getIntersection = 		getSegmentSegmentIntersection, 
		}, 
	},
	polygon = {
		getTriangleHeight = 		getTriangleHeight, 
		getSignedArea = 			getSignedPolygonArea, 
		getArea = 					getPolygonArea, 
		getCentroid = 				getCentroid, 
		checkPoint = 				checkPolygonPoint, 
		getLineIntersection = 		getPolygonLineIntersection, 
		getSegmentIntersection = 	getPolygonSegmentIntersection, 
		isSegmentInside = 			isSegmentInsidePolygon, 
		getPolygonIntersection = 	getPolygonPolygonIntersection, 
		getCircleIntersection = 	getPolygonCircleIntersection, 
		isCircleInside = 			isCircleInsidePolygon, 
		isPolygonInside = 			isPolygonInsidePolygon, 
	}, 
	circle = {
		getArea = 					getCircleArea, 
		checkPoint = 				checkCirclePoint, 
		getCircumference = 			getCircumference, 
		getLineIntersection = 		getCircleLineIntersection, 
		getSegmentIntersection = 	getCircleSegmentIntersection, 
		getCircleIntersection = 	getCircleCircleIntersection, 
		isPointOnCircle = 			isPointOnCircle, 
	}, 
	statistics = {
		getMean = 					getMean, 
		getMedian = 				getMedian, 
		getMode = 					getMode, 
		getRange = 					getRange, 
	}, 
	math = {
		getRoot = 					getRoot, 
		isPrime = 					isPrime, 
		round = 					round, 
		getSummation =				getSummation, 
		getPercentOfChange = 		getPercentOfChange, 
		getPercentage = 			getPercentage, 
		getQuadraticRoots = 		getQuadraticRoots, 
		getAngle = 					getAngle, 
	}, 
}

-- Name: 																		Accounted For:
-- -------------------------------------------------------------------------	--------------
-- getLength( x1, y1, x2, y2 ) 													+
-- getDistance( x1, y1, x2, y2 )												+
-- getMidpoint( x1, y1, x2, y2 )												+
-- getSlope( x1, y1, x2, y2 )													+
-- getPerpendicularSlope( ... )													+
-- getPerpendicularBisector( x1, y1, x2, y2 )									+
-- getIntercept( x, y, ... )													+
-- getLineLineIntersection( ... )												+
-- getClosestPoint( perpendicularX, perpendicularY, ... )						+
-- getLineSegmentIntersection( x1, y1, x2, y2, ... )							+
-- checkLinePoint( x, y, x1, y1, x2, y2 )										+
--																				+
-- checkSegmentPoint( px, py, x1, y1, x2, y2 )									+
-- getSegmentSegmentIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )				+
--																				+
-- getTriangleHeight( base, ... )												+
-- getSignedPolygonArea( ... ) 													+
-- getPolygonArea( ... ) 														+
-- getCentroid( ... ) 															+
-- checkPolygonPoint( px, py, ... )												+
-- getPolygonLineIntersection( x1, y1, x2, y2, ... )							+
-- getPolygonSegmentIntersection( x1, y1, x2, y2, ... )							+
-- isSegmentInsidePolygon( x1, y1, x2, y2, ... )								+
-- getPolygonPolygonIntersection( polygon1, polygon2 )							+
-- getPolygonCircleIntersection( x, y, radius, ... )							+
-- isCircleInsidePolygon( x, y, radius, ... )									+
-- isPolygonInsidePolygon( polygon1, polygon2 )									+
--																				+
-- getCircleArea( radius )														+
-- checkPoint( x, y, circleX, circleY, radius )									+
-- getCircumference( radius )													+
-- getCircleLineIntersection( circleX, circleY, radius, ... )					+
-- getCircleSegmentIntersection( cx, cy, r, x1, y1, x2, y2 )					+
-- getCircleCircleIntersection( c1x, c1y, r1, c2x, c2y, r2 )					+
-- isPointOnCircle( x, y, circleX, circleY, radius )							+
--																				+
-- getMean( ... )																+
-- getMedian( ... )																+
-- getMode( ... ) 																+
-- getRange( ... )																+
-- 																				+
-- getRoot( number, root )														+
-- isPrime( number )															+
-- round( number, place )														+
-- getSummation( start, stop, func )											+
-- getPercentOfChange( old, new )												+
-- getPercentage( percent, number )												+
-- getQuadraticRoots( a, b, c )													+
-- getAngle( x1, y1, x2, y2, x3, y3 )											+