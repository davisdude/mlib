--[[
    A math library made in Lua

    Copyright (C) 2014 Davis Claiborne

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
]]

-- Local utility functions
local function CheckUserdata( ... )
	local Userdata = {}
	if type( ... ) ~= 'table' then Userdata = { ... } else Userdata = ... end
	return Userdata
end

function SortWithReference( Table, Function )
    if #Table == 0 then return nil, nil end
    local Key, Value = 1, Table[1]
    for i = 2, #Table do
        if Function( Value, Table[i] ) then
            Key, Value = i, Table[i]
        end
    end
    return Value, Key
end

-- Lines
local function GetLength( x1, y1, x2, y2 )
	return math.sqrt( ( x1 - x2 ) ^ 2 + ( y1 - y2 ) ^ 2 )
end

local function GetMidpoint( x1, y1, x2, y2 )
	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

local function GetSlope( x1, y1, x2, y2 )
	if x1 == x2 then return false end -- Technically it's infinity, but that's irrelevant. 
	return ( y1 - y2 ) / ( x1 - x2 )
end

local function GetPerpendicularSlope( ... )
	local Userdata = CheckUserdata( ... )
	
	if #Userdata ~= 1 then 
		Slope = GetSlope( unpack( Userdata ) ) 
	else
		Slope = unpack( Userdata ) 
	end
	
	if Slope == 0 then return false end 
	if not Slope then return 0 end
	return -1 / Slope 
end

local function GetPerpendicularBisector( x1, y1, x2, y2 )
	local Slope = GetSlope( x1, y1, x2, y2 )
	return GetMidpoint( x1, y1, x2, y2 ), GetPerpendicularSlope( Slope )
end

local function GetIntercept( x, y, ... )
	local Userdata = CheckUserdata( ... )
	local Slope = false
	
	if #Userdata == 1 then 
		Slope = Userdata[1] 
	else
		Slope = Slope( x, y, unpack( Userdata ) ) 
	end
	
	if not Slope then return false end
	return y - Slope * x
end

local function GetIntersection( ... )
	local Userdata = CheckUserdata( ... )
	local x1, y1, x2, y2, x3, y3, x4, y4
	local Slope1, Intercept1
	local Slope2, Intercept2
	local x, y
	
	if #Userdata == 4 then -- Given Slope1, Intercept1, Slope2, Intercept2. 
		Slope1, Intercept1, Slope2, Intercept2 = unpack( Userdata ) 
		y1, y2, y3, y4 = Slope1 * 1 + Intercept1, Slope1 * 2 + Intercept1, Slope2 * 1 + Intercept2, Slope2 * 2 + Intercept2
		x1, x2, x3, x4 = ( y1 - Intercept1 ) / Slope1, ( y2 - Intercept1 ) / Slope1, ( y3 - Intercept1 ) / Slope1, ( y4 - Intercept1 ) / Slope1
	elseif #Userdata == 6 then -- Given Given Slope1, Intercept1, and 2 points on the line. 
		Slope1, Intercept1, Slope2, Intercept2 = Userdata[1], Userdata[2], GetSlope( Userdata[3], Userdata[4], Userdata[5], Userdata[6] ), GetIntercept( Userdata[3], Userdata[4], Userdata[5], Userdata[6] ) 
		y1, y2, y3, y4 = Slope1 * 1 + Intercept1, Slope1 * 2 + Intercept1, Userdata[4], Userdata[6]
		x1, x2, x3, x4 = ( y1 - Intercept1 ) / Slope1, ( y2 - Intercept1 ) / Slope1, Userdata[3], Userdata[5]
	elseif #Userdata == 8 then -- Given 2 points on line 1 and 2 points on line 2.
		Slope1, Intercept1, Slope2, Intercept2 = GetSlope( Userdata[1], Userdata[2], Userdata[3], Userdata[4] ), GetIntercept( Userdata[1], Userdata[2], Userdata[3], Userdata[4] ), GetSlope( Userdata[5], Userdata[6], Userdata[7], Userdata[8] ), GetIntercept( Userdata[5], Userdata[6], Userdata[7], Userdata[8] ) 
		x1, y1, x2, y2, x3, y3, x4, y4 = unpack( Userdata )
	end
	
	if not Slope1 then 
		x = x1
		y = Slope2 * x + Intercept2
	elseif not Slope2 then
		x = x3
		y = Slope1 * x + Intercept1
	elseif Slope1 == Slope2 then 
		return false
	else
		x = ( -Intercept1 + Intercept2 ) / ( Slope1 - Slope2 )
		y = Slope1 * x + Intercept1
	end
	
	return x, y
end

local function GetClosestPoint( px, py, ... )
	local Userdata = CheckUserdata( ... )
	local x1, y1, x2, y2, Slope, Intercept
	local x, y
	
	if #Userdata == 4 then
		x1, y1, x2, y2 = unpack( Userdata )
		Slope, Intercept = GetSlope( x1, y1, x2, y2 ), GetIntercept( x1, y1, x2, y2 )
	elseif #Userdata == 2 then
		Slope, Intercept = unpack( Userdata )
	end
	
	if not Slope then
		x, y = x1, PerpendicularY
	elseif Slope == 0 then
		x, y = PerpendicularX, y1
	else
		PerpendicularSlope = GetPerpendicularSlope( Slope )
		PerpendicularIntercept = GetIntercept( PerpendicularX, PerpendicularY, PerpendicularSlope )
		x, y = GetIntersection( Slope, Intercept, PerpendicularSlope, PerpendicularIntercept )
	end
	
	return x, y
end

local function GetSegmentIntersection( x1, y1, x2, y2, ... )
	local Userdata = CheckUserdata( ... )
	
	local Slope1, Intercept1
	local Slope2, Intercept2 = GetSlope( x1, y1, x2, y2 ), GetIntercept( x1, y1, x2, y2 )
	local x, y
	
	if #Userdata == 2 then 
		Slope1, Intercept1 = Userdata[1], Userdata[2]
	else
		Slope1, Intercept1 = GetSlope( unpack( Userdata ) ), GetIntercept( unpack( Userdata ) )
	end
	
	if not Slope1 then
		x, y = Userdata[1], Slope2 * Userdata[1] + Intercept2
	elseif not Slope2 then
		x, y = x1, Slope1 * x1 + Intercept1
	else
		x, y = GetIntersection( Slope1, Intercept1, Slope2, Intercept2 )
	end
	
	local Length1, Length2 = GetLength( x1, y1, x, y ), GetLength( x2, y2, x, y )
	local Distance = GetLength( x1, y1, x2, y2 )
	
	if Length1 <= Distance and Length2 <= Distance then return x, y else return false end
end

-- Line Segment
local function CheckSegmentPoint( x1, y1, x2, y2, x3, y3 )
	local Slope, Intercept = GetSlope( x1, y1, x2, y2 ), GetIntercept( x1, y1, x2, y2 )
	
	if not Slope then
		if x1 ~= x3 then return false end
		local Length = GetLength( x1, y1, x2, y2 )
		local Distance1 = GetLength( x1, y1, x3, y3 )
		local Distance2 = GetLength( x2, y2, x3, y3 )
		if Distance1 > Length or Distance2 > Length then return false end
		return true
	elseif y3 == Slope * x3 + Intercept then
		local Length = GetLength( x1, y1, x2, y2 )
		local Distance1 = GetLength( x1, y1, x3, y3 )
		local Distance2 = GetLength( x2, y2, x3, y3 )
		if Distance1 > Length or Distance2 > Length then return false end
		return true
	else
		return false
	end
end

local function SegmentsIntersect( x1, y1, x2, y2, x3, y3, x4, y4 )
	local Slope1, Intercept1 = GetSlope( x1, y1, x2, y2 ), GetIntercept( x1, y1, x2, y2 )
	local Slope2, Intercept2 = GetSlope( x3, y3, x4, y4 ), GetIntercept( x3, y3, x4, y4 )
	
	if Slope1 == Slope2 and Slope1 then 
		if Intercept1 == Intercept2 then 
			local x = { x1, x2, x3, x4 }
			local y = { y1, y2, y3, y4 }
			local OriginalY = { y1, y2, y3, y4 }
			
			local Length1, Length2 = GetLength( x[1], y[1], x[2], y[2] ), GetLength( x[3], y[3], x[4], y[4] )
			
			local LargestX, LargestXReference = SortWithReference( x, function ( Value1, Value2 ) return Value1 > Value2 end ) 
			local LargestY, LargestYReference = SortWithReference( y, function ( Value1, Value2 ) return Value1 > Value2 end ) 
			local SmallestX, SmallestXReference = SortWithReference( x, function ( Value1, Value2 ) return Value1 < Value2 end ) 
			local SmallestY, SmallestYReference = SortWithReference( y, function ( Value1, Value2 ) return Value1 < Value2 end ) 
			
			table.remove( x, LargestXReference )
			table.remove( x, SmallestXReference )
			table.remove( y, LargestYReference )
			table.remove( y, SmallestYReference )
			
			local Distance = GetLength( x[1], y[1], x[2], y[2] )
			if Distance > Length1 or Distance > Length2 then return false end
			
			local Length1 = GetLength( x[1], OriginalY[1], x[1], OriginalY[2] )
			local Length2 = GetLength( x[1], OriginalY[3], x[1], OriginalY[4] )
			local Length3 = GetLength( x[1], y[1], x[2], y[2] )
			
			if Length3 >= Length1 or Length3 >= Length2 then return false end
			return x[1], y[1], x[2], y[2]
		else
			return false
		end
	end
	
	local x, y
	
	if not Slope1 and not Slope2 then
		if x1 ~= x3 then return false end
		
		local x = { x1, x2, x3, x4 }
		local y = { y1, y2, y3, y4 }

		local OriginalY = { y1, y2, y3, y4 }
		
		local Length1, Length2 = GetLength( x[1], y[1], x[2], y[2] ), GetLength( x[3], y[3], x[4], y[4] )
		
		local LargestX, LargestXReference = SortWithReference( x, function ( Value1, Value2 ) return Value1 > Value2 end ) 
		local LargestY, LargestYReference = SortWithReference( y, function ( Value1, Value2 ) return Value1 > Value2 end ) 
		local SmallestX, SmallestXReference = SortWithReference( x, function ( Value1, Value2 ) return Value1 < Value2 end ) 
		local SmallestY, SmallestYReference = SortWithReference( y, function ( Value1, Value2 ) return Value1 < Value2 end ) 
		
		table.remove( x, LargestXReference )
		table.remove( x, SmallestXReference )
		table.remove( y, LargestYReference )
		table.remove( y, SmallestYReference )
		
		local Distance = GetLength( x[1], y[1], x[2], y[2] )
		if Distance > Length1 or Distance > Length2 then return false end
		
		local Length1 = GetLength( x[1], OriginalY[1], x[1], OriginalY[2] )
		local Length2 = GetLength( x[1], OriginalY[3], x[1], OriginalY[4] )
		local Length3 = GetLength( x[1], y[1], x[2], y[2] )
		
		if Length3 >= Length1 or Length3 >= Length2 then return false end
		return x[1], y[1], x[2], y[2]
	elseif not Slope1 then
		x = x2
		y = Slope2 * x + Intercept2
		
		local Length1 = GetLength( x1, y1, x2, y2 )
		local Length2 = GetLength( x3, y3, x4, y4 )
		local Distance1 = GetLength( x1, y1, x, y )
		local Distance2 = GetLength( x2, y2, x, y )
		local Distance3 = GetLength( x3, y3, x, y )
		local Distance4 = GetLength( x4, y4, x, y )
		
		if ( Distance1 > Length1 ) or ( Distance2 > Length1 ) or ( Distance3 > Length2 ) or ( Distance4 > Length2 ) then 
			return false 
		end
	elseif not Slope2 then
		x = x4
		y = Slope1 * x + Intercept1
		
		local Length1 = GetLength( x1, y1, x2, y2 )
		local Length2 = GetLength( x3, y3, x4, y4 )
		local Distance1 = GetLength( x1, y1, x, y )
		local Distance2 = GetLength( x2, y2, x, y )
		local Distance3 = GetLength( x3, y3, x, y )
		local Distance4 = GetLength( x4, y4, x, y )
		
		if ( Distance1 > Length1 ) or ( Distance2 > Length1 ) or ( Distance3 > Length2 ) or ( Distance4 > Length2 ) then return false end
	else
		x, y = GetIntersection( Slope1, Intercept1, Slope2, Intercept2 )
		if not x then return false end
		
		local Length1, Length2 = GetLength( x1, y1, x2, y2 ), GetLength( x3, y3, x4, y4 )
		local Distance1 = GetLength( x1, y1, x, y )
		if Distance1 > Length1 then return false end
		
		local Distance2 = GetLength( x2, y2, x, y )
		if Distance2 > Length1 then return false end
		
		local Distance3 = GetLength( x3, y3, x, y )
		if Distance3 > Length2 then return false end
		
		local Distance4 = GetLength( x4, y4, x, y )
		if Distance4 > Length2 then return false end
	end
	
	return x, y
end

-- Polygon
function GetTriangleHeight( base, ... )
	local Userdata = CheckUserdata( ... )
	local Area = 0
	local Intercept = 0

	if #Userdata == 1 then Area = Userdata[1] else Area = GetPolygonArea( Userdata ) end
	
	return ( 2 * Area ) / base, Area
end

local function GetSignedPolygonArea( ... ) 
	local Userdata = CheckUserdata( ... )
	local Points = {}
	
	for Index = 1, #Userdata, 2 do
		Points[#Points + 1] = { Userdata[a], Userdata[Index + 1] } 
	end
	
	Points[#Points + 1] = {}
	Points[#Points][1], Points[#Points][2] = Points[1][1], Points[1][2]
	return ( .5 * GetSummation( 1, #Points, 
		function( Index ) 
			if Points[Index + 1] then 
				return ( ( Points[Index][1] * Points[Index + 1][2] ) - ( Points[Index + 1][1] * Points[Index][2] ) ) 
			else 
				return ( ( Points[Index][1] * Points[1][2] ) - ( Points[1][1] * Points[Index][2] ) )
			end 
		end 
	) )
end

local function GetPolygonArea( ... ) 
	return math.abs( GetSignedPolygonArea( ... ) )
end

local function GetPolygonCentroid( ... ) 
	local Userdata = CheckUserdata( ... )
	
	local Points = {}
	for Index = 1, #Userdata, 2 do
		table.insert( Points, { Userdata[Index], Userdata[Index + 1] } )
	end
	
	Points[#Points + 1] = {}
	Points[#Points][1], Points[#Points][2] = Points[1][1], Points[1][2]
	
	local Area = GetSignedArea( Userdata ) -- Needs to be signed here in case points are counter-clockwise. 
	
	local CentroidX = ( 1 / ( 6 * Area ) ) * ( GetSummation( 1, #Points, 
		function( Index ) 
			if Points[Index + 1] then
				return ( ( Points[Index][1] + Points[Index + 1][1] ) * ( ( Points[Index][1] * Points[Index + 1][2] ) - ( Points[Index + 1][1] * Points[Index][2] ) ) )
			else
				return ( ( Points[Index][1] + Points[1][1] ) * ( ( Points[Index][1] * Points[1][2] ) - ( Points[1][1] * Points[Index][2] ) ) )
			end
		end
	) )
	
	local CentroidY = ( 1 / ( 6 * Area ) ) * ( GetSummation( 1, #Points, 
		function( Index ) 
			if Points[Index + 1] then
				return ( ( Points[Index][2] + Points[Index + 1][2] ) * ( ( Points[Index][1] * Points[Index + 1][2] ) - ( Points[Index + 1][1] * Points[Index][2] ) ) )
			else
				return ( ( Points[Index][2] + Points[1][2] ) * ( ( Points[Index][1] * Points[1][2] ) - ( Points[1][1] * Points[Index][2] ) ) )
			end
		end 
	) )

	return CentroidX, CentroidY
end

function CheckPointOnPolygon( PointX, PointY, ... )
	local Userdata = {}
	local x = {}
	local y = {}
	local Slopes = {}
	
	if type( ... ) ~= 'table' then Userdata = { ... } else Userdata = ... end
	
	for Index = 1, #Userdata, 2 do
		table.insert( x, Userdata[Index] )
		table.insert( y, Userdata[Index + 1] )
	end
	
	for Index = 1, #x do
		local Slope
		if Index ~= #x then
			Slope = ( y[Index] - y[Index + 1] ) / ( x[Index] - x[Index + 1] )
		else 
			Slope = ( y[Index] - y[1] ) / ( x[Index] - x[1] )
		end
		Slopes[#Slopes + 1] = Slope
	end
	
	local LowestX = math.min( unpack( x ) )
	local LargestX = math.max( unpack( x ) )
	local LowestY = math.min( unpack( y ) )
	local LargestY = math.max( unpack( y ) )
	
	if PointX < LowestX or PointX > LargestX or PointY < LowestY or PointY > LargestY then return false end
	
	local Count = 0
	
	local function Wrap( Number, Limit )
		if Number > Limit then return Number - Limit end
		return Number
	end
	
	for Index = 1, #Slopes do
		if Index ~= #Slopes then
			local x1, x2 = x[Index], x[Index + 1]
			local y1, y2 = y[Index], y[Index + 1]
			if PointY == y1 or PointY == y2 then 
				if y[ Wrap( Index + 2, #y ) ] ~= PointY and y[Wrap( Index + 3, #y )] ~= PointY then
					Count = Count + 1
				end
			elseif SegmentsIntersect( x1, y1, x2, y2, PointX, PointY, LowestX, PointY ) then 
				Count = Count + 1 
			end
		else
			local x1, x2 = x[Index], x[1]
			local y1, y2 = y[Index], y[1]
			if PointY == y1 or PointY == y2 then 
				if y[Wrap( Index + 2, #y )] ~= PointY and y[Wrap( Index + 3, #y )] ~= PointY then
					Count = Count + 1
				end
			elseif SegmentsIntersect( x1, y1, x2, y2, PointX, PointY, LowestX, PointY ) then 
				Count = Count + 1 
			end
		end
	end

	return math.floor( Count / 2 ) ~= Count / 2 and true
end

local function LineIntersectsPolygon( x1, y1, x2, y2, ... )
	local Userdata = CheckUserdata( ... )

	if CheckPointOnPolygon( x1, y1, Userdata ) then return true end
	if CheckPointOnPolygon( x2, y2, Userdata ) then return true end
	
	for Index = 1, #Userdata, 2 do
		if CheckSegmentPoint( x1, y1, x2, y2, Userdata[Index], Userdata[Index + 1] ) then return true end
		if Userdata[Index + 2] then
			if SegmentsIntersect( Userdata[Index], Userdata[Index + 1], Userdata[Index + 2], Userdata[Index + 3], x1, y1, x2, y2 ) then return true end
		else
			if SegmentsIntersect( Userdata[Index], Userdata[Index + 1], Userdata[1], Userdata[2], x1, y1, x2, y2 ) then return true end
		end
	end
	
	return false
end

local function PolygonIntersectsPolygon( Polygon1, Polygon2 )
	for Index = 1, #Polygon1, 2 do
		if Polygon1[Index + 2] then
			if LineIntersectsPolygon( Polygon1[Index], Polygon1[Index + 1], Polygon1[Index + 2], Polygon1[Index + 3], Polygon2 ) then return true end
		else
			if LineIntersectsPolygon( Polygon1[Index], Polygon1[Index + 1], Polygon1[1], Polygon1[2], Polygon2 ) then return true end
		end
	end
	
	for Index = 1, #Polygon2, 2 do
		if Polygon2[Index + 2] then
			if LineIntersectsPolygon( Polygon2[Index], Polygon2[Index + 1], Polygon2[Index + 2], Polygon2[Index + 3], Polygon1 ) then return true end
		else
			if LineIntersectsPolygon( Polygon2[Index], Polygon2[Index + 1], Polygon2[1], Polygon2[2], Polygon1 ) then return true end
		end
	end	
	
	return false
end

local function PolygonIntersectsCircle( x, y, Radius, ... )
	local Userdata = CheckUserdata( ... )
	
	if CheckPointOnPolygon( x, y, Userdata ) then return true end
	
	for Index = 1, #Userdata, 2 do
		if Userdata[Index + 2] then 
			if IsSegmentSecantToCircle( x, y, Radius, Userdata[Index], Userdata[Index + 1], Userdata[Index + 2], Userdata[Index + 3] ) then return IsSegmentSecantToCircle( x, y, Radius, Userdata[Index], Userdata[Index + 1], Userdata[Index + 2], Userdata[Index + 3] ) end
		else
			if IsSegmentSecantToCircle( x, y, Radius, Userdata[Index], Userdata[Index + 1], Userdata[1], Userdata[2] ) then return IsSegmentSecantToCircle( x, y, Radius, Userdata[Index], Userdata[Index + 1], Userdata[1], Userdata[2] ) end
		end
	end
	
	return false
end

-- Circle
local function GetCircleArea( Radius )
	return math.pi * ( Radius ^ 2 )
end

local function CheckPointOnCircle( CircleX, CircleY, Radius, x, y )
	return ( x - CircleX ) ^ 2 + ( y - CircleY ) ^ 2 == Radius ^ 2 
end

local function GetCircleCircumference( Radius )
	return 2 * math.pi * Radius
end

local function IsLineSecantToCircle( CircleX, CircleY, Radius, ... )
	local Userdata = CheckUserdata( ... )
	
	local Slope, Intercept = 0, 0
	
	if #Userdata == 2 then 
		Slope, Intercept = Userdata[1], Userdata[2] 
	else 
		Slope = GetSlope( Userdata[1], Userdata[2], Userdata[3], Userdata[4] ) 
		Intercept = GetIntercept( Userdata[1], Userdata[2], Slope ) 
	end
	
	local x1, y1, x2, y2
	if #Userdata == 4 then x1, y1, x2, y2 = unpack( Userdata ) end
	
	if Slope then 
		local a = ( 1 + Slope ^ 2 )
		local b = ( -2 * ( CircleX ) + ( 2 * Slope * Intercept ) - ( 2 * CircleY * Slope ) )
		local c = ( CircleX ^ 2 + Intercept ^ 2 - 2 * ( CircleY ) * ( Intercept ) + CircleY ^ 2 - Radius ^ 2 )
		
		x1, x2 = GetRootsOfQuadraticFactor( a, b, c )
		
		if not x1 then return false end
		
		y1 = Slope * x1 + Intercept
		y2 = Slope * x2 + Intercept
		
		if x1 == x2 and y1 == y2 then 
			return 'Tangent', x1, y1
		else 
			return 'Secant', x1, y1, x2, y2 
		end
	else
		-- Theory: *see Reference Pictures/Circle.png for information on how it works.
		local LengthToPoint1 = CircleX - x1
		local RemainingDistance = LengthToPoint1 - Radius
		local Intercept = math.sqrt( -( LengthToPoint1 ^ 2 - Radius ^ 2 ) )
		
		if -( LengthToPoint1 ^ 2 - Radius ^ 2 ) < 0 then return false end
		
		local BottomX, BottomY = x1, CircleY - Intercept
		local TopX, TopY = x1, CircleY + Intercept
		
		if TopY ~= BottomY then 
			return 'Secant', TopX, TopY, BottomX, BottomY 
		else 
			return 'Tangent', TopX, TopY 
		end
	end
end

local function IsSegmentSecantToCircle( CircleX, CircleY, Radius, x1, y1, x2, y2 )
	local Type, x3, y3, x4, y4 = IsLineSecantToCircle( CircleX, CircleY, Radius, x1, y1, x2, y2 )
	if not Type then return false end
	
	local Slope, Intercept = GetSlope( x1, y1, x2, y2 ), GetIntercept( x1, y1, x2, y2 )
	
	if Slope then 
		if IsPointInCircle( CircleX, CircleY, Radius, x1, y1 ) and IsPointInCircle( CircleX, CircleY, Radius, x2, y2 ) then -- Line-segment is fully in circle. 
			return true
		elseif x3 and x4 then
			if CheckSegmentPoint( x1, y1, x2, y2, x3, y3 ) and CheckSegmentPoint( x1, y1, x2, y2, x4, y4 ) then -- Both points are on line-segment. 
				return x3, y3, x4, y4
			elseif CheckSegmentPoint( x1, y1, x2, y2, x3, y3 ) then -- Only the first of the points is on the line-segment. 
				return x3, y3
			elseif CheckSegmentPoint( x1, y1, x2, y2, x4, y4 ) then -- Only the second of the points is on the line-segment. 
				return x4, y4
			else -- Neither of the points are on the line-segment (means that the segment is not on the circle or "encasing" the circle)
				local Length = GetLength( x1, y1, x2, y2 )
				
				local Distance1 = GetLength( x1, y1, x3, y3 )
				local Distance2 = GetLength( x2, y2, x3, y3 )
				local Distance3 = GetLength( x1, y1, x4, y4 )
				local Distance4 = GetLength( x2, y3, x4, y4 )
				
				if Length > Distance1 or Length > Distance2 or Length > Distance3 or Length > Distance4 then
					return false
				elseif Length < Distance1 and Length < Distance2 and Length < Distance3 and Length < Distance4 then 
					return false 
				else
					return true
				end
			end
		elseif not x4 then -- Is a tangent. 
			if CheckSegmentPoint( x1, y1, x2, y2, x3, y3 ) then
				return x3, y3
			else -- Neither of the points are on the line-segment (means that the segment is not on the circle or "encasing" the circle).
				local Length = GetLength( x1, y1, x2, y2 )
				local Distance1 = GetLength( x1, y1, x3, y3 )
				local Distance2 = GetLength( x2, y2, x3, y3 )
				
				if Length > Distance1 or Length > Distance2 then 
					return false
				elseif Length < Distance1 and Length < Distance2 then 
					return false 
				else
					return true
				end
			end
		end
	else
		-- Theory: *see Reference Images/Circle.png for information on how it works.
		local LengthToPoint1 = CircleX - x1
		local RemainingDistance = LengthToPoint1 - Radius
		local Intercept = math.sqrt( -( LengthToPoint1 ^ 2 - Radius ^ 2 ) )
		
		if -( LengthToPoint1 ^ 2 - Radius ^ 2 ) < 0 then return false end
		
		local TopX, TopY = x1, CircleY - Intercept
		local BottomX, BottomY = x1, CircleY + Intercept
		
		local Length = GetLength( x1, y1, x2, y2 )
		local Distance1 = GetLength( x1, y1, TopX, TopY )
		local Distance2 = GetLength( x2, y2, TopX, TopY )
		
		if BottomY ~= TopY then 
			if CheckSegmentPoint( x1, y1, x2, y2, TopX, TopY ) and CheckSegmentPoint( x1, y1, x2, y2, BottomX, BottomY ) then
				return TopX, TopY, BottomX, BottomY
			elseif CheckSegmentPoint( x1, y1, x2, y2, TopX, TopY ) then
				return TopX, TopX
			elseif CheckSegmentPoint( x1, y1, x2, y2, BottomX, BottomY ) then
				return BottomX, BottomY
			else
				return false
			end
		else 
			if CheckSegmentPoint( x1, y1, x2, y2, TopX, TopY ) then
				return TopX, TopY
			else
				return false
			end
		end
	end
end

local function CircleIntersectsCircle( Circle1CenterX, Circle1CenterY, Radius1, Circle2CenterX, Circle2CenterY, Radius2 )
	local Distance = GetLength( Circle1CenterX, Circle1CenterY, Circle2CenterX, Circle2CenterY )
	if Distance > Radius1 + Radius2 then return false end
	if Distance == 0 and Radius1 == Radius2 then return true end
	
	local a = ( Radius1 ^ 2 - Radius2 ^ 2 + Distance ^ 2 ) / ( 2 * Distance )
	local h = math.sqrt( Radius1 ^ 2 - a ^ 2 )
	
	local p2x = Circle1CenterX + a * ( Circle2CenterX - Circle1CenterX ) / Distance
	local p2y = Circle1CenterY + a * ( Circle2CenterY - Circle1CenterY ) / Distance
	local p3x = p2x + h * ( Circle2CenterY - Circle1CenterY ) / Distance
	local p3y = p2y - h * ( Circle2CenterX - Circle1CenterX ) / Distance
	local p4x = p2x - h * ( Circle2CenterY - Circle1CenterY ) / Distance
	local p4y = p2y + h * ( Circle2CenterX - Circle1CenterX ) / Distance
	
	if Distance == Radius1 + Radius2 then return p3x, p3y end
	return p3x, p3y, p4x, p4y 
end

local function IsPointInCircle( CircleX, CircleY, Radius, x, y )
	return GetLength( CircleX, CircleY, x, y ) <= Radius
end

-- Statistics
local function GetMean( ... )
	local Userdata = CheckUserdata( ... )
	
	local Mean = 0
	for Index = 1, #Userdata do
		Mean = Mean + Userdata[Index]
	end
	Mean = Mean / #Userdata
	
	return Mean
end

local function GetMedian( ... )
	local Userdata = CheckUserdata( ... )
	
	table.sort( Userdata )
	
	if #Userdata % 2 == 0 then
		Userdata = ( Userdata[math.floor( #Userdata / 2 )] + Userdata[math.floor( #Userdata / 2 + 1 )] ) / 2
	else
		Userdata =  Userdata[#Userdata / 2 + .5]
	end
	
	return Userdata
end

local function GetMode( ... ) 
	local Userdata = CheckUserdata( ... )

	table.sort( Userdata )
	local Number = { { Userdata[1] } }
	for Index = 2, #Userdata do
		if Userdata[Index] == Number[#Number][1] then 
			table.insert( Number[#Number], Userdata[Index] ) 
		else 
			table.insert( Number, { Userdata[Index] } ) 
		end
	end
	
	local Large = { { #Number[1], Number[1][1] } }
	for Index = 2, #Number do
		if #Number[Index] > Large[1][1] then
			for NextIndex = #Large, 1, -1 do
				table.remove( Large, NextIndex )
			end
		table.insert( Large, { #Number[Index], Number[Index][1] } )
		elseif #Number[Index] == Large[1][1] then
			table.insert( Large, { #Number[Index], Number[Index][1] } )
		end
	end
	
	if #Large < 1 then 
		return false 
	elseif #Large > 1 then 
		return false 
	else 
		return Large[1][2], Large[1][1] 
	end
end

local function GetRange( ... )
	local Userdata = {}
	
	local Upper, Lower = math.max( unpack( Userdata ) ), math.min( unpack( Userdata ) )
	
	return Upper - Lower
end

-- Math (homeless functions)
local function GetRoot( Number, Root )
	return Number ^ ( 1 / Root )
end

local function IsPrime( Number )	
	if Number < 2 then return false end
		
	for Index = 2, math.sqrt( Number ) do
		if Number % Index == 0 then
			return false
		end
	end
	
	return true
end

local function Round( Number )
	local ReturnedValue 
	
	local UpperNumber = math.ceil( Number )
	local LowerNumber = math.floor( Number )
	
	local UpperDifferance = UpperNumber - Number
	local LowerDifference = Number - LowerNumber
	
	if UpperNumber == Number then
		ReturnedValue = Number
	else
		if UpperDifferance <= LowerDifference then ReturnedValue = UpperNumber elseif LowerDifference < UpperDifferance then ReturnedValue = LowerNumber end
	end
	
	return ReturnedValue
end

local function GetSummation( Start, Stop, Function )
	if Stop == 1 / 0 or Stop == -1 / 0 then return false end
	
	local ReturnedValue = {}
	local Value = 0
	
	for Index = Start, Stop do
		local New = Function( Index, ReturnedValue )
		
		ReturnedValue[Index] = New
		Value = Value + New
	end
	
	return Value
end

local function GetPercentOfChange( Old, New )
	if Old == 0 then 
		return false
	else 
		return ( New - Old ) / math.abs( Old ) 
	end
end

local function GetPercent( Percent, Number )
	return Percent * math.abs( Number ) + Number 
end

local function GetRootsOfQuadraticFactor( a, b, c )
	local Discriminant = b ^ 2 - ( 4 * a * c )
	if Discriminant < 0 then return false end
	
	Discriminant = math.sqrt( Discriminant )
	
	return ( -b - Discriminant ) / ( 2 * a ), ( -b + Discriminant ) / ( 2 * a )
end

local function GetAngle( ... )
	local Userdata = CheckUserdata( ... )
	local Angle = 0
	
	if #Userdata <= 5 then
		local x1, y1, x2, y2, Direction = unpack( Userdata )
		
		if not Direction or Direction == 'up' then Direction = math.rad( 90 ) 
			elseif Direction == 'right' then Direction = 0 
			elseif Direction == 'down' then Direction = math.rad( -90 )
			elseif Direction == 'left' then Direction = math.rad( -180 )
		end
		
		local dx, dy = x2 - x1, y2 - y1
		Angle = math.atan2( dy, dx ) + Direction
	elseif #Userdata == 6 then
		local x1, y1, x2, y2, x3, y3 = unpack( Userdata )
		
		local AB = GetLength( x1, y1, x2, y2 )
		local BC = GetLength( x2, y2, x3, y3 )
		local AC = GetLength( x1, y1, x3, y3 )
		
		Angle = math.acos( ( BC * BC + AB * AB - AC * AC ) / ( 2 * BC * AB ) )
	end
	
	return Angle
end

-- Shape
local function NewShape( ... )
	local Userdata = CheckUserdata( ... )
	
	if #Userdata == 3 then
		Userdata.Type = 'Circle'
		Userdata.x, Userdata.y, Userdata.radius = unpack( Userdata )
		Userdata.Area = GetCircleArea( Userdata.radius )
	elseif #Userdata == 4 then
		Userdata.Type = 'Line'
		Userdata.x1, Userdata.y1, Userdata.x2, Userdata.y2 = unpack( Userdata )
		Userdata.GetSlope = GetSlope( unpack( Userdata ) )
		Userdata.GetIntercept = GetIntercept( unpack( Userdata ) )
	else
		Userdata.Type = 'Polygon'
		Userdata.Area = GetPolygonArea( Userdata )
		Userdata.Points = Userdata
	end
	
	Userdata.Collided = false
	Userdata.Index = #MLib.Shape.User + 1
	Userdata.Removed = false
	
	setmetatable( Userdata, MLib.Shape )
	table.insert( MLib.Shape.User, Userdata )
	
	return Userdata
end

local function CheckCollisions( Self, ... )
	local Userdata = { ... }
	
	if Type( Self ) == 'table' then -- Using Index Self:table. 
		if #Userdata == 0 then -- No arguments (colliding with everything). 
			for Index = 1, #MLib.Shape.User do
				if Index ~= Self.Index then 
					local Collided = false
					local Shape = MLib.Shape.User[Index]
					if not Shape.Removed and not Self.Removed then 
						if Self.Type == 'Line' then 
							if Shape.Type == 'Line' then
								if SegmentsIntersect( Self.x1, Self.y1, Self.x2, Self.y2, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
							elseif Shape.Type == 'Polygon' then
								if LineIntersectsPolygon( Self.x1, Self.y1, Self.x2, Self.y2, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
							elseif Shape.Type == 'Circle' then
								if IsSegmentSecantToCircle( Shape.x, Shape.y, Shape.radius, Self.x1, Self.y1, Self.x2, Self.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
							end
						elseif Self.Type == 'Polygon' then
							if Shape.Type == 'Line' then
								if LineIntersectsPolygon( Shape.x1, Shape.y1, Shape.x2, Shape.y2, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
							elseif Shape.Type == 'Polygon' then
								if PolygonIntersectsPolygon( Self.Points, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
							elseif Shape.Type == 'Circle' then
								if PolygonIntersectsCircle( Shape.x, Shape.y, Shape.radius, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
							end
						elseif Self.Type == 'Circle' then
							if Shape.Type == 'Line' then
								if IsSegmentSecantToCircle( Self.x, Self.y, Self.radius, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
							elseif Shape.Type == 'Polygon' then
								if PolygonIntersectsCircle( Self.x, Self.y, Self.radius, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
							elseif Shape.Type == 'Circle' then
								if CircleIntersectsCircle( Self.x, Self.y, Self.radius, Shape.x, Shape.y, Shape.radius ) then Collided, Self.Collided, Shape.Collided = true, true end
							end
						end
					end
					if not Collided then Self.Collided = false end
				end
			end
		else -- Colliding with only certain things. 
			for Index = 1, #Userdata do
				local Collided = false
				local Shape = Userdata[Index]
				if not Shape.Removed and not Self.Removed then 
					if Self.Type == 'Line' then 
						if Shape.Type == 'Line' then
							if SegmentsIntersect( Self.x1, Self.y1, Self.x2, Self.y2, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
						elseif Shape.Type == 'Polygon' then
							if LineIntersectsPolygon( Self.x1, Self.y1, Self.x2, Self.y2, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
						elseif Shape.Type == 'Circle' then
							if IsSegmentSecantToCircle( Shape.x, Shape.y, Shape.radius, Self.x1, Self.y1, Self.x2, Self.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
						end
					elseif Self.Type == 'Polygon' then
						if Shape.Type == 'Line' then
							if LineIntersectsPolygon( Shape.x1, Shape.y1, Shape.x2, Shape.y2, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
						elseif Shape.Type == 'Polygon' then
							if PolygonIntersectsPolygon( Self.Points, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
						elseif Shape.Type == 'Circle' then
							if PolygonIntersectsCircle( Shape.x, Shape.y, Shape.radius, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
						end
					elseif Self.Type == 'Circle' then
						if Shape.Type == 'Line' then
							if IsSegmentSecantToCircle( Self.x, Self.y, Self.radius, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
						elseif Shape.Type == 'Polygon' then
							if PolygonIntersectsCircle( Self.x, Self.y, Self.radius, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
						elseif Shape.Type == 'Circle' then
							if CircleIntersectsCircle( Self.x, Self.y, Self.radius, Shape.x, Shape.y, Shape.radius ) then Collided, Self.Collided, Shape.Collided = true, true end
						end
					end
				end
				if not Collided then Self.Collided = false end
			end
		end
	else -- Not using Self:table. 
		local Userdata = { unpack( Userdata ) }
		if #Userdata == 0 then -- Checking all collisions. 
			for Index = 1, #MLib.Shape.User do
				local Self = MLib.Shape.User[Index]
				local Collided = false
				for Index2 = 1, #MLib.Shape.User do
					if Index ~= Index2 then 
						local Shape = MLib.Shape.User[Index2]
						if not Shape.Removed and not Self.Removed then 
							if Self.Type == 'Line' then 
								if Shape.Type == 'Line' then
									if SegmentsIntersect( Self.x1, Self.y1, Self.x2, Self.y2, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true, true end
								elseif Shape.Type == 'Polygon' then
									if LineIntersectsPolygon( Self.x1, Self.y1, Self.x2, Self.y2, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
								elseif Shape.Type == 'Circle' then
									if IsSegmentSecantToCircle( Shape.x, Shape.y, Shape.radius, Self.x1, Self.y1, Self.x2, Self.y2 ) then Collided, Self.Collided, Shape.Collided = true, true, true end
								end
							elseif Self.Type == 'Polygon' then
								if Shape.Type == 'Line' then
									if LineIntersectsPolygon( Shape.x1, Shape.y1, Shape.x2, Shape.y2, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
								elseif Shape.Type == 'Polygon' then
									if PolygonIntersectsPolygon( Self.Points, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
								elseif Shape.Type == 'Circle' then
									if PolygonIntersectsCircle( Shape.x, Shape.y, Shape.radius, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
								end
							elseif Self.Type == 'Circle' then
								if Shape.Type == 'Line' then
									if IsSegmentSecantToCircle( Self.x, Self.y, Self.radius, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true, true end
								elseif Shape.Type == 'Polygon' then
									if PolygonIntersectsCircle( Self.x, Self.y, Self.radius, Shape.Points ) then Self.Collided, Collided, Self.Collided, Shape.Collided = true, true, true end
								elseif Shape.Type == 'Circle' then
									if CircleIntersectsCircle( Self.x, Self.y, Self.radius, Shape.x, Shape.y, Shape.radius ) then Collided, Self.Collided, Shape.Collided = true, true, true end
								end
							end
						end
					end
				end
				if not Collided then Self.Collided = false end
			end
		else -- Checking only certain collisions
			for Index = 1, #Userdata do
				local Self = MLib.Shape.User[Index]
				local Collided = false
				for Index2 = 1, #MLib.Shape.User do
					if Self.Index ~= Userdata[Index2].Index then 
						local Shape = MLib.Shape.User[Index2]
						if not Shape.Removed and not Self.Removed then 
							if Self.Type == 'Line' then 
								if Shape.Type == 'Line' then
									if SegmentsIntersect( Self.x1, Self.y1, Self.x2, Self.y2, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
								elseif Shape.Type == 'Polygon' then
									if LineIntersectsPolygon( Self.x1, Self.y1, Self.x2, Self.y2, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
								elseif Shape.Type == 'Circle' then
									if IsSegmentSecantToCircle( Shape.x, Shape.y, Shape.radius, Self.x1, Self.y1, Self.x2, Self.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
								end
							elseif Self.Type == 'Polygon' then
								if Shape.Type == 'Line' then
									if LineIntersectsPolygon( Shape.x1, Shape.y1, Shape.x2, Shape.y2, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
								elseif Shape.Type == 'Polygon' then
									if PolygonIntersectsPolygon( Self.Points, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
								elseif Shape.Type == 'Circle' then
									if PolygonIntersectsCircle( Shape.x, Shape.y, Shape.radius, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
								end
							elseif Self.Type == 'Circle' then
								if Shape.Type == 'Line' then
									if IsSegmentSecantToCircle( Self.x, Self.y, Self.radius, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true end
								elseif Shape.Type == 'Polygon' then
									if PolygonIntersectsCircle( Self.x, Self.y, Self.radius, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true end
								elseif Shape.Type == 'Circle' then
									if CircleIntersectsCircle( Self.x, Self.y, Self.radius, Shape.x, Shape.y, Shape.radius ) then Collided, Self.Collided, Shape.Collided = true, true end
								end
							end
						end
					end
				end
				if not Collided then Self.Collided = false end
			end
		end
	end
end

local function Remove( Self, ... )
	local Userdata = { ... }
	
	if Type( Self ) == 'table' then
		MLib.Shape.User[Self.Index] = { Removed = false }
		
		if #Userdata > 0 then
			for Index = 1, #Userdata do
				MLib.Shape.User[Userdata[Index].Index] = { Removed = true }
			end
		end
	else
		if #Userdata > 0 then
			for Index = 1, #Userdata do
				MLib.Shape.User[Userdata[Index].Index] = { Removed = true }
			end
		else
			MLib.Shape.User = {}
		end
	end
end

local MLib = {
	Line = {
		GetLength = GetLength, 
		GetMidpoint = GetMidpoint, 
		GetSlope = GetSlope, 
		GetPerpendicularSlope = GetPerpendicularSlope, 
		GetPerpendicularBisector = GetPerpendicularBisector, 
		GetIntercept = GetIntercept, 
		GetIntersection = GetIntersection, 
		GetClosestPoint = GetClosestPoint, 
		GetSegmentIntersection = GetSegmentIntersection, 

		Segment = {
			CheckPoint = CheckSegmentPoint, 
			GetIntersection = SegmentsIntersect, 
		}, 
	}, 
	Polygon = {
		GetTriangleHeight = GetTriangleHeight, 
		GetArea = GetPolygonArea, 
		GetCentroid = GetPolygonCentroid, 
		CheckPoint = CheckPointOnPolygon, 
		LineIntersects = LineIntersectsPolygon, 
		PolygonIntersects = PolygonIntersectsPolygon, 
		CircleIntersects = PolygonIntersectsCircle, 
	}, 
	Circle = {
		GetArea = GetCircleArea, 
		CheckPoint = CheckPointOnCircle, 
		GetCircumference = GetCircleCircumference, 
		IsLineSecant = IsLineSecantToCircle, 
		IsSegementSecant = IsSegmentSecantToCircle, 
		CircleIntersects = CircleIntersectsCircle, 
		IsPointInCircle = IsPointInCircle, 
	}, 
	Statistics = {
		GetMean = GetMean, 
		GetMedian = GetMedian, 
		GetMode = GetMode, 
		GetRange = GetRange, 
	}, 
	Math = {
		GetRoot = GetRoot, 
		IsPrime = IsPrime, 
		Round = Round, 
		GetSummation = GetSummation, 
		GetPercentOfChange = GetPercentOfChange, 
		GetPercent = GetPercent, 
		GetRootsOfQuadratic = GetRootsOfQuadratic, 
		GetAngle = GetAngle, 
	}, 
	Shape = {
		NewShape = NewShape, 
		CheckCollisions = CheckCollisions, 
		Remove = Remove, 
		User = {}, 
	}, 
}
MLib.Shape.__index = MLib.Shape

return MLib