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

local MLib = {
	Line = {
		Segment = {}, 
	}, 
	Polygon = {}, 
	Circle = {}, 
	Statistics = {}, 
	Math = {}, 
	Shape = {
		User = {}, 
	}, 
}
MLib.Shape.__index = MLib.Shape

-- Local utility functions
local function CheckUserdata( ... )
	local Userdata = {}
	if type( ... ) ~= 'table' then Userdata = { ... } else Userdata = ... end
	return Userdata
end

local function SortWithReference( Table, Function )
    if #Table == 0 then return nil, nil end
    local Key, Value = 1, Table[1]
    for i = 2, #Table do
        if Function( Value, Table[i] ) then
            Key, Value = i, Table[i]
        end
    end
    return Value, Key
end

local function CheckFuzzy( Number1, Number2 )
	return ( Number1 - .00001 <= Number2 and Number2 <= Number1 + .00001 )
end

local function RemoveDuplicates( Table ) 
	for Index1 = #Table, 1, -1 do
		local First = Table[Index1]
		for Index2 = #Table, 1, -1 do
			local Second = Table[Index2]
			if Index1 ~= Index2 then
				if type( First[1] ) == 'number' and type( Second[1] ) == 'number' and type( First[2] ) == 'number' and type( Second[2] ) == 'number' then
					if CheckFuzzy( First[1], Second[1] ) and CheckFuzzy( First[2], Second[2] ) then
						table.remove( Table, Index1 )
					end
				elseif First[1] == Second[1] and First[2] == Second[2] then
					table.remove( Table, Index1 )
				end
			end
		end
	end
	return Table
end

-- Lines
function MLib.Line.GetLength( x1, y1, x2, y2 )
	return math.sqrt( ( x1 - x2 ) ^ 2 + ( y1 - y2 ) ^ 2 )
end

function MLib.Line.GetMidpoint( x1, y1, x2, y2 )
	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

function MLib.Line.GetSlope( x1, y1, x2, y2 )
	if x1 == x2 then return false end -- Technically it's infinity, but that's irrelevant. 
	return ( y1 - y2 ) / ( x1 - x2 )
end

function MLib.Line.GetPerpendicularSlope( ... )
	local Userdata = CheckUserdata( ... )
	local Slope
	
	if #Userdata ~= 1 then 
		Slope = MLib.Line.GetSlope( unpack( Userdata ) ) 
	else
		Slope = unpack( Userdata ) 
	end
	
	if Slope == 0 then return false end 
	if not Slope then return 0 end
	return -1 / Slope 
end

function MLib.Line.GetPerpendicularBisector( x1, y1, x2, y2 )
	local Slope = MLib.Line.GetSlope( x1, y1, x2, y2 )
	local MidpointX, MidpointY = MLib.Line.GetMidpoint( x1, y1, x2, y2 )
	return MidpointX, MidpointY, MLib.Line.GetPerpendicularSlope( Slope )
end

function MLib.Line.GetIntercept( x, y, ... )
	local Userdata = CheckUserdata( ... )
	local Slope = false
	
	if #Userdata == 1 then 
		Slope = Userdata[1] 
	else
		Slope = MLib.Line.GetSlope( x, y, unpack( Userdata ) ) 
	end
	
	if not Slope then return false end
	return y - Slope * x
end

function MLib.Line.GetIntersection( ... )
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
		Slope1, Intercept1, Slope2, Intercept2 = Userdata[1], Userdata[2], MLib.Line.GetSlope( Userdata[3], Userdata[4], Userdata[5], Userdata[6] ), MLib.Line.GetIntercept( Userdata[3], Userdata[4], Userdata[5], Userdata[6] ) 
		y1, y2, y3, y4 = Slope1 * 1 + Intercept1, Slope1 * 2 + Intercept1, Userdata[4], Userdata[6]
		x1, x2, x3, x4 = ( y1 - Intercept1 ) / Slope1, ( y2 - Intercept1 ) / Slope1, Userdata[3], Userdata[5]
	elseif #Userdata == 8 then -- Given 2 points on line 1 and 2 points on line 2.
		Slope1, Intercept1, Slope2, Intercept2 = MLib.Line.GetSlope( Userdata[1], Userdata[2], Userdata[3], Userdata[4] ), MLib.Line.GetIntercept( Userdata[1], Userdata[2], Userdata[3], Userdata[4] ), MLib.Line.GetSlope( Userdata[5], Userdata[6], Userdata[7], Userdata[8] ), MLib.Line.GetIntercept( Userdata[5], Userdata[6], Userdata[7], Userdata[8] ) 
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

function MLib.Line.GetClosestPoint( PerpendicularX, PerpendicularY, ... )
	local Userdata = CheckUserdata( ... )
	local x1, y1, x2, y2, Slope, Intercept
	local x, y
	
	if #Userdata == 4 then
		x1, y1, x2, y2 = unpack( Userdata )
		Slope, Intercept = MLib.Line.GetSlope( x1, y1, x2, y2 ), MLib.Line.GetIntercept( x1, y1, x2, y2 )
	elseif #Userdata == 2 then
		Slope, Intercept = unpack( Userdata )
	end
	
	if not Slope then
		x, y = x1, PerpendicularY
	elseif Slope == 0 then
		x, y = PerpendicularX, y1
	else
		local PerpendicularSlope = MLib.Line.GetPerpendicularSlope( Slope )
		local PerpendicularIntercept = MLib.Line.GetIntercept( PerpendicularX, PerpendicularY, PerpendicularSlope )
		x, y = MLib.Line.GetIntersection( Slope, Intercept, PerpendicularSlope, PerpendicularIntercept )
	end
	
	return x, y
end

function MLib.Line.GetSegmentIntersection( x1, y1, x2, y2, ... )
	local Userdata = CheckUserdata( ... )
	
	local Slope1, Intercept1
	local Slope2, Intercept2 = MLib.Line.GetSlope( x1, y1, x2, y2 ), MLib.Line.GetIntercept( x1, y1, x2, y2 )
	local x, y
	
	if #Userdata == 2 then 
		Slope1, Intercept1 = Userdata[1], Userdata[2]
	else
		Slope1, Intercept1 = MLib.Line.GetSlope( unpack( Userdata ) ), MLib.Line.GetIntercept( unpack( Userdata ) )
	end
	
	if not Slope1 then
		x, y = Userdata[1], Slope2 * Userdata[1] + Intercept2
	elseif not Slope2 then
		x, y = x1, Slope1 * x1 + Intercept1
	else
		x, y = MLib.Line.GetIntersection( Slope1, Intercept1, Slope2, Intercept2 )
	end
	
	local Length1, Length2 = MLib.Line.GetLength( x1, y1, x, y ), MLib.Line.GetLength( x2, y2, x, y )
	local Distance = MLib.Line.GetLength( x1, y1, x2, y2 )
	
	if Length1 <= Distance and Length2 <= Distance then return x, y else return false end
end

-- Line Segment
function MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, x3, y3 )
	local Slope, Intercept = MLib.Line.GetSlope( x1, y1, x2, y2 ), MLib.Line.GetIntercept( x1, y1, x2, y2 )
	
	if not Slope then
		if x1 ~= x3 then return false end
		local Length = MLib.Line.GetLength( x1, y1, x2, y2 )
		local Distance1 = MLib.Line.GetLength( x1, y1, x3, y3 )
		local Distance2 = MLib.Line.GetLength( x2, y2, x3, y3 )
		if Distance1 > Length or Distance2 > Length then return false end
		return true
	elseif y3 == Slope * x3 + Intercept then
		local Length = MLib.Line.GetLength( x1, y1, x2, y2 )
		local Distance1 = MLib.Line.GetLength( x1, y1, x3, y3 )
		local Distance2 = MLib.Line.GetLength( x2, y2, x3, y3 )
		if Distance1 > Length or Distance2 > Length then return false end
		return true
	else
		return false
	end
end

function MLib.Line.Segment.GetIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )
	local Slope1, Intercept1 = MLib.Line.GetSlope( x1, y1, x2, y2 ), MLib.Line.GetIntercept( x1, y1, x2, y2 )
	local Slope2, Intercept2 = MLib.Line.GetSlope( x3, y3, x4, y4 ), MLib.Line.GetIntercept( x3, y3, x4, y4 )
	
	if Slope1 == Slope2 and Slope1 then 
		if Intercept1 == Intercept2 then 
			local x = { x1, x2, x3, x4 }
			local y = { y1, y2, y3, y4 }
			local OriginalX = { x1, x2, x3, x4 }
			local OriginalY = { y1, y2, y3, y4 }
			
			local Length1, Length2 = MLib.Line.GetLength( x[1], y[1], x[2], y[2] ), MLib.Line.GetLength( x[3], y[3], x[4], y[4] )
			
			local LargestX, LargestXReference = SortWithReference( x, function ( Value1, Value2 ) return Value1 > Value2 end ) 
			table.remove( x, LargestXReference )
			local LargestY, LargestYReference = SortWithReference( y, function ( Value1, Value2 ) return Value1 > Value2 end ) 
			table.remove( y, LargestYReference )
			local SmallestX, SmallestXReference = SortWithReference( x, function ( Value1, Value2 ) return Value1 < Value2 end ) 
			table.remove( x, SmallestXReference )
			local SmallestY, SmallestYReference = SortWithReference( y, function ( Value1, Value2 ) return Value1 < Value2 end ) 
			table.remove( y, SmallestYReference )
			
			local Distance = MLib.Line.GetLength( x[1], y[1], x[2], y[2] )
			if Distance > Length1 or Distance > Length2 then return false end

			local Length3 = MLib.Line.GetLength( OriginalX[LargestXReference], OriginalY[LargestXReference], OriginalX[SmallestXReference], OriginalY[SmallestXReference] )
			
			if Length3 >= Length1 or Length3 >= Length2 then return false end
			
			local _, Index = SortWithReference( x, function ( Value1, Value2 ) return Value1 > Value2 end ) 
			if Index == 1 then return x[1], y[1], x[2], y[2]
			else return x[2], y[2], x[1], y[1] end
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
		
		local Length1, Length2 = MLib.Line.GetLength( x[1], y[1], x[2], y[2] ), MLib.Line.GetLength( x[3], y[3], x[4], y[4] )
		
		local LargestX, LargestXReference = SortWithReference( x, function ( Value1, Value2 ) return Value1 > Value2 end ) 
		local LargestY, LargestYReference = SortWithReference( y, function ( Value1, Value2 ) return Value1 > Value2 end ) 
		local SmallestX, SmallestXReference = SortWithReference( x, function ( Value1, Value2 ) return Value1 < Value2 end ) 
		local SmallestY, SmallestYReference = SortWithReference( y, function ( Value1, Value2 ) return Value1 < Value2 end ) 
		
		table.remove( x, LargestXReference )
		table.remove( x, SmallestXReference )
		table.remove( y, LargestYReference )
		table.remove( y, SmallestYReference )
		
		local Distance = MLib.Line.GetLength( x[1], y[1], x[2], y[2] )
		if Distance > Length1 or Distance > Length2 then return false end
		
		local Length1 = MLib.Line.GetLength( x[1], OriginalY[1], x[1], OriginalY[2] )
		local Length2 = MLib.Line.GetLength( x[1], OriginalY[3], x[1], OriginalY[4] )
		local Length3 = MLib.Line.GetLength( x[1], y[1], x[2], y[2] )
		
		if Length3 >= Length1 or Length3 >= Length2 then return false end
		return x[1], y[1], x[2], y[2]
	elseif not Slope1 then
		x = x2
		y = Slope2 * x + Intercept2
		
		local Length1 = MLib.Line.GetLength( x1, y1, x2, y2 )
		local Length2 = MLib.Line.GetLength( x3, y3, x4, y4 )
		local Distance1 = MLib.Line.GetLength( x1, y1, x, y )
		local Distance2 = MLib.Line.GetLength( x2, y2, x, y )
		local Distance3 = MLib.Line.GetLength( x3, y3, x, y )
		local Distance4 = MLib.Line.GetLength( x4, y4, x, y )
		
		if ( Distance1 > Length1 ) or ( Distance2 > Length1 ) or ( Distance3 > Length2 ) or ( Distance4 > Length2 ) then 
			return false 
		end
	elseif not Slope2 then
		x = x4
		y = Slope1 * x + Intercept1
		
		local Length1 = MLib.Line.GetLength( x1, y1, x2, y2 )
		local Length2 = MLib.Line.GetLength( x3, y3, x4, y4 )
		local Distance1 = MLib.Line.GetLength( x1, y1, x, y )
		local Distance2 = MLib.Line.GetLength( x2, y2, x, y )
		local Distance3 = MLib.Line.GetLength( x3, y3, x, y )
		local Distance4 = MLib.Line.GetLength( x4, y4, x, y )
		
		if ( Distance1 > Length1 ) or ( Distance2 > Length1 ) or ( Distance3 > Length2 ) or ( Distance4 > Length2 ) then return false end
	else
		x, y = MLib.Line.GetIntersection( Slope1, Intercept1, Slope2, Intercept2 )
		if not x then return false end
		
		local Length1, Length2 = MLib.Line.GetLength( x1, y1, x2, y2 ), MLib.Line.GetLength( x3, y3, x4, y4 )
		local Distance1 = MLib.Line.GetLength( x1, y1, x, y )
		if Distance1 > Length1 then return false end
		
		local Distance2 = MLib.Line.GetLength( x2, y2, x, y )
		if Distance2 > Length1 then return false end
		
		local Distance3 = MLib.Line.GetLength( x3, y3, x, y )
		if Distance3 > Length2 then return false end
		
		local Distance4 = MLib.Line.GetLength( x4, y4, x, y )
		if Distance4 > Length2 then return false end
	end
	
	return x, y
end

-- Polygon
function MLib.Polygon.GetTriangleHeight( Base, ... )
	local Userdata = CheckUserdata( ... )
	local Area

	if #Userdata == 1 then Area = Userdata[1] else Area = MLib.Polygon.GetArea( Userdata ) end
	
	return ( 2 * Area ) / Base, Area
end

function MLib.Polygon.GetSignedArea( ... ) 
	local Userdata = CheckUserdata( ... )
	local Points = {}
	
	for Index = 1, #Userdata, 2 do
		Points[#Points + 1] = { Userdata[Index], Userdata[Index + 1] } 
	end
	
	Points[#Points + 1] = {}
	Points[#Points][1], Points[#Points][2] = Points[1][1], Points[1][2]
	return ( .5 * MLib.Math.GetSummation( 1, #Points, 
		function( Index ) 
			if Points[Index + 1] then 
				return ( ( Points[Index][1] * Points[Index + 1][2] ) - ( Points[Index + 1][1] * Points[Index][2] ) ) 
			else 
				return ( ( Points[Index][1] * Points[1][2] ) - ( Points[1][1] * Points[Index][2] ) )
			end 
		end 
	) )
end

function MLib.Polygon.GetArea( ... ) 
	return math.abs( MLib.Polygon.GetSignedArea( ... ) )
end

function MLib.Polygon.GetCentroid( ... ) 
	local Userdata = CheckUserdata( ... )
	
	local Points = {}
	for Index = 1, #Userdata, 2 do
		table.insert( Points, { Userdata[Index], Userdata[Index + 1] } )
	end
	
	Points[#Points + 1] = {}
	Points[#Points][1], Points[#Points][2] = Points[1][1], Points[1][2]
	
	local Area = MLib.Polygon.GetSignedArea( Userdata ) -- Needs to be signed here in case points are counter-clockwise. 
	
	local CentroidX = ( 1 / ( 6 * Area ) ) * ( MLib.Math.GetSummation( 1, #Points, 
		function( Index ) 
			if Points[Index + 1] then
				return ( ( Points[Index][1] + Points[Index + 1][1] ) * ( ( Points[Index][1] * Points[Index + 1][2] ) - ( Points[Index + 1][1] * Points[Index][2] ) ) )
			else
				return ( ( Points[Index][1] + Points[1][1] ) * ( ( Points[Index][1] * Points[1][2] ) - ( Points[1][1] * Points[Index][2] ) ) )
			end
		end
	) )
	
	local CentroidY = ( 1 / ( 6 * Area ) ) * ( MLib.Math.GetSummation( 1, #Points, 
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

function MLib.Polygon.CheckPoint( PointX, PointY, ... )
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
	
	function Wrap( Number, Limit )
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
			elseif MLib.Line.Segment.GetIntersection( x1, y1, x2, y2, PointX, PointY, LowestX, PointY ) then 
				Count = Count + 1 
			end
		else
			local x1, x2 = x[Index], x[1]
			local y1, y2 = y[Index], y[1]
			if PointY == y1 or PointY == y2 then 
				if y[Wrap( Index + 2, #y )] ~= PointY and y[Wrap( Index + 3, #y )] ~= PointY then
					Count = Count + 1
				end
			elseif MLib.Line.Segment.GetIntersection( x1, y1, x2, y2, PointX, PointY, LowestX, PointY ) then 
				Count = Count + 1 
			end
		end
	end

	return math.floor( Count / 2 ) ~= Count / 2 and true
end

function MLib.Polygon.LineIntersects( x1, y1, x2, y2, ... )
	local Userdata = CheckUserdata( ... )
	local Choices = {}
	
	for Index = 1, #Userdata, 2 do
		-- if MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, Userdata[Index], Userdata[Index + 1] ) then return true end
		if Userdata[Index + 2] then
			local x, y = MLib.Line.Segment.GetIntersection( Userdata[Index], Userdata[Index + 1], Userdata[Index + 2], Userdata[Index + 3], x1, y1, x2, y2 )
			if x then Choices[#Choices + 1] = { x, y } end
		else
			local x, y = MLib.Line.Segment.GetIntersection( Userdata[Index], Userdata[Index + 1], Userdata[1], Userdata[2], x1, y1, x2, y2 )
			if x then Choices[#Choices + 1] = { x, y } end
		end
	end

	local Final = RemoveDuplicates( Choices )
	
	return #Final > 0 and Final or false
end

function MLib.Polygon.PolygonIntersects( Polygon1, Polygon2 )
	local Choices = {}
	
	for Index = 1, #Polygon1, 2 do
		if Polygon1[Index + 2] then
			local Intersections = MLib.Polygon.LineIntersects( Polygon1[Index], Polygon1[Index + 1], Polygon1[Index + 2], Polygon1[Index + 3], Polygon2 )
			if Intersections and #Intersections > 0 then
				for Index2 = 1, #Intersections do
					Choices[#Choices + 1] = { unpack( Intersections[Index2] ) }
				end
			end
		else
			local Intersections = MLib.Polygon.LineIntersects( Polygon1[Index], Polygon1[Index + 1], Polygon1[1], Polygon1[2], Polygon2 )
			if Intersections and #Intersections > 0 then
				for Index2 = 1, #Intersections do
					Choices[#Choices + 1] = { unpack( Intersections[Index2] ) }
				end
			end
		end
	end
	
	for Index = 1, #Polygon2, 2 do
		if Polygon2[Index + 2] then
			local Intersections = MLib.Polygon.LineIntersects( Polygon2[Index], Polygon2[Index + 1], Polygon2[Index + 2], Polygon2[Index + 3], Polygon1 )
			if Intersections and #Intersections > 0 then
				for Index2 = 1, #Intersections do
					Choices[#Choices + 1] = { unpack( Intersections[Index2] ) }
				end
			end
		else
			local Intersections = MLib.Polygon.LineIntersects( Polygon2[Index], Polygon2[Index + 1], Polygon2[1], Polygon2[2], Polygon1 )
			if Intersections and #Intersections > 0 then
				for Index2 = 1, #Intersections do
					Choices[#Choices + 1] = { unpack( Intersections[Index2] ) }
				end
			end
		end
	end	
	
	local Final = RemoveDuplicates( Choices )
	
	return #Final > 0 and Final or false 
end

function MLib.Polygon.CircleIntersects( x, y, Radius, ... )
	local Userdata = CheckUserdata( ... )
	local Choices = {}
	
	for Index = 1, #Userdata, 2 do
		if Userdata[Index + 2] then 
			local Type, x1, y1, x2, y2 = MLib.Circle.IsSegmentSecant( x, y, Radius, Userdata[Index], Userdata[Index + 1], Userdata[Index + 2], Userdata[Index + 3] )
			if x2 then 
				Choices[#Choices + 1] = { Type, x1, y1, x2, y2 } 
			elseif x1 then Choices[#Choices + 1] = { Type, x1, y1 } end
		else
			local Type, x1, y1, x2, y2 = MLib.Circle.IsSegmentSecant( x, y, Radius, Userdata[Index], Userdata[Index + 1], Userdata[1], Userdata[2] )
			if x2 then 
				Choices[#Choices + 1] = { Type, x1, y1, x2, y2 } 
			elseif x1 then Choices[#Choices + 1] = { Type, x1, y1 } end
		end
	end
	
	local function RemoveDuplicates( Table ) 
		for Index1 = #Table, 1, -1 do
			local First = Table[Index1]
			for Index2 = #Table, 1, -1 do
				local Second = Table[Index2]
				if Index1 ~= Index2 then
					if type( First[1] ) ~= type( Second[1] ) then return false end
					if type( First[2] ) == 'number' and type( Second[2] ) == 'number' and type( First[3] ) == 'number' and type( Second[3] ) == 'number' then
						if CheckFuzzy( First[2], Second[2] ) and CheckFuzzy( First[3], Second[3] ) then
							table.remove( Table, Index1 )
						end
					elseif First[1] == Second[1] and First[2] == Second[2] and First[3] == Second[3] then
						table.remove( Table, Index1 )
					end
				end
			end
		end
		return Table
	end
	
	local Final = RemoveDuplicates( Choices )
	
	return #Final > 0 and Final or false
end

-- Circle
function MLib.Circle.GetArea( Radius )
	return math.pi * ( Radius ^ 2 )
end

function MLib.Circle.CheckPoint( CircleX, CircleY, Radius, x, y )
	return ( x - CircleX ) ^ 2 + ( y - CircleY ) ^ 2 == Radius ^ 2 
end

function MLib.Circle.GetCircumference( Radius )
	return 2 * math.pi * Radius
end

function MLib.Circle.IsLineSecant( CircleX, CircleY, Radius, ... )
	local Userdata = CheckUserdata( ... )
	
	local Slope, Intercept = 0, 0
	
	if #Userdata == 2 then 
		Slope, Intercept = Userdata[1], Userdata[2] 
	else 
		Slope = MLib.Line.GetSlope( Userdata[1], Userdata[2], Userdata[3], Userdata[4] ) 
		Intercept = MLib.Line.GetIntercept( Userdata[1], Userdata[2], Slope ) 
	end
	
	local x1, y1, x2, y2
	if #Userdata == 4 then x1, y1, x2, y2 = unpack( Userdata ) end
	
	if Slope then 
		local a = ( 1 + Slope ^ 2 )
		local b = ( -2 * ( CircleX ) + ( 2 * Slope * Intercept ) - ( 2 * CircleY * Slope ) )
		local c = ( CircleX ^ 2 + Intercept ^ 2 - 2 * ( CircleY ) * ( Intercept ) + CircleY ^ 2 - Radius ^ 2 )
		
		x1, x2 = MLib.Math.GetRootsOfQuadratic( a, b, c )
		
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

function MLib.Circle.IsSegmentSecant( CircleX, CircleY, Radius, x1, y1, x2, y2 )
	local Type, x3, y3, x4, y4 = MLib.Circle.IsLineSecant( CircleX, CircleY, Radius, x1, y1, x2, y2 )
	if not Type then return false end
	
	local Slope, Intercept = MLib.Line.GetSlope( x1, y1, x2, y2 ), MLib.Line.GetIntercept( x1, y1, x2, y2 )
	
	if MLib.Circle.CheckPoint( CircleX, CircleY, Radius, x1, y1 ) and MLib.Circle.CheckPoint( CircleX, CircleY, Radius, x2, y2 ) then -- Both points are on line-segment. 
		return 'Chord', x1, y1, x2, y2
	end
	
	if Slope then 
		if MLib.Circle.IsPointInCircle( CircleX, CircleY, Radius, x1, y1 ) and MLib.Circle.IsPointInCircle( CircleX, CircleY, Radius, x2, y2 ) then -- Line-segment is fully in circle. 
			return 'Enclosed', x1, y1, x2, y2
		elseif x3 and x4 then
			if MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, x3, y3 ) and not MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, x4, y4 ) then -- Only the first of the points is on the line-segment. 
				return 'Tangent', x3, y3
			elseif MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, x4, y4 ) and not MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, x3, y3 ) then -- Only the second of the points is on the line-segment. 
				return 'Tangent', x4, y4
			else -- Neither of the points are on the circle (means that the segment is not on the circle, but "encasing" the circle)
				local Length = MLib.Line.GetLength( x1, y1, x2, y2 )
				
				if MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, x3, y3 ) and MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, x4, y4 ) then
					return 'Secant', x3, y3, x4, y4
				else
					return false
				end
			end
		elseif not x4 then -- Is a tangent. 
			if MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, x3, y3 ) then
				return 'Tangent', x3, y3
			else -- Neither of the points are on the line-segment (means that the segment is not on the circle or "encasing" the circle).
				local Length = MLib.Line.GetLength( x1, y1, x2, y2 )
				local Distance1 = MLib.Line.GetLength( x1, y1, x3, y3 )
				local Distance2 = MLib.Line.GetLength( x2, y2, x3, y3 )
				
				if Length > Distance1 or Length > Distance2 then 
					return false
				elseif Length < Distance1 and Length < Distance2 then 
					return false 
				else
					return 'Tangent', x3, y3
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
		
		local Length = MLib.Line.GetLength( x1, y1, x2, y2 )
		local Distance1 = MLib.Line.GetLength( x1, y1, TopX, TopY )
		local Distance2 = MLib.Line.GetLength( x2, y2, TopX, TopY )
		
		if BottomY ~= TopY then 
			if MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, TopX, TopY ) and MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, BottomX, BottomY ) then
				return 'Chord', TopX, TopY, BottomX, BottomY
			elseif MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, TopX, TopY ) then
				return 'Tangent', TopX, TopX
			elseif MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, BottomX, BottomY ) then
				return 'Tangent', BottomX, BottomY
			else
				return false
			end
		else 
			if MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, TopX, TopY ) then
				return 'Tangent', TopX, TopY
			else
				return false
			end
		end
	end
end

function MLib.Circle.CircleIntersects( Circle1CenterX, Circle1CenterY, Radius1, Circle2CenterX, Circle2CenterY, Radius2 )
	local Distance = MLib.Line.GetLength( Circle1CenterX, Circle1CenterY, Circle2CenterX, Circle2CenterY )
	if Distance > Radius1 + Radius2 then return false end
	if Distance == 0 and Radius1 == Radius2 then return 'Equal' end
	
	local a = ( Radius1 ^ 2 - Radius2 ^ 2 + Distance ^ 2 ) / ( 2 * Distance )
	local h = math.sqrt( Radius1 ^ 2 - a ^ 2 )
	
	if Circle1CenterX == Circle2CenterX and Circle1CenterY == Circle2CenterY then return 'Colinear' end
	
	local p2x = Circle1CenterX + a * ( Circle2CenterX - Circle1CenterX ) / Distance
	local p2y = Circle1CenterY + a * ( Circle2CenterY - Circle1CenterY ) / Distance
	local p3x = p2x + h * ( Circle2CenterY - Circle1CenterY ) / Distance
	local p3y = p2y - h * ( Circle2CenterX - Circle1CenterX ) / Distance
	local p4x = p2x - h * ( Circle2CenterY - Circle1CenterY ) / Distance
	local p4y = p2y + h * ( Circle2CenterX - Circle1CenterX ) / Distance
	
	if Distance == Radius1 + Radius2 then return p3x, p3y end
	return p3x, p3y, p4x, p4y 
end

function MLib.Circle.IsPointInCircle( CircleX, CircleY, Radius, x, y )
	return MLib.Line.GetLength( CircleX, CircleY, x, y ) <= Radius
end

-- Statistics
function MLib.Statistics.GetMean( ... )
	local Userdata = CheckUserdata( ... )
	
	local Mean = 0
	for Index = 1, #Userdata do
		Mean = Mean + Userdata[Index]
	end
	Mean = Mean / #Userdata
	
	return Mean
end

function MLib.Statistics.GetMedian( ... )
	local Userdata = CheckUserdata( ... )
	
	table.sort( Userdata )
	
	if #Userdata % 2 == 0 then
		Userdata = ( Userdata[math.floor( #Userdata / 2 )] + Userdata[math.floor( #Userdata / 2 + 1 )] ) / 2
	else
		Userdata =  Userdata[#Userdata / 2 + .5]
	end
	
	return Userdata
end

function MLib.Statistics.GetMode( ... ) 
	local Userdata = CheckUserdata( ... )

	table.sort( Userdata )
	local Sorted = {}
	for Index, Value in ipairs( Userdata ) do
		Sorted[Value] = Sorted[Value] and Sorted[Value] + 1 or 1
	end
	
	local Occurrences, Least = 0, {}
	for Index, Value in pairs( Sorted ) do
		if Value > Occurrences then
			Least = { Index }
			Occurrences = Value
		elseif Value == Occurrences then
			Least[#Least + 1] = Index
		end
	end
	
	if #Least >= 1 then return Least, Occurrences
	else return false end
end

function MLib.Statistics.GetRange( ... )
	local Userdata = CheckUserdata( ... )
	
	local Upper, Lower = math.max( unpack( Userdata ) ), math.min( unpack( Userdata ) )
	
	return Upper - Lower
end

-- Math (homeless functions)
function MLib.Math.GetRoot( Number, Root )
	local Num = Number ^ ( 1 / Root )
	return Num, -Num
end

function MLib.Math.IsPrime( Number )	
	if Number < 2 then return false end
		
	for Index = 2, math.sqrt( Number ) do
		if Number % Index == 0 then
			return false
		end
	end
	
	return true
end

function MLib.Math.Round( Number, DecimalPlace )
	local DecimalPlace, ReturnedValue = DecimalPlace and 10 ^ DecimalPlace or 1
	
	local UpperNumber = math.ceil( Number * DecimalPlace )
	local LowerNumber = math.floor( Number * DecimalPlace )
	
	local UpperDifferance = UpperNumber - ( Number * DecimalPlace ) 
	local LowerDifference = ( Number * DecimalPlace ) - LowerNumber
	
	if UpperNumber == Number then
		ReturnedValue = Number
	else
		if UpperDifferance <= LowerDifference then ReturnedValue = UpperNumber elseif LowerDifference < UpperDifferance then ReturnedValue = LowerNumber end
	end
	
	return ReturnedValue / DecimalPlace
end

function MLib.Math.GetSummation( Start, Stop, Function )
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

function MLib.Math.GetPercentOfChange( Old, New )
	if Old == 0 and New == 0 then
		return 0
	elseif Old == 0 then 
		return false
	else 
		return ( New - Old ) / math.abs( Old ) 
	end
end

function MLib.Math.GetPercent( Percent, Number )
	return math.abs( Percent ) * Number
end

function MLib.Math.GetRootsOfQuadratic( a, b, c )
	local Discriminant = b ^ 2 - ( 4 * a * c )
	if Discriminant < 0 then return false end
	
	Discriminant = math.sqrt( Discriminant )
	
	return ( -b - Discriminant ) / ( 2 * a ), ( -b + Discriminant ) / ( 2 * a )
end

function MLib.Math.GetAngle( x1, y1, x2, y2, x3, y3 )	
    local A = MLib.Line.GetLength( x3, y3, x2, y2 )
    local B = MLib.Line.GetLength( x1, y1, x2, y2 )
    local C = MLib.Line.GetLength( x1, y1, x3, y3 )

   return math.acos( ( A ^ 2 + B ^ 2 - C ^ 2 ) / ( 2 * A * B ) )
end

-- Shape
function MLib.Shape.NewShape( ... )
	local Userdata = CheckUserdata( ... )
	
	if #Userdata == 3 then
		Userdata.Type = 'Circle'
		Userdata.x, Userdata.y, Userdata.Radius = unpack( Userdata )
		Userdata.Area = MLib.Circle.GetArea( Userdata.Radius )
	elseif #Userdata == 4 then
		Userdata.Type = 'Line'
		Userdata.x1, Userdata.y1, Userdata.x2, Userdata.y2 = unpack( Userdata )
		Userdata.Slope = MLib.Line.GetSlope( unpack( Userdata ) )
		Userdata.Intercept = MLib.Line.GetIntercept( unpack( Userdata ) )
	else
		Userdata.Points = Userdata
		Userdata.Type = 'Polygon'
		Userdata.Area = MLib.Polygon.GetArea( Userdata )
	end
	
	Userdata.Collided = false
	Userdata.Index = #MLib.Shape.User + 1
	Userdata.Removed = false
	
	setmetatable( Userdata, MLib.Shape )
	table.insert( MLib.Shape.User, Userdata )
	
	return Userdata
end

function MLib.Shape.CheckCollisions( Self, ... )
	local Userdata = { ... }
	
	local function Check( Self, Shape )
		local Collided = false
		if not Shape.Removed and not Self.Removed then 
			if Self.Type == 'Line' then 
				if Shape.Type == 'Line' then
					if MLib.Line.Segment.GetIntersection( Self.x1, Self.y1, Self.x2, Self.y2, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				elseif Shape.Type == 'Polygon' then
					if MLib.Polygon.LineIntersects( Self.x1, Self.y1, Self.x2, Self.y2, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				elseif Shape.Type == 'Circle' then
					if MLib.Circle.IsSegmentSecant( Shape.x, Shape.y, Shape.Radius, Self.x1, Self.y1, Self.x2, Self.y2 ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				end
			elseif Self.Type == 'Polygon' then
				if Shape.Type == 'Line' then
					if MLib.Polygon.LineIntersects( Shape.x1, Shape.y1, Shape.x2, Shape.y2, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				elseif Shape.Type == 'Polygon' then
					if MLib.Polygon.PolygonIntersects( Self.Points, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				elseif Shape.Type == 'Circle' then
					if MLib.Polygon.CircleIntersects( Shape.x, Shape.y, Shape.Radius, Self.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				end
			elseif Self.Type == 'Circle' then
				if Shape.Type == 'Line' then
					if MLib.Circle.IsSegmentSecant( Self.x, Self.y, Self.Radius, Shape.x1, Shape.y1, Shape.x2, Shape.y2 ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				elseif Shape.Type == 'Polygon' then
					if MLib.Polygon.CircleIntersects( Self.x, Self.y, Self.Radius, Shape.Points ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				elseif Shape.Type == 'Circle' then
					if MLib.Circle.CircleIntersects( Self.x, Self.y, Self.Radius, Shape.x, Shape.y, Shape.Radius ) then Collided, Self.Collided, Shape.Collided = true, true, true end
				end
			end
		end
		if not Collided then Self.Collided = false end
	end

	if type( Self ) == 'table' then -- Using Index Self:table. 
		if #Userdata == 0 and Self.Type then -- No arguments (colliding with everything). 
			for Index = 1, #MLib.Shape.User do
				if Index ~= Self.Index then 
					local Shape = MLib.Shape.User[Index]
					Check( Self, Shape )
				end
			end
		elseif not Self.Type then -- Multi-item table. 
			for Index1, Primary in ipairs( Self ) do
				for Index2, Secondary in ipairs( Self ) do
					if Index1 ~= Index2 then
						Check( Primary, Secondary )
					end
				end
			end
		else -- Colliding with only certain things. 
			for Index = 1, #Userdata do
				local Shape = Userdata[Index]
				Check( Self, Shape )
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
						Check( Self, Shape )
					end
				end
			end
		else -- Checking only certain collisions
			for Index = 1, #Userdata do
				local Self = MLib.Shape.User[Index]
				local Collided = false
				for Index2 = 1, #MLib.Shape.User do
					if Self.Index ~= Userdata[Index2].Index then 
						local Shape = MLib.Shape.User[Index2]
						Check( Self, Shape )
					end
				end
			end
		end
	end
end

function MLib.Shape.Remove( Self, ... )
	local Userdata = { ... }
	
	if type( Self ) == 'table' and Self.Type then
		Self.Removed = true
		
		if #Userdata > 0 then
			for Index = 1, #Userdata do
				MLib.Shape.User[Userdata[Index].Index].Removed = true
			end
		end
	else
		local Table = #Userdata > 0 and Userdata or ( Self or MLib.Shape.User )
		
		for Index = 1, #Table do
			MLib.Shape.User[Table[Index].Index].Removed = true
		end
	end
end

return MLib