local telescope = require( 'telescope' )
local line = require( 'mlib.line' )

-- Make sure all functions are checked
local checked = {}
for i in pairs( line ) do
	checked[i] = false
end

local oldContext = context
function context( name, func )
	checked[name] = true
	oldContext( name, func )
end

telescope.make_assertion( 'fuzzy_equal', '%s to be fuzzy equal to %s', function( a, b )
	return math.abs( a - b ) <= .001
end )

telescope.make_assertion( 'error_equals', '%s to be equal to %s', function( a, b )
	-- Escape `a` special characters
	a = a:gsub( '([()^$.%%])', function( m )
		return '%' .. m
	end )

	-- Get b
	local _, err = pcall( b )

	-- See if they match
	return not not err:match( a )
end )

context( 'line', function()
	context( 'getSlope', function()
		test( 'Gets the slope of a line', function()
			assert_fuzzy_equal( 1, line.getSlope( 0,0, 1,1 ) )
			assert_fuzzy_equal( 1 / 3, line.getSlope( 0,0, 3,1 ) )
		end )

		test( 'Returns `false` for vertical lines', function()
			assert_false( line.getSlope( 1,3, 1,5 ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.getSlope: y2: Expected number, got nil', function()
				line.getSlope( 0,0, 3 )
			end )
		end )
	end )

	context( 'getPerpendicularSlope', function()
		test( 'Gets the perpendicular slope of a line', function()
			assert_fuzzy_equal( -1, line.getPerpendicularSlope( 1 ) )
			assert_fuzzy_equal( -1, line.getPerpendicularSlope( 0,0, 1,1 ) )
		end )

		test( 'Works with vertical and horizontal lines', function()
			assert_fuzzy_equal( 0, line.getPerpendicularSlope( 0,0, 0,3 ) )
			assert_fuzzy_equal( 0, line.getPerpendicularSlope( false ) )
			assert_false( line.getPerpendicularSlope( 0,3, 3,3 ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.getPerpendicularSlope: m: Expected boolean (false) or number, got string', function()
				line.getPerpendicularSlope( '1' )
			end )

			assert_error_equals( 'MLib.line.getPerpendicularSlope: x2: Expected number, got nil', function()
				line.getPerpendicularSlope( 1,1 )
			end )
		end )
	end )

	context( 'getYIntercept', function()
		test( 'Gets the y-intercept slope of a line', function()
			assert_fuzzy_equal( 0, line.getYIntercept( 1, 1,1 ) )
			assert_fuzzy_equal( 1, line.getYIntercept( 1,2, 2,3 ) )
		end )

		test( 'Works with vertical and horizontal lines', function()
			assert_fuzzy_equal( 0, line.getYIntercept( 0,0, 3,0 ) )
			assert_false( line.getYIntercept( 0,3, 0,5 ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.getYIntercept: m: Expected boolean (false) or number, got string', function()
				line.getYIntercept( '1', 1, 2 )
			end )
			assert_error_equals( 'MLib.line.getYIntercept: x: Expected number, got string', function()
				line.getYIntercept( 1, '1', 2 )
			end )

			assert_error_equals( 'MLib.line.getYIntercept: x2: Expected number, got nil', function()
				line.getYIntercept( 1, 1 )
			end )
		end )
	end )

	context( 'checkPoint', function()
		test( 'Returns true if the point is on the line', function()
			assert_true( line.checkPoint( 1,1, 1, 0 ) )
			assert_true( line.checkPoint( 1,1, 1, 2,2 ) )
			assert_true( line.checkPoint( 1,1, 0,0, 2,2 ) )
		end )

		test( 'Returns false if the point isn\'t on the line', function()
			assert_false( line.checkPoint( 2,5, 1, 0 ) )
			assert_false( line.checkPoint( 2,5, 1, 2,2 ) )
			assert_false( line.checkPoint( 2,5, 0,0, 2,2 ) )
		end )

		test( 'Errors if given vertical line with two varargs', function()
			assert_error_equals( 'MLib.line.checkPoint: Cannot use two parameter variation to check point for vertical lines.', function()
				line.checkPoint( 1,1, false, false )
			end )
		end )

		test( 'Works with vertical lines otherwise', function()
			assert_true( line.checkPoint( 3,2, false, 3,0 ) )
			assert_true( line.checkPoint( 3,2, 3,1, 3,0 ) )

			assert_false( line.checkPoint( 4,2, false, 3,0 ) )
			assert_false( line.checkPoint( 4,2, 3,1, 3,0 ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.checkPoint: b: Expected boolean (false) or number, got string', function()
				line.checkPoint( 3,3, 1,'2' )
			end )

			assert_error_equals( 'MLib.line.checkPoint: y: Expected number, got string', function()
				line.checkPoint( 3,3, 1, 2,'3' )
			end )

			assert_error_equals( 'MLib.line.checkPoint: y2: Expected number, got string', function()
				line.checkPoint( 3,3, 3,3, 3, 'sasdf' )
			end )
		end )
	end )

	context( 'All functions checked', function()
		for i in pairs( line ) do
			test( tostring( i .. ' tested' ), function()
				assert_true( checked[i] )
			end )
		end
	end )
end )
