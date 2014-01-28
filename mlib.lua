--[[
    A math library made in Lua
    Copyright (C) 2013 Davis Claiborne

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

local mlib = {
	line = {
		segment = {}, 
		func = {}, 
	}, 
	polygon = {}, 
	circle = {}, 
	stats = {}, 
	shape = {
		user = {}
	}, 
}
mlib.math = {}
mlib.shape.__index = mlib.shape

--line
function mlib.line.length( x1, y1, x2, y2 )
	return math.sqrt( ( x1 - x2 ) ^ 2 + ( y1 - y2 ) ^ 2 )
end

function mlib.line.midpoint( x1, y1, x2, y2 )
	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

function mlib.line.slope( x1, y1, x2, y2 )
	if x1 == x2 then return false end
	return ( y1 - y2 ) / ( x1 - x2 )
end

function mlib.line.perpendicularSlope( ... )
	local tab = {}
	local slope = false
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab ~= 1 then slope = mlib.line.slope( unpack( tab ) ) else
	slope = unpack( tab ) end
	if slope == 0 then return false end
	if not slope then return 0 end
	return -1 / slope 
end

function mlib.line.perpendicularBisector( x1, y1, x2, y2 )
	local slope = mlib.line.slope( x1, y1, x2, y2 )
	return mlib.line.perpendicularSlope( slope ), mlib.line.midpoint( x1, y1, x2, y2 )
end

function mlib.line.intercept( x, y, ... )
	local tab = {}
	local slope = false
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab == 1 then slope = tab[1] else
	slope = mlib.line.slope( x, y, unpack( tab ) ) end
	if not slope then return false end
	return y - slope * x
end

function mlib.line.draw( slope, y_intercept )
	love.graphics.line( 0, y_intercept, love.graphics.Width(), slope * love.graphics.Width() + y_intercept )
end

function mlib.line.drawStandard( slope, y_intercept )
	local slope = slope * -1
	local y_intercept = y_intercept + love.graphics.Height()
	love.graphics.line( 0, y_intercept, love.graphics.Width(), slope * love.graphics.Width() + y_intercept )
end

function mlib.line.intersect( m1, b1, ... )
	local tab = {}
	local m2, b2 = nil, nil
	local x, y = nil, nil
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab == 2 then m2, b2 = tab[1], tab[2] else m2, b2 = mlib.line.slope( tab[1], tab[2], tab[3], tab[4] ), mlib.line.intercept( tab[1], tab[2], tab[3], tab[4] ) end
	if not m2 then
		x = tab[1]
		y = m1 * x + b1
	elseif m1 == m2 then return false
	else
		x = ( -b1 + b2 ) / ( m1 - m2 )
		y = m1 * x + b1
	end
	return x, y
end

function mlib.line.closestPoint( px, py, ... )
	local tab = {}
	local x1, y1, x2, y2, m, b = nil, nil, nil, nil, nil, nil
	if type ( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab == 4 then
		x1, y1, x2, y2 = unpack( tab )
		m, b = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	elseif #tab == 2 then
		m, b = unpack( tab )
	end
	local x, y = nil, nil
	if not m then
		x, y = x1, py
	elseif m == 0 then
		x, y = px, y1
	else
		pm = mlib.line.perpendicularSlope( m )
		pb = mlib.line.intercept( px, py, pm )
		x, y = mlib.line.intersect( m, b, pm, pb )
	end
	return x, y
end

function mlib.line.segmentIntersects( x1, y1, x2, y2, ... )
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end 
	local m1, m2 = nil, nil
	local m2, b2 = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	local x, y = nil, nil
	if #tab == 2 then 
		m1, b1 = tab[1], tab[2]
	else
		m1, b1 = mlib.line.slope( unpack( tab ) ), mlib.line.intercept( unpack( tab ) )
	end
	if not m1 then
		x, y = tab[1], m2 * tab[1] + b2
	elseif not m2 then
		x, y = x1, m1 * x1 + b1
	else
		x, y = mlib.line.intersect( m1, b1, m2, b2 )
	end
	l1, l2 = mlib.line.length( x1, y1, x, y ), mlib.line.length( x2, y2, x, y )
	d = mlib.line.length( x1, y1, x2, y2 )
	if l1 <= d and l2 <= d then return x, y else return false end
end

--line func
function mlib.line.func.get( x1, y1, x2, y2 ) 
	if y1 <= 0 or y2 <= 0 then return false end
	local x, y = x1 - x2, y1 / y2 
	if x == 0 then return false end
	local b = y ^ ( 1 / x ) 
	local a = y1 / ( b ^ x1 ) 
	return a, b
end

function mlib.line.func.draw( a, b )
	local width, height = love.window.getDimensions()
	for i = 0, width do
		love.graphics.line( i, a * ( b ) ^ i, i + 1, a * ( b ) ^ ( i + 1 ) )
	end
end

function mlib.line.func.drawStandard( a, b )
	local width, height = love.window.getDimensions()
	for i = 0, width do
		love.graphics.line( i, height - ( a * ( b ) ^ i ), i + 1, height - ( a * ( b ) ^ ( i + 1 ) ) )
	end
end

--line segment
function mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 )
	local m, b = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	if m == -math.huge or m == math.huge then
		if y1 ~= y3 then return false end
		local l = mlib.line.length( x1, y1, x2, y2 )
		local d1 = mlib.line.length( x1, y1, x3, y3 )
		local d2 = mlib.line.length( x2, y2, x3, y3 )
		if d1 > l or d2 > l then return false end
		return true
	elseif y3 == m * x3 + b then
		local l = mlib.line.length( x1, y1, x2, y2 )
		local d1 = mlib.line.length( x1, y1, x3, y3 )
		local d2 = mlib.line.length( x2, y2, x3, y3 )
		if d1 > l or d2 > l then return false end
		return true
	else
		return false
	end
end

function mlib.line.segment.intersect( x1, y1, x2, y2, x3, y3, x4, y4 )
	local m1, b1 = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	local m2, b2 = mlib.line.slope( x3, y3, x4, y4 ), mlib.line.intercept( x3, y3, x4, y4 )
	if m1 == m2 then 
		if b1 == b2 then 
			local x = { x1, x2, x3, x4 }
			local y = { y1, y2, y3, y4 }
			local oy = { y1, y2, y3, y4 }
			local l1, l2 = mlib.line.length( x[1], y[1], x[2], y[2] ), mlib.line.length( x[3], y[3], x[4], y[4] )
			local largex, smallx = math.max( unpack( x ) ), math.min( unpack( x ) )
			local largey, smally = math.max( unpack( y ) ), math.min( unpack( y ) )
			local lx, sx, ly, sy = nil, nil, nil, nil
			for a = 1, #x do if x[a] == largex then lx = a end end
			for a = 1, #x do if x[a] == smallx then sx = a end end
			for a = 1, #y do if y[a] == largey then ly = a end end
			for a = 1, #y do if y[a] == smally then sy = a end end
			table.remove( x, lx )
			table.remove( x, sx )
			table.remove( y, ly )
			table.remove( y, sy )
			local d = mlib.line.length( x[1], y[1], x[2], y[2] )
			if d > l1 or d > l2 then return false end
			local l1 = mlib.line.length( x[1], oy[1], x[1], oy[2] )
			local l2 = mlib.line.length( x[1], oy[3], x[1], oy[4] )
			local l3 = mlib.line.length( x[1], y[1], x[2], y[2] )
			if l3 >= l1 or l3 >= l2 then return false end
			return x[1], y[1], x[2], y[2]
		else
			return false
		end
	end
	local x, y = nil, nil
	if not m1 then
		x = x2
		y = m2 * x + b2
		local l1 = mlib.line.length( x1, y1, x2, y2 )
		local l2 = mlib.line.length( x3, y3, x4, y4 )
		local d1 = mlib.line.length( x1, y1, x, y )
		local d2 = mlib.line.length( x2, y2, x, y )
		local d3 = mlib.line.length( x3, y3, x, y )
		local d4 = mlib.line.length( x4, y4, x, y )
		if ( d1 > l1 ) or ( d2 > l1 ) or ( d3 > l2 ) or ( d4 > l2 ) then return false end
	elseif not m2 then
		x = x4
		y = m1 * x + b1
	else
		x, y = mlib.line.intersect( m1, b1, m2, b2 )
		if not x then return false end
		local l1, l2 = mlib.line.length( x1, y1, x2, y2 ), mlib.line.length( x3, y3, x4, y4 )
		local d1 = mlib.line.length( x1, y1, x, y )
		if d1 > l1 then return false end
		local d2 = mlib.line.length( x2, y2, x, y )
		if d2 > l1 then return false end
		local d3 = mlib.line.length( x3, y3, x, y )
		if d3 > l2 then return false end
		local d4 = mlib.line.length( x4, y4, x, y )
		if d4 > l2 then return false end
	end
	return x, y
end

--polygon
function mlib.polygon.triangleHeight( base, ... )
	local tab = {}
	local area = 0
	local b = 0
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab == 1 then area = tab[1] else area = mlib.polygon.area( tab ) end
	return ( 2 * area ) / base, area
end

function mlib.polygon.area( ... ) 
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	local points = {}
	for a = 1, #tab, 2 do
		table.insert( points, { tab[a], tab[a+1] } )
	end
	points[#points + 1] = {}
	points[#points][1], points[#points][2] = points[1][1], points[1][2]
	return ( .5 * math.abs( mlib.math.summation( 1, #points, 
	function( i ) 
		if points[i + 1] then 
			return ( ( points[i][1] * points[i + 1][2] ) - ( points[i + 1][1] * points[i][2] ) ) 
		else 
			return ( ( points[i][1] * points[1][2] ) - ( points[1][1] * points[i][2] ) )
		end 
	end ) ) )
end

function mlib.polygon.centroid( ... ) 
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	local points = {}
	for a = 1, #tab, 2 do
		table.insert( points, { tab[a], tab[a+1] } )
	end
	points[#points + 1] = {}
	points[#points][1], points[#points][2] = points[1][1], points[1][2]
	local area = .5 * mlib.math.summation( 1, #points, --need to signed area here, in case coordinates are arranged counter-clockwise.
	function( i ) 
		if points[i + 1] then 
			return ( ( points[i][1] * points[i + 1][2] ) - ( points[i + 1][1] * points[i][2] ) ) 
		else 
			return ( ( points[i][1] * points[1][2] ) - ( points[1][1] * points[i][2] ) )
		end 
	end ) 
	local cx = ( 1 / ( 6 * area ) ) * ( mlib.math.summation( 1, #points, 
		function( i ) 
			if points[i + 1] then
				return ( ( points[i][1] + points[i + 1][1] ) * ( ( points[i][1] * points[i + 1][2] ) - ( points[i + 1][1] * points[i][2] ) ) )
			else
				return ( ( points[i][1] + points[1][1] ) * ( ( points[i][1] * points[1][2] ) - ( points[1][1] * points[i][2] ) ) )
			end
		end
	) )
	local cy = ( 1 / ( 6 * area ) ) * ( mlib.math.summation( 1, #points, 
		function( i ) 
			if points[i + 1] then
				return ( ( points[i][2] + points[i + 1][2] ) * ( ( points[i][1] * points[i + 1][2] ) - ( points[i + 1][1] * points[i][2] ) ) )
			else
				return ( ( points[i][2] + points[1][2] ) * ( ( points[i][1] * points[1][2] ) - ( points[1][1] * points[i][2] ) ) )
			end
		end 
	) )
	return cx, cy
end

function mlib.polygon.checkPoint( px, py, ... )
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	local x = {}
	local y = {}
	local m = {}
	for a = 1, #tab, 2 do
		table.insert( x, tab[a] )
		table.insert( y, tab[a + 1] )
	end
	for a = 1, #x do
		local slope = nil
		if a ~= #x then
			slope = ( y[a] - y[a + 1] ) / ( x[a] - x[a + 1] )
		else 
			slope = ( y[a] - y[1] ) / ( x[a] - x[1] )
		end
		table.insert( m, slope )
	end
	local lx = math.max( unpack( x ) )
	local count = 0
	local function loop( num, large )
		if num > large then return num - large end
		return num
	end
	for a = 1, #m do
		if a ~= #m then
			local x1, x2 = x[a], x[a + 1]
			local y1, y2 = y[a], y[a + 1]
			if lx < x1 then return false end 
			if py == y1 or py == y2 then 
				if y[loop( a + 2, #y )] ~= py and y[loop( a + 3, #y )] ~= py then
					count = count + 1
				end
			elseif mlib.line.segment.intersect( x1, y1, x2, y2, px, py, lx, py ) then 
				count = count + 1 
			end
		else
			local x1, x2 = x[a], x[1]
			local y1, y2 = y[a], y[1]
			if lx < x1 then return false end 
			if py == y1 or py == y2 then 
				if y[loop( a + 2, #y )] ~= py and y[loop( a + 3, #y )] ~= py then
					count = count + 1
				end
			elseif mlib.line.segment.intersect( x1, y1, x2, y2, px, py, lx, py ) then 
				count = count + 1 
			end
		end
	end
	if math.floor( count / 2 ) ~= count / 2 then return true end
	return false	
end

function mlib.polygon.lineIntersects( x1, y1, x2, y2, ... )
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if mlib.polygon.checkPoint( x1, y1, tab ) then return true end
	if mlib.polygon.checkPoint( x2, y2, tab ) then return true end
	for a = 1, #tab, 2 do
		if mlib.polygon.checkPoint( tab[a], tab[a + 1], tab ) then return true end
		if tab[a + 2] then
			if mlib.line.segment.intersect( tab[a], tab[a + 1], tab[a + 2], tab[a + 3], x1, y1, x2, y2 ) then return true end
		else
			if mlib.line.segment.intersect( tab[a], tab[a + 1], tab[1], tab[2], x1, y1, x2, y2 ) then return true end
		end
	end
	return false
end

function mlib.polygon.polygonIntersects( polygon1, polygon2 )
	for a = 1, #polygon1, 2 do
		if polygon1[a + 2] then
			if mlib.polygon.lineIntersects( polygon1[a], polygon1[a + 1], polygon1[a + 2], polygon1[a + 3], polygon2 ) then return true end
		else
			if mlib.polygon.lineIntersects( polygon1[a], polygon1[a + 1], polygon1[1], polygon1[2], polygon2 ) then return true end
		end
	end
	for a = 1, #polygon2, 2 do
		if polygon2[a + 2] then
			if mlib.polygon.lineIntersects( polygon2[a], polygon2[a + 1], polygon2[a + 2], polygon2[a + 3], polygon1 ) then return true end
		else
			if mlib.polygon.lineIntersects( polygon2[a], polygon2[a + 1], polygon2[1], polygon2[2], polygon1 ) then return true end
		end
	end	
	return false
end

function mlib.polygon.circleIntersects( x, y, r, ... )
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	for a = 1, #tab, 2 do
		if mlib.circle.checkPoint( x, y, r, tab[a], tab[a + 1] ) then return true end
		if tab[a + 2] then 
			if mlib.circle.segmentSecant( x, y, r, tab[a], tab[a + 1], tab[a + 2], tab[a + 3] ) then return true end
		else
			if mlib.circle.segmentSecant( x, y, r, tab[a], tab[a + 1], tab[1], tab[2] ) then return true end
		end
	end
	return false
end

--circle
function mlib.circle.area( r )
	return math.pi * ( r ^ 2 )
end

function mlib.circle.checkPoint( cx, cy, r, x, y )
	return ( x - cx ) ^ 2 + ( y - cy ) ^ 2 == r ^ 2 
end

function mlib.circle.circumference( r )
	return 2 * math.pi * r
end

function mlib.circle.secant( cx, cy, r, ... )
	local tab = {}
	local m, b = 0, 0
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab == 2 then m, b = tab[1], tab[2] else m = mlib.line.slope( tab[1], tab[2], tab[3], tab[4] ) b = mlib.line.intercept( tab[1], tab[2], m ) end
	local x1, y1, x2, y2 = nil, nil, nil, nil
	if #tab == 4 then x1, y1, x2, y2 = unpack( tab ) end
	if m then 
		local a1 = ( 1 + m ^ 2 )
		local b1 = ( -2 * ( cx ) + ( 2 * m * b ) - ( 2 * cy * m ) )
		local c1 = ( cx ^ 2 + b ^ 2 - 2 * ( cy ) * ( b ) + cy ^ 2 - r ^ 2 )
		x1, x2 = mlib.math.quadraticFactor( a1, b1, c1 )
		if not x1 then return false end
		y1 = m * x1 + b
		y2 = m * x2 + b
		if x1 == x2 and y1 == y2 then return 'tangent', x1, y1
		else return 'secant', x1, y1, x2, y2 end
	else
		local points = {}
		for a = cy - r, cy + r do
			if mlib.circle.checkPoint( cx, cy, r, x1, a ) then 
				table.insert( points, { x1, a } )
			end
		end
		if #points == 1 then return 'tangent', points[1][1], points[1][2] 
		elseif #points == 2 then return 'secant', points[1][1], points[1][2], points[2][1], points[2][2]
		else return false end
	end
end

function mlib.circle.segmentSecant( cx, cy, r, x1, y1, x2, y2 )
	local m, b = 0, 0
	m, b = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, m )
	if mlib.line.length( x1, y1, cx, cy ) > r and mlib.line.length( x2, y2, cx, cy ) > r then return false end
	if m then 
		local a1 = ( 1 + m ^ 2 )
		local b1 = ( -2 * ( cx ) + ( 2 * m * b ) - ( 2 * cy * m ) )
		local c1 = ( cx ^ 2 + b ^ 2 - 2 * ( cy ) * ( b ) + cy ^ 2 - r ^ 2 )
		x1, x2 = mlib.math.quadraticFactor( a1, b1, c1 )
		if not x1 then return false end
		y1 = m * x1 + b
		y2 = m * x2 + b
		if x1 == x2 and y1 == y2 then return 'tangent', x1, y1
		else return 'secant', x1, y1, x2, y2 end
	else
		local points = {}
		for a = cy - r, cy + r do
			if mlib.circle.checkPoint( cx, cy, r, x1, a ) then 
				table.insert( points, { x1, a } )
			end
		end
		if #points == 1 then return 'tangent', points[1][1], points[1][2] 
		elseif #points == 2 then return 'secant', points[1][1], points[1][2], points[2][1], points[2][2]
		else return false end
	end
end

function mlib.circle.circlesIntersect( p0x, p0y, r0, p1x, p1y, r1 )
	local d = mlib.line.length( p0x, p0y, p1x, p1y )
	if d > r0 + r1 then return false end
	if d == 0 and r0 == r1 then return true end
	local a = ( r0 ^ 2 - r1 ^ 2 + d ^ 2 ) / ( 2 * d )
	local h = math.sqrt( r0 ^ 2 - a ^ 2 )
	local p2x = p0x + a * ( p1x - p0x ) / d
	local p2y = p0y + a * ( p1y - p0y ) / d
	local p3x = p2x + h * ( p1y - p0y ) / d
	local p3y = p2y - h * ( p1x - p0x ) / d
	local p4x = p2x - h * ( p1y - p0y ) / d
	local p4y = p2y + h * ( p1x - p0x ) / d
	if d == r0 + r1 then return p3x, p3y end
	return p3x, p3y, p4x, p4y 
end

--stats
function mlib.stats.mean( ... )
	local name = {}
	if type( ... ) ~= 'table' then name = { ... } else name = ... end
	local mean = 0
	for i = 1, #name do
		mean = mean + name[i]
	end
	mean = mean / #name
	return mean
end

function mlib.stats.median( ... )
	local name = {}
	if type( ... ) ~= 'table' then name = { ... } else name = ... end
	table.sort( name )
	if #name % 2 == 0 then
		name = ( name[math.floor( #name / 2 )] + name[math.floor( #name / 2 + 1 )] ) / 2
	else
		name =  name[#name / 2 + .5]
	end
	return name
end

function mlib.stats.mode( ... ) 
	local name = {}
	if type( ... ) ~= 'table' then name = { ... } else name = ... end
	table.sort( name )
	local num = { { name[1] } }
	for i = 2, #name do
		if name[i] == num[#num][1] then table.insert( num[#num], name[i] ) 
		else table.insert( num, { name[i] } ) end
	end
	local large = { { #num[1], num[1][1] } }
	for i = 2, #num do
		if #num[i] > large[1][1] then
			for ii = #large, 1, -1 do
				table.remove( large, ii )
			end
		table.insert( large, { #num[i], num[i][1] } )
		elseif #num[i] == large[1][1] then
			table.insert( large, { #num[i], num[i][1] } )
		end
	end
	if #large < 1 then return false elseif #large > 1 then return false else return large[1][2], large[1][1] end
end

function mlib.stats.range( ... )
	local name = {}
	if type( ... ) ~= 'table' then name = { ... } else name = ... end
	local upper, lower = math.max( unpack( name ) ), math.min( unpack( name ) )
	return upper - lower
end

--math
function mlib.math.root( number, root )
	local name = number ^ ( 1 / root )
	return name
end

function mlib.math.prime( ... )
	local num = 0
	local name = false
	if type( ... ) ~= 'table' then num = { ... } else num = ... end
	if #num == 1 then num = num[1] end
	if type( num ) == 'number' then
		if num < 2 then return false end
		for i = 2, math.sqrt( num ) do
			if num % i == 0 then
				return false
			end
		end
		return true
	end
end

function mlib.math.round( num )
	local up_num = math.ceil( num )
	local down_num = math.floor( num )
	local up_dif = up_num - num
	local down_dif = num - down_num
	if up_num == num then
		name = num
	else
		if up_dif <= down_dif then name = up_num elseif down_dif < up_dif then name = down_num end
	end
	return name
end

function mlib.math.log( number, base )
	base = base or 10
	return ( math.log( number ) ) / ( math.log( base ) )
end

function mlib.math.summation( start, stop, func )
	if stop == 1 / 0 or stop == -1 / 0 then return false end
	local ret = {}
	local val = 0
	for a = start, stop do
		local new = func( a, ret )
		ret[a] = new
		val = val + new
	end
	return val
end

function mlib.math.percentOfChange( old, new )
	if old == 0 then return false
	else return ( new - old ) / math.abs( old ) end
end

function mlib.math.percent( percent, num )
	return percent * math.abs( num ) + num 
end

function mlib.math.quadraticFactor( a, b, c )
	local d = b ^ 2 - ( 4 * a * c )
	if d < 0 then return false end
	d = math.sqrt( d )
	return ( -b - d ) / ( 2 * a ), ( -b + d ) / ( 2 * a )
end

function mlib.math.getAngle( ... )
	local angle = 0
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab <= 5 then
		local x1, y1, x2, y2, dir = unpack( tab )
		if not dir or dir == 'up' then dir = math.rad( 90 ) 
			elseif dir == 'right' then dir = 0 
			elseif dir == 'down' then dir = math.rad( -90 )
			elseif dir == 'left' then dir = math.rad( -180 )
		end
		local dx, dy = x2 - x1, y2 - y1
		angle = math.atan2( dy, dx ) + dir
	elseif #tab == 6 then
		local x1, y1, x2, y2, x3, y3 = unpack( tab )
		local AB = mlib.line.length( x1, y1, x2, y2 )
		local BC = mlib.line.length( x2, y2, x3, y3 )
		local AC = mlib.line.length( x1, y1, x3, y3 )
		angle = math.acos( ( BC * BC + AB * AB - AC * AC ) / ( 2 * BC * AB ) )
	end
	return angle
end

--shape
function mlib.shape.new( ... )
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab == 3 then
		tab.type = 'circle'
		tab.x, tab.y, tab.radius = unpack( tab )
		tab.area = mlib.circle.area( tab.radius )
	elseif #tab == 4 then
		tab.type = 'line'
		tab.x1, tab.y1, tab.x2, tab.y2 = unpack( tab )
		tab.slope = mlib.line.slope( unpack( tab ) )
		tab.intercept = mlib.line.intercept( unpack( tab ) )
	else
		tab.type = 'polygon'
		tab.area = mlib.polygon.area( tab )
		tab.points = tab
	end
	tab.collided = false
	tab.index = #mlib.shape.user + 1
	setmetatable( tab, mlib.shape )
	table.insert( mlib.shape.user, tab )
	return tab
end

function mlib.shape:checkCollisions( dt, ... )
	local tab = { ... }
	if type( self ) == 'table' then
		if #tab == 0 then 
			for a = 1, #mlib.shape.user do
				if a ~= self.index then 
					local shape = mlib.shape.user[a]
					self.collided = false
					if self.type == 'line' then 
						if shape.type == 'line' then
							if mlib.line.segment.intersect( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then self.collided, shape.collided = true, true end
						elseif shape.type == 'polygon' then
							if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.points ) then self.collided, shape.collided = true, true end
						elseif shape.type == 'circle' then
							if mlib.circle.secant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then self.collided, shape.collided = true, true end
						end
					elseif self.type == 'polygon' then
						if shape.type == 'line' then
							if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.points ) then self.collided, shape.collided = true, true end
						elseif shape.type == 'polygon' then
							if mlib.polygon.polygonIntersects( self.points, shape.points ) then self.collided, shape.collided = true, true end
						elseif shape.type == 'circle' then
							if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.points ) then self.collided, shape.collided = true, true end
						end
					elseif self.type == 'circle' then
						if shape.type == 'line' then
							if mlib.circle.secant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then self.collided, shape.collided = true, true end
						elseif shape.type == 'polygon' then
							if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.points ) then self.collided, shape.collided = true, true end
						elseif shape.type == 'circle' then
							if mlib.circle.circlesIntersect( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then self.collided, shape.collided = true, true end
						end
					end
				end
			end
		else
			for a = 1, #tab do
				local shape = tab[a]
				self.collided = false
				if self.type == 'line' then 
					if shape.type == 'line' then
						if mlib.line.segment.intersect( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then self.collided, shape.collided = true, true end
					elseif shape.type == 'polygon' then
						if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.points ) then self.collided, shape.collided = true, true end
					elseif shape.type == 'circle' then
						if mlib.circle.secant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then self.collided, shape.collided = true, true end
					end
				elseif self.type == 'polygon' then
					if shape.type == 'line' then
						if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.points ) then self.collided, shape.collided = true, true end
					elseif shape.type == 'polygon' then
						if mlib.polygon.polygonIntersects( self.points, shape.points ) then self.collided, shape.collided = true, true end
					elseif shape.type == 'circle' then
						if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.points ) then self.collided, shape.collided = true, true end
					end
				elseif self.type == 'circle' then
					if shape.type == 'line' then
						if mlib.circle.secant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then self.collided, shape.collided = true, true end
					elseif shape.type == 'polygon' then
						if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.points ) then self.collided, shape.collided = true, true end
					elseif shape.type == 'circle' then
						if mlib.circle.circlesIntersect( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then self.collided, shape.collided = true, true end
					end
				end
			end
		end
	else
		local tab = { unpack( tab ) }
		if #tab == 0 then 
			for a = 1, #mlib.shape.user do
				local self = mlib.shape.user[a]
				for e = 1, #mlib.shape.user do
					if a ~= e then 
						local shape = mlib.shape.user[e]
						self.collided, shape.collided = false, false
						if self.type == 'line' then 
							if shape.type == 'line' then
								if mlib.line.segment.intersect( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.points ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.circle.secant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then self.collided, shape.collided = true, true end
							end
						elseif self.type == 'polygon' then
							if shape.type == 'line' then
								if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.points ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.polygonIntersects( self.points, shape.points ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.points ) then self.collided, shape.collided = true, true end
							end
						elseif self.type == 'circle' then
							if shape.type == 'line' then
								if mlib.circle.secant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.points ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.circle.circlesIntersect( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then self.collided, shape.collided = true, true end
							end
						end
					end
				end
			end
		else
			for a = 1, #tab do
				local self = tab[a]
				for e = 1, #tab do
					if self.index ~= tab[e].index then 
						local shape = tab[e]
						self.collided, shape.collided = false, false
						if self.type == 'line' then 
							if shape.type == 'line' then
								if mlib.line.segment.intersect( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.points ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.circle.secant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then self.collided, shape.collided = true, true end
							end
						elseif self.type == 'polygon' then
							if shape.type == 'line' then
								if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.points ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.polygonIntersects( self.points, shape.points ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.points ) then self.collided, shape.collided = true, true end
							end
						elseif self.type == 'circle' then
							if shape.type == 'line' then
								if mlib.circle.secant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.points ) then self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.circle.circlesIntersect( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then self.collided, shape.collided = true, true end
							end
						end
					end
				end
			end
		end
	end
end

return mlib