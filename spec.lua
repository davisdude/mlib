require 'telescope'
local _ = require 'mlib'

context( 'MLib', function()	
	before( function() end )
	after( function() end ) 
	
	local function check_fuzzy( a, b )
		return ( a - .00001 <= b and b <= a + .00001 )
	end
	
	local function DeepCompare( Table1, Table2 )
		if type( Table1 ) ~= type( Table2 ) then return false end
		
		for Key, Value in pairs( Table1 ) do
			if ( type( Value ) == 'table' and type( Table2[Key] ) == 'table' ) then
				if ( not DeepCompare( Value, Table2[Key] ) ) then return false end
			else
				if type( Value ) ~= type( Table2[Key] ) then return false end
				if type( Value ) == 'number' then
					return check_fuzzy( Value, Table2[Key] )
				elseif ( Value ~= Table2[Key] ) then return false end
			end
		end
		for Key, Value in pairs( Table2 ) do
			if ( type( Value ) == 'table' and type( Table1[Key] ) == 'table' ) then
				if ( not DeepCompare( Value, Table1[Key] ) ) then return false end
			else
				if type( Value ) ~= type( Table1[Key] ) then return false end
				if type( Value ) == 'number' then
					return check_fuzzy( Value, Table1[Key] )
				elseif ( Value ~= Table1[Key] ) then return false end
			end
		end
		return true
	end
	
	make_assertion( 'fuzzy_equal', 'fuzzy values to be equal to each other', 
		function( a, b )
			return check_fuzzy( a, b ) 
		end 
	)
	
	make_assertion( 'multiple_fuzzy_equal', 'all fuzzy values to equal respective fuzzy value', 
		function( a, b )
			for i = 1, #a do 
				if type( a[i] ) ~= 'number' then 
					if a[i] ~= b[i] then return false end 
				else 
					if not check_fuzzy( a[i], b[i] ) then 
						return false 
					end 
				end 
			end 
			return true 
		end 
	)		
	
	make_assertion( 'tables_fuzzy_equal', 'all table values are equal', 
		function( Table1, Table2 )
			return DeepCompare( Table1, Table2 )
		end
	)
	
	context( 'Line', function()
		context( 'GetLength', function()
			test( 'Gives the length of a line.', function()
				assert_fuzzy_equal( _.Line.GetLength( 1, 1, 1, 2 ), 1 )
				assert_fuzzy_equal( _.Line.GetLength( 0, 0, 1, 0 ), 1 )
				assert_fuzzy_equal( _.Line.GetLength( 4, 4, 7, 8 ), 5 )
				assert_fuzzy_equal( _.Line.GetLength( 9.3, 7.6, -12, .001 ), 22.61492 )
				assert_fuzzy_equal( _.Line.GetLength( 4.2, 4.134, 7.2342, -78 ), 82.190025 )
			end )
		end )
		
		context( 'GetMidpoint', function()
			test( 'Gives the midpoint of a line.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetMidpoint( 0, 0, 2, 2 ) }, { 1, 1 } )
				assert_multiple_fuzzy_equal( { _.Line.GetMidpoint( 4, 4, 7, 8 ) }, { 5.5, 6 } )
				assert_multiple_fuzzy_equal( { _.Line.GetMidpoint( -1, 2, 3, -6 ) }, { 1, -2 } )
				assert_multiple_fuzzy_equal( { _.Line.GetMidpoint( 6.4, 3, -10.7, 4 ) }, { -2.15, 3.5 } )
				assert_multiple_fuzzy_equal( { _.Line.GetMidpoint( 3.14159, 3.14159, 2.71828, 2.71828 ) }, { 2.92993, 2.92993 } )
			end )
		end )
		
		context( 'GetSlope', function()
			test( 'Gives the slope of a line given two points.', function()
				assert_fuzzy_equal( _.Line.GetSlope( 1, 1, 2, 2 ), 1 )
				assert_fuzzy_equal( _.Line.GetSlope( 1, 1, 0, 1 ), 0 )
				assert_fuzzy_equal( _.Line.GetSlope( 1, 0, 0, 1 ), -1 )
			end )
			
			test( 'Returns false if the slope is vertical.', function()
				assert_false( _.Line.GetSlope( 1, 0, 1, 5 ) )
				assert_false( _.Line.GetSlope( -4, 9, -4, 13423 ) )
			end )
		end )
		
		context( 'GetPerpendicularSlope', function()
			test( 'Gives the perpendicular slope given two points.', function()
				assert_fuzzy_equal( _.Line.GetPerpendicularSlope( 1, 1, 2, 2 ), -1 )
			end )
			
			test( 'Gives the perpendicular slope given the slope.', function()
				assert_fuzzy_equal( _.Line.GetPerpendicularSlope( 2 ), -.5 )
			end )
			
			test( 'Gives the perpendicular slope if the initial line is vertical.', function()
				assert_fuzzy_equal( _.Line.GetPerpendicularSlope( 1, 0, 1, 5 ), 0 )
				assert_fuzzy_equal( _.Line.GetPerpendicularSlope( false ), 0 )
			end )
			
			test( 'Returns false if the initial slope is horizontal.', function()
				assert_false( _.Line.GetPerpendicularSlope( 0, 0, 5, 0 ) )
			end )
		end )
		
		context( 'GetPerpendicularBisector', function()
			test( 'Returns the midpoint and perpendicular slope given two points.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetPerpendicularBisector( 1, 1, 3, 3 ) }, { 2, 2, -1 } )
				assert_multiple_fuzzy_equal( { _.Line.GetPerpendicularBisector( 1, 0, 1, 8 ) }, { 1, 4, 0 } )
				assert_multiple_fuzzy_equal( { _.Line.GetPerpendicularBisector( 4, 4, 6, 8 ) }, { 5, 6, -.5 } )
			end )
			
			test( 'Returns false and midpoint if original slope is horizontal.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetPerpendicularBisector( 0, 0, 6, 0 ) }, { 3, 0, false } )
				assert_multiple_fuzzy_equal( { _.Line.GetPerpendicularBisector( 5, 7, 10, 7 ) }, { 7.5, 7, false } )
			end )
		end )
		
		context( 'GetIntercept', function()
			test( 'Gives the y-intercept given two points.', function()
				assert_fuzzy_equal( _.Line.GetIntercept( 0, 0, 1, 1 ), 0 )
				assert_fuzzy_equal( _.Line.GetIntercept( 2, 3, 4, 9 ), -3 )
			end )
			
			test( 'Gives the y-intercept given one point and the slope.', function()
				assert_fuzzy_equal( _.Line.GetIntercept( 0, 0, 1 ), 0 )
			end )
			
			test( 'Returns false if the slope is false.', function()
				assert_false( _.Line.GetIntercept( 1, 0, 1, 5 ) )
				assert_false( _.Line.GetIntercept( 0, 0, false ) )
			end )
		end )
		
		context( 'GetIntersection', function()
			test( 'Given the slope, y-intercept, and two points of other line.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetIntersection( 1, 0, 1, 0, 0, 1 ) }, { .5, .5 } )
			end )
			
			test( 'Given the slope, y-intercept, the other slope and y-intercept.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetIntersection( 1, 0, -1, 1 ) }, { .5, .5 } )
			end )
			
			test( 'Given two points on one line and two on the other.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetIntersection( 1, 1, 0, 0, 1, 0, 0, 1 ) }, { .5, .5 } )
			end )
			
			test( 'Works for vertical lines.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetIntersection( 1, 0, 1, 5, 2, 2, 0, 2 ) }, { 1, 2 } )
			end )
			
			test( 'Returns false if the lines are parallel.', function()
				assert_false( _.Line.GetIntersection( 2, 4, 2, 7 ) )
			end )
		end )
		
		context( 'GetClosestPoint', function()
			test( 'Given the point and two points on the line.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetClosestPoint( 4, 2, 1, 1, 3, 5 ) }, { 2, 3 } )
				assert_multiple_fuzzy_equal( { _.Line.GetClosestPoint( 3, 5, 3, 0, 2, 2 ) }, { 1, 4 } )
				assert_multiple_fuzzy_equal( { _.Line.GetClosestPoint( -1, 3, -2, 0, 2, 2 ) }, { 0, 1 } )
			end )
			
			test( 'Given the the point and the slope and y-intercept.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetClosestPoint( 4, 2, 2, -1 ) }, { 2, 3 } )
				assert_multiple_fuzzy_equal( { _.Line.GetClosestPoint( -1, 3, .5, 1 ) }, { 0, 1 } )
			end )
		end )
		
		context( 'GetSegmentIntersection', function()
			test( 'Given the end points of the segment and 2 points on the line.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetSegmentIntersection( 3, 6, 5, 8, 3, 8, 5, 6 ) }, { 4, 7 } )
				assert_multiple_fuzzy_equal( { _.Line.GetSegmentIntersection( 0, 0, 4, 4, 0, 4, 4, 0 ) }, { 2, 2 } )
			end ) 
			
			test( 'Given end points of the segmen and the slope and intercept.', function()
				assert_multiple_fuzzy_equal( { _.Line.GetSegmentIntersection( 3, 6, 5, 8, -1, 11 ) }, { 4, 7 } )
			end )
			
			test( 'Returns false if they don\'t intersect.', function()
				assert_false( _.Line.GetSegmentIntersection( 0, 0, 1, 1, 0, 4, 4, 0 ) )
				assert_false( _.Line.GetSegmentIntersection( 0, 0, 1, 1, -1, 4 ) )
			end )
		end )
		
		context( 'Segment', function()
			context( 'CheckPoint', function()
				test( 'Returns true if the point is on the segment.', function()
					assert_true( _.Line.Segment.CheckPoint( 2, 2, 0, 0, 1, 1 ) )
					assert_true( _.Line.Segment.CheckPoint( 1, 4, 5, 12, 3, 8 ) )
					assert_true( _.Line.Segment.CheckPoint( -1, 4, 0, 0, -.5, 2 ) )
				end )
				
				test( 'Returns false if the point is not on the segment.', function()
					assert_false( _.Line.Segment.CheckPoint( 2, 2, 0, 0, 3, 1 ) )
					assert_false( _.Line.Segment.CheckPoint( 1, 4, 5, 12, 3, 9 ) )
				end )
			end )
			
			context( 'GetIntersection', function()
				test( 'Returns the point of intersection if they do.', function()
					assert_multiple_fuzzy_equal( { _.Line.Segment.GetIntersection( 1, 1, 5, 3, 2, 3, 4, 1 ) }, { 3, 2, nil, nil } )
					assert_multiple_fuzzy_equal( { _.Line.Segment.GetIntersection( 0, 0, 3, 3, 0, 1, 3, 1 ) }, { 1, 1, nil, nil } )
				end )
				
				test( 'Returns false if they don\'t.', function()
					assert_multiple_fuzzy_equal( { _.Line.Segment.GetIntersection( 3, 7, 6, 8, 1, 6, 5, 4 ) }, { false, nil, nil, nil } )
				end )
				
				test( 'Return x1, y1, x2, y2 if lines have same slope and intercept.', function()
					assert_multiple_fuzzy_equal( { _.Line.Segment.GetIntersection( 0, 0, 2, 2, 1, 1, 3, 3 ) }, { 1, 1, 2, 2 } )
					assert_multiple_fuzzy_equal( { _.Line.Segment.GetIntersection( 0, 1, 4, 1, 2, 1, 3, 1 ) }, { 2, 1, 3, 1 } )
				end )
			end )
		end )
	end )
	
	context( 'Polygon', function()
		context( 'GetTriangleHeight', function()
			test( 'Given points of triangle and length of base.', function()
				assert_multiple_fuzzy_equal( { _.Polygon.GetTriangleHeight( 3, 0, 0, 0, 4, 3, 0 ) }, { 4, 6 } )
				assert_multiple_fuzzy_equal( { _.Polygon.GetTriangleHeight( 6, -2, 1, 2, 4, 4, 1 ) }, { 3, 9 } )
				assert_multiple_fuzzy_equal( { _.Polygon.GetTriangleHeight( 3, 1, 1, 3, 4, 0, 4 ) }, { 3, 4.5 } )
			end )
			
			test( 'Given the length of the base and the area.', function()
				assert_fuzzy_equal( _.Polygon.GetTriangleHeight( 3, 6 ), 4 )
				assert_fuzzy_equal( _.Polygon.GetTriangleHeight( 6, 9 ), 3 )
			end )
		end )
		
		context( 'GetSignedArea', function()
			test( 'Gives the sigend area of the shape. Positive if clockwise.', function()
				assert_fuzzy_equal( _.Polygon.GetSignedArea( 0, 0, 3, 0, 3, 4, 0, 4 ), 12 )
				assert_fuzzy_equal( _.Polygon.GetSignedArea( 0, 0, 3, 0, 0, 4 ), 6 )
				assert_fuzzy_equal( _.Polygon.GetSignedArea( 4, 4, 0, 4, 0, 0, 4, 0 ), 16 )
			end )
			
			test( 'Negative if counter clock-wise.', function()
				assert_fuzzy_equal( _.Polygon.GetSignedArea( 0, 0, 0, 4, 3, 4, 3, 0 ), -12 )
				assert_fuzzy_equal( _.Polygon.GetSignedArea( 0, 0, 0, 4, 3, 0 ), -6 )
			end )
		end )
		
		context( 'GetArea', function()
			test( 'Gives the sigend area of the shape. Positive if clockwise.', function()
				assert_fuzzy_equal( _.Polygon.GetArea( 0, 0, 3, 0, 3, 4, 0, 4 ), 12 )
				assert_fuzzy_equal( _.Polygon.GetArea( 0, 0, 3, 0, 0, 4 ), 6 )
				assert_fuzzy_equal( _.Polygon.GetArea( 4, 4, 0, 4, 0, 0, 4, 0 ), 16 )
			end )
			
			test( 'Gives the area of the shape. Negative if counter clock-wise.', function()
				assert_fuzzy_equal( _.Polygon.GetArea( 0, 0, 0, 4, 3, 4, 3, 0 ), 12 )
				assert_fuzzy_equal( _.Polygon.GetArea( 0, 0, 0, 4, 3, 0 ), 6 )
			end )
		end )
		
		context( 'GetCentroid', function()
			test( 'Gives the x and y of the centroid.', function()
				assert_multiple_fuzzy_equal( { _.Polygon.GetCentroid( 0, 0, 0, 4, 4, 4, 4, 0 ) }, { 2, 2 } )
				assert_multiple_fuzzy_equal( { _.Polygon.GetCentroid( 0, 0, 0, 6, 3, 0 ) }, { 1, 2 } )
				assert_multiple_fuzzy_equal( { _.Polygon.GetCentroid( 2, -1, 2, 1, 1, 2, -1, 2, -2, 1, -2, -1, -1, -2, 1, -2 ) }, { 0, 0 } )
				assert_multiple_fuzzy_equal( { _.Polygon.GetCentroid( 2, 0, 3, 0, 4, 1, 3, 2, 2, 2, 1, 1 ) }, { 2.5, 1 } )
				assert_multiple_fuzzy_equal( { _.Polygon.GetCentroid( 3, 5, 2, 2, 4, 2 ) }, { 3, 3 } )
			end )
		end )
		
		context( 'CheckPoint', function()
			test( 'Returns true if the point is in the polygon.', function()
				assert_true( _.Polygon.CheckPoint( 2, 2, 0, 0, 0, 4, 4, 4, 4, 0 ) )
				assert_true( _.Polygon.CheckPoint( 1, 1, 0, 0, 2, 0, 2, 2, 0, 2 ) )
				assert_true( _.Polygon.CheckPoint( 3, 2, 2, 2, 3, 1, 4, 3, 5, 2, 4, 4 ) )
			end )
			
			test( 'Returns false if the point is not.', function()
				assert_false( _.Polygon.CheckPoint( 7, 8, 0, 0, 0, 4, 4, 4, 4, 0 ) )
				assert_false( _.Polygon.CheckPoint( -1, 1, 0, 0, 2, 0, 2, 2, 0, 2 ) )
			end )
		end )
		
		context( 'LineIntersects', function()
			test( 'Returns true if the line intersects the polygon.', function()
				local tab = _.Polygon.LineIntersects( 0, 4, 4, 4, 0, 0, 0, 4, 4, 4, 4, 0 )
				assert_tables_fuzzy_equal( tab, { { 0, 4 }, { 4, 4 } } )
				local tab2 = _.Polygon.LineIntersects( 0, 4, 4, 0, 0, 0, 0, 4, 4, 4, 4, 0 )
				assert_tables_fuzzy_equal( tab2, { { 0, 4 }, { 4, 0 } } )
			end )
			
			test( 'Returns false if the line does not intersect.', function()
				assert_false( _.Polygon.LineIntersects( 0, 5, 5, 5, 0, 0, 0, 4, 4, 4, 4, 0 ) )
			end )
			
			test( 'Works with vertical lines.', function()
				local tab = _.Polygon.LineIntersects( 0, 0, 0, 4, 0, 0, 0, 4, 4, 4, 4, 0 )
				assert_tables_fuzzy_equal( tab, { { 0, 4 }, { 0, 0 } } )
				assert_false( _.Polygon.LineIntersects( -1, 0, -1, 5, 0, 0, 0, 4, 4, 4, 4, 0 ) )
			end )
		end )
		
		context( 'PolygonIntersects', function()
			test( 'Returns true if the polygons intersect.', function()
				local tab = _.Polygon.PolygonIntersects( { 2, 6, 3, 8, 4, 6 }, { 3, 7, 2, 9, 4, 9 } )
				assert_tables_fuzzy_equal( tab, { { 2.75, 7.5 }, { 3.25, 7.5 } } )
				tab = _.Polygon.PolygonIntersects( { 3, 5, 4, 4, 3, 3, 2, 3, 1, 4, 1, 2, 3, 2, 5, 4, 3, 6, 1, 6 }, { 0, 6, 4, 5, 2, 4 } )
				assert_tables_fuzzy_equal( tab, { { 3.33333, 6.66666 }, { 4, 5 }, { 2, 5.5 } } )
			end )
			
			test( 'Returns false if the polygons don\'t intersect.', function()
				assert_false( _.Polygon.PolygonIntersects( { 2, 6, 3, 8, 4, 6 }, { 4, 7, 3, 9, 5, 9 } ) )
				assert_false( _.Polygon.PolygonIntersects( { 3, 5, 4, 4, 3, 3, 2, 3, 1, 4, 1, 2, 3, 2, 5, 4, 3, 6, 1, 6 }, { 0, 6, 3, 4, 2, 4 } ) )
			end )
			
			test( 'Works with vertical lines.', function()
				local tab = _.Polygon.PolygonIntersects( { 2, 3, 2, 6, 4, 6, 4, 4, 5, 5, 5, 3 }, { 3, 2, 3, 5, 6, 4, 6, 3, 4, 3, 4, 2 } )
				assert_tables_fuzzy_equal( tab, { { 4, 4.66666 }, { 4.5, 4.5 }, { 5, 4.33333 }, { 5, 3 }, { 3, 3 }, { 4, 3 } } )
			end )
		end )
		
		context( 'CircleIntersects', function()
			test( 'Returns true if the circle intersects', function()
				local tab = _.Polygon.CircleIntersects( 3, 5, 2, 3, 1, 3, 6, 7, 4 )
				assert_tables_fuzzy_equal( tab, { { 'Tangent', 3, 3 }, { 'Tangent', 5, 5 } } )
				tab = _.Polygon.CircleIntersects( 5, 5, 1, 4, 4, 6, 4, 6, 6, 4, 6 )
				assert_tables_fuzzy_equal( tab, { { 'Tangent', 5, 4 }, { 'Tangent', 6, 5 }, { 'Tangent', 5, 6 }, { 'Tangent', 4, 5 } } )
				tab = _.Polygon.CircleIntersects( 3, 4, 2, 3, 3, 2, 4, 3, 5, 4, 4 )
				assert_tables_fuzzy_equal( tab, { { 'Enclosed', 3, 3, 2, 4 }, { 'Enclosed', 2, 4, 3, 5 }, { 'Enclosed', 3, 5, 4, 4 }, { 'Enclosed', 4, 4, 3, 3 } } )
			end )
			
			test( 'Returns false if the circle doesn\'t intersect.', function()
				assert_false( _.Polygon.CircleIntersects( 9, 9, 2, 3, 1, 3, 6, 7, 4 ) )
				assert_false( _.Polygon.CircleIntersects( 10, 5, 1, 4, 4, 6, 4, 6, 6, 4, 6 ) )
			end )
		end )
		
		context( 'IsPolygonInside', function()
			test( 'Returns true if polygon2 is inside', function()
				assert_true( _.Polygon.IsPolygonInside( { 0, 0, 0, 4, 4, 4, 4, 0 }, { 2, 2, 2, 3, 3, 3, 3, 2 } ) )
			end )
			
			test( 'Returns false if polygon2 is outside', function()
				assert_false( _.Polygon.IsPolygonInside( { 0, 0, 0, 4, 4, 4, 4, 0 }, { 5, 5, 5, 7, 7, 7, 7, 5 } ) )
			end )
		end )
	end )
	
	context( 'Circle', function()
		context( 'GetArea', function()
			test( 'Gives the area of the circle.', function()
				assert_fuzzy_equal( _.Circle.GetArea( 1 ), 3.14159 )
				assert_fuzzy_equal( _.Circle.GetArea( 2 ), 12.56637 )
				assert_fuzzy_equal( _.Circle.GetArea( 5 ), 78.53981 )
				assert_fuzzy_equal( _.Circle.GetArea( 10 ), 314.15926 )
				assert_fuzzy_equal( _.Circle.GetArea( 20 ), 1256.63706 )
			end )
		end )
		
		context( 'CheckPoint', function()
			test( 'Returns true if the point is on the circle.', function()
				assert_true( _.Circle.CheckPoint( 3, 4, 2, 1, 4 ) )
				assert_true( _.Circle.CheckPoint( 2, 2, 1, 2, 1 ) )
				assert_true( _.Circle.CheckPoint( 2, 4, 2, 0, 4 ) )
			end )
			
			test( 'Returns false if the point is not on the circle.', function()
				assert_false( _.Circle.CheckPoint( 3, 4, 2, 2, 4 ) )
				assert_false( _.Circle.CheckPoint( 2, 2, 1, 2, 2 ) )
			end )
		end )
		
		context( 'GetCircumference', function()
			test( 'Gives the circumference of the circle.', function()
				assert_fuzzy_equal( _.Circle.GetCircumference( 1 ), 6.28318 )
				assert_fuzzy_equal( _.Circle.GetCircumference( 2 ), 12.56637 )
				assert_fuzzy_equal( _.Circle.GetCircumference( 5 ), 31.41592 )
				assert_fuzzy_equal( _.Circle.GetCircumference( 10 ), 62.83185 )
				assert_fuzzy_equal( _.Circle.GetCircumference( 20 ), 125.66370 )
			end )
		end )
		
		context( 'IsLineSecant', function()
			test( 'Returns \'Secant\' when intersects twice.', function()
				assert_multiple_fuzzy_equal( { _.Circle.IsLineSecant( 4, 9, 1, 0, 9, 6, 9 ) }, { 'Secant', 3, 9, 5, 9 } )
				assert_multiple_fuzzy_equal( { _.Circle.IsLineSecant( 2, 2, 1, 2, 3, 3, 2 ) }, { 'Secant', 2, 3, 3, 2 } )
			end )
			
			test( 'Returns \'Tangent\' when intersects once.', function()
				assert_multiple_fuzzy_equal( { _.Circle.IsLineSecant( 4, 9, 1, 0, 8, 6, 8 ) }, { 'Tangent', 4, 8 } )
				assert_multiple_fuzzy_equal( { _.Circle.IsLineSecant( 2, 2, 1, 2, 3, 0, 3 ) }, { 'Tangent', 2, 3 } )
			end )
			
			test( 'Returns \'false\' when neither.', function()
				assert_false( _.Circle.IsLineSecant( 4, 9, 1, 0, 7, 6, 8 ) )
			end )
		end )
		
		context( 'IsSegmentSecant', function()
			test( 'Returns \'Secant\' if the line connects two points.', function()
				assert_multiple_fuzzy_equal( { _.Circle.IsSegmentSecant( 4, 9, 1, 0, 9, 6, 9 ) }, { 'Secant', 3, 9, 5, 9 } )
			end )
			
			test( 'Returns \'Tangent\' if the line attaches only one point.', function()
				assert_multiple_fuzzy_equal( { _.Circle.IsSegmentSecant( 1, 1, 1, 0, 0, 0, 2 ) }, { 'Tangent', 0, 1 } )
			end )
			
			test( 'Returns \'Chord\' if both points are on the circle.', function()
				assert_multiple_fuzzy_equal( { _.Circle.IsSegmentSecant( 0, 0, 1, -1, 0, 1, 0 ) }, { 'Chord', -1, 0, 1, 0 } )
			end )
			
			test( 'Returns \'Enclosed\' if the line is within the circle entirely.', function()
				assert_multiple_fuzzy_equal( { _.Circle.IsSegmentSecant( 0, 0, 2, -1, 0, 1, 0 ) }, { 'Enclosed', -1, 0, 1, 0 } )
			end )
			
			test( 'Returns \'false\' if the line doesn\'t touch anywhere.', function()
				assert_false( _.Circle.IsSegmentSecant( 0, 0, 1, 2, 2, 2, 3 ) )
			end )
		end )
		
		context( 'CirclesIntersect', function()
			test( 'Returns true if the point is within the circle.', function() 
				assert_multiple_fuzzy_equal( { _.Circle.CircleIntersects( 0, 0, 4, 0, 4, 8 ) }, { 0, -4, 0, -4 } )
			end )
			
			test( 'Returns \'Equal\' if the circles are the same.', function()
				assert_equal( _.Circle.CircleIntersects( 0, 0, 4, 0, 0, 4 ), 'Equal' )
			end )
			
			test( 'Returns \'Colinear\' if circles have same x and y but not radii.', function()
				assert_equal( _.Circle.CircleIntersects( 0, 0, 4, 0, 0, 8 ), 'Colinear' )
				assert_equal( _.Circle.CircleIntersects( 0, 0, 8, 0, 0, 4 ), 'Colinear' )
			end )
			
			test( 'Returns false if the point is not within the cirlce.', function()
				assert_false( _.Circle.CircleIntersects( 4, 4, 1, 6, 6, 1 ) )
			end )
		end )
		
		context( 'IsPointInCircle', function()
			test( 'Returns true if the point is within the circle.', function() 
				assert_true( _.Circle.IsPointInCircle( 0, 0, 2, 1, 1 ) )
				assert_true( _.Circle.IsPointInCircle( 5, 5, 5, 2, 2 ) )
				assert_true( _.Circle.IsPointInCircle( -3, 9, 2, -2, 8 ) )
			end )
			
			test( 'Returns false if the point is not within the cirlce.', function()
				assert_false( _.Circle.IsPointInCircle( 0, 0, 2, 5, 1 ) )
				assert_false( _.Circle.IsPointInCircle( -3, 9, 2, -2, 7 ) )
			end )
		end )
	end )
	
	context( 'Statistics', function()
		context( 'GetMean', function()
			test( 'Gives the arithmetic mean of numbers.', function()
				assert_equal( _.Statistics.GetMean( 1, 2, 3, 4, 5 ), 3 )
				assert_equal( _.Statistics.GetMean( 10, 10, 10, 10 ), 10 )
			end )
		end )
		
		context( 'GetMedian', function()
			test( 'Gives the median of numbers.', function()
				assert_equal( _.Statistics.GetMedian( 1, 2, 3, 4, 5 ), 3 )
			end )
			
			test( 'Gives average of two numbers if the amount of numbers is even.', function()
				assert_equal( _.Statistics.GetMedian( 1, 2, 3, 4, 5, 6 ), 3.5 )
			end )
			
			test( 'Works when the numbers aren\'t ordered, too.', function()
				assert_equal( _.Statistics.GetMedian( 5, 3, 4, 2, 1 ), 3 )
				assert_equal( _.Statistics.GetMedian( 3, 4, 1, 2, 5, 6 ), 3.5 )
			end )
		end )
		
		context( 'GetMode', function()
			test( 'Returns the mode.', function()
				assert_tables_fuzzy_equal( { _.Statistics.GetMode( math.pi, math.huge, math.pi ) }, { { math.pi }, 2 } )
			end	)
			
			test( 'Works if it\'s bimodial, too', function()
				assert_tables_fuzzy_equal( { _.Statistics.GetMode( 2, 2, 1, 1, 3 ) }, { { 1, 2 }, 2 } )
			end	)
		end	)
		
		context( 'GetRange', function()
			test( 'Returns the range.', function()
				assert_equal( _.Statistics.GetRange( 1, 2, 3, 4 ), 3 )
				assert_equal( _.Statistics.GetRange( 100, 5, 3, 6, 7 ), 97 )
			end )
		end )
	end )
	
	context( 'Math', function()
		context( 'GetRoot', function()
			test( 'Gives the nth root to x, given n and x.', function()
				assert_multiple_fuzzy_equal( { _.Math.GetRoot( 4, 2 ) }, { 2, -2 } )
				assert_multiple_fuzzy_equal( { _.Math.GetRoot( 16, 2 ) }, { 4, -4 } )
				assert_multiple_fuzzy_equal( { _.Math.GetRoot( 4, -2 ) }, { .5, -.5 } )
			end )
		end )
		
		context( 'IsPrime', function()
			test( 'Returns true if a number is prime.', function()
				assert_true( _.Math.IsPrime( 3 ) )
				assert_true( _.Math.IsPrime( 2 ) )
				assert_true( _.Math.IsPrime( 47 ) )
			end )
			
			test( 'Returns false if a number is not prime.', function()
				assert_false( _.Math.IsPrime( 1 ) )
				assert_false( _.Math.IsPrime( 100 ) )
			end )
		end )
		
		context( 'Round', function()
			test( 'Rounds down if the number is less than .5.', function()
				assert_equal( _.Math.Round( 3.4 ), 3 )
			end )
			
			test( 'Rounds up if the number is more than .5.', function()
				assert_equal( _.Math.Round( 6.7 ), 7 )
			end )
			
			test( 'Specify the number of decimal places to use.', function()
				assert_equal( _.Math.Round( 197.88, 2 ), 197.88 )
				assert_equal( _.Math.Round( 197.88, 1 ), 197.9 )
				assert_equal( _.Math.Round( 197, -2 ), 200 )
			end )
		end )
		
		context( 'Summation', function()
			test( 'Adds up numbers and such.', function()
				assert_equal( _.Math.GetSummation( 1, 10, function( i ) return ( i * 2 ) end ), 110 )
			end )
			
			test( 'Can access previous values with second function argument.', function()
				assert_equal( _.Math.GetSummation( 1, 5, function( i, t ) if t[i-1] then return i + t[i-1] else return 1 end end ), 35 )
			end )
		end )
		
		context( 'GetPercentOfChange', function()
			test( 'Gives the percentage of change.', function()
				assert_equal( _.Math.GetPercentOfChange( 2, 4 ), 1 )
				assert_equal( _.Math.GetPercentOfChange( 4, 2 ), -.5 )
				assert_equal( _.Math.GetPercentOfChange( 4, 0 ), -1 )
				assert_equal( _.Math.GetPercentOfChange( 0, 0 ), 0 )
			end )
			
			test( 'False if original is 0.', function()
				assert_false( _.Math.GetPercentOfChange( 0, 3 ) )
			end )
		end )
		
		context( 'GetPercent', function()
			test( 'Gives the percent.', function()
				assert_equal( _.Math.GetPercent( 1, 2 ), 2 )
				assert_equal( _.Math.GetPercent( 2, 1 ), 2 )
				assert_equal( _.Math.GetPercent( .5, 50 ), 25 )
				assert_equal( _.Math.GetPercent( 50, 2 ), 100 )
				assert_equal( _.Math.GetPercent( -.5, 4 ), 2 )
			end )
		end )
		
		context( 'GetRootsOfQuadratic', function()
			test( 'Gives roots given a, b, and c.', function()
				assert_multiple_fuzzy_equal( { _.Math.GetRootsOfQuadratic( 1, -3, -4 ) }, { -1, 4 } )
				assert_multiple_fuzzy_equal( { _.Math.GetRootsOfQuadratic( 1, 0, -4 ) }, { -2, 2 } )
				assert_multiple_fuzzy_equal( { _.Math.GetRootsOfQuadratic( 6, 11, -35 ) }, { -3.5, 5/3 } )
			end )
			
			test( 'Returns false it has no roots.', function()
				assert_false( _.Math.GetRootsOfQuadratic( 1, 2, 4 ) )
				assert_false( _.Math.GetRootsOfQuadratic( .6, .3, .9 ) )
			end )
		end )
		
		context( 'GetAngle', function()
			test( 'Gives the angle between three points.', function()
				assert_fuzzy_equal( _.Math.GetAngle( 1, 3, 1, 1, 3, 1 ), 1.57079633 )
				assert_fuzzy_equal( _.Math.GetAngle( 4, 4, 1, 1, 4, 1 ), 0.785398163 )
			end )
		end )
	end )
end )