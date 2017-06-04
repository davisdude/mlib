local telescope = require( 'telescope' )
local line = require( 'mlib.line' )

-- Local functions
local function checkFuzzy( a, b, delta )
	return math.abs( a - b ) <= ( delta or .001 )
end

local function shallowEqual( a, b )
	for i, v in pairs( a ) do
		local passed
		if type( v ) ~= 'number' then
			passed = v == b[i]
		else
			passed = checkFuzzy( v, b[i] )
		end
		if not passed then return false end
	end

	return true
end

local slopeError = 'Expected boolean (false) or number, got '
local pointError = 'Expected number, got '

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

-- Make assertions
telescope.make_assertion( 'fuzzy_equal', '%s to be fuzzy equal to %s', checkFuzzy )

telescope.make_assertion( 'shallow_equal', '%s to be shallow equal to %s', function( a, b )
	-- Compare both ways
	local passed = shallowEqual( a, b )
	if passed then
		return shallowEqual( b, a )
	end

	return false
end )

telescope.make_assertion( 'error_equals', '%s to be equal to %s', function( a, b )
	-- Escape a's special characters
	a = a:gsub( '([()^$.%%])', function( m )
		return '%' .. m
	end )

	-- Get b
	local _, err = pcall( b )

	-- Use :match to ignore line numbers
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
			assert_error_equals( 'MLib.line.getSlope: y2: ' .. pointError .. 'nil', function()
				line.getSlope( 0,0, 3 )
			end )
		end )
	end )

	context( 'isVertical', function()
		test( 'Returns true if the line is vertical', function()
			assert_true( line.isVertical( false ) )
			assert_true( line.isVertical( false, 0,3 ) )
			assert_true( line.isVertical( 0,5, 0,3 ) )
		end )

		test( 'Returns false if the line isn\'t vertical', function()
			assert_false( line.isVertical( 1 ) )
			assert_false( line.isVertical( 1, 0,0 ) )
			assert_false( line.isVertical( 0,0, 1,1 ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.isVertical: m: ' .. slopeError .. 'string', function()
				line.isVertical( 'a' )
			end )

			assert_error_equals( 'MLib.line.isVertical: x2: ' .. pointError .. 'nil', function()
				line.isVertical( 3, 3 )
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
			assert_error_equals( 'MLib.line.getPerpendicularSlope: m: ' .. slopeError .. 'string', function()
				line.getPerpendicularSlope( '1' )
			end )

			assert_error_equals( 'MLib.line.getPerpendicularSlope: x2: ' .. pointError .. 'nil', function()
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
			assert_error_equals( 'MLib.line.getYIntercept: m: ' .. slopeError .. 'string', function()
				line.getYIntercept( '1', 1, 2 )
			end )
			assert_error_equals( 'MLib.line.getYIntercept: x: ' .. pointError .. 'string', function()
				line.getYIntercept( 1, '1', 2 )
			end )

			assert_error_equals( 'MLib.line.getYIntercept: y: ' .. pointError .. 'nil', function()
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
			assert_error_equals( 'MLib.line.checkPoint: b: ' .. slopeError .. 'string', function()
				line.checkPoint( 3,3, 1,'2' )
			end )

			assert_error_equals( 'MLib.line.checkPoint: y: ' .. pointError .. 'string', function()
				line.checkPoint( 3,3, 1, 2,'3' )
			end )

			assert_error_equals( 'MLib.line.checkPoint: y2: ' .. pointError .. 'string', function()
				line.checkPoint( 3,3, 3,3, 3, 'sasdf' )
			end )
		end )
	end )

	context( 'areLinesParallel', function()
		test( 'Returns true if lines are parallel', function()
			assert_true( line.areLinesParallel( { 1 }, { 1 } ) )
			assert_true( line.areLinesParallel( { 1, 1, 1 }, { 1, 2, 1 } ) )
			assert_true( line.areLinesParallel( { 1 }, { 1,2, 2,3 } ) )
		end )

		test( 'Returns false if lines aren\'t parallel', function()
			assert_false( line.areLinesParallel( { 1 }, { 2 } ) )
			assert_false( line.areLinesParallel( { 1, 1, 1 }, { 2, 2, 1 } ) )
			assert_false( line.areLinesParallel( { 1 }, { 1,2, 2,4 } ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.areLinesParallel: line1: Expected table, got nil', function()
				line.areLinesParallel()
			end )

			assert_error_equals( 'MLib.line.areLinesParallel: line2: Expected table, got nil', function()
				line.areLinesParallel( {} )
			end )
			
			assert_error_equals( 'MLib.line.areLinesParallel: line1: m: ' .. slopeError .. 'string', function()
				line.areLinesParallel( { 'asdf' }, {} )
			end )

			assert_error_equals( 'MLib.line.areLinesParallel: line2: m: ' .. slopeError .. 'string', function()
				line.areLinesParallel( { 1 }, { '1' } )
			end )

			assert_error_equals( 'MLib.line.areLinesParallel: line1: x1: ' .. pointError .. 'nil', function()
				line.areLinesParallel( {}, {} )
			end )

			assert_error_equals( 'MLib.line.areLinesParallel: line1: x2: ' .. pointError .. 'nil', function()
				line.areLinesParallel( { 1,2 }, {} )
			end )
			
			assert_error_equals( 'MLib.line.areLinesParallel: line2: x1: ' .. pointError .. 'nil', function()
				line.areLinesParallel( { 1, 2,1 }, {} )
			end )
		end )
	end )

	context( 'getLineIntersection', function()
		test( 'Returns the line intersection of two lines', function()
			assert_shallow_equal( { line.getLineIntersection( { 1, 0,0 }, { -1, 2,0 } ) } , { 1, 1 } )
			assert_shallow_equal( { line.getLineIntersection( { 2, 5,6 }, { -1, 4, 0 } ) } , { 2.667, 1.333 } )

			assert_shallow_equal( { line.getLineIntersection( { 0,0, 2,2 }, { 2,0, 0,2 } ) }, { 1, 1 } )
			assert_shallow_equal( { line.getLineIntersection( { 2,0, 5,6 }, { 0,4, 1,3 } ) }, { 2.667, 1.333 } )
		end )

		test( 'Works with vertical and horizontal lines', function()
			assert_shallow_equal( { line.getLineIntersection( { false, 2,5 }, { 1, 0,0 } ) }, { 2,2 } )
			assert_shallow_equal( { line.getLineIntersection( { 2,0, 2,5 }, { 1, 0,0 } ) }, { 2,2 } )

			assert_shallow_equal( { line.getLineIntersection( { 0, 1,2 }, { 2, 0,0 } ) }, { 1,2 } )
			assert_shallow_equal( { line.getLineIntersection( { 0,2, 1,2 }, { 2, 0,0 } ) }, { 1,2 } )
		end )

		test( 'Returns booleans for parallel lines', function()
			assert_true( line.getLineIntersection( { 1, 0,1 }, { 1, 1,2 } ) )
			assert_true( line.getLineIntersection( { 1, 0,1 }, { 1, 1,2 } ) )

			assert_false( line.getLineIntersection( { 1, 0,1 }, { 1, 2,1 } ) )
			assert_false( line.getLineIntersection( { 1,2, 0,1 }, { 1, 2,1 } ) )

			assert_true( line.getLineIntersection( { false, 0,1 }, { false, 0,2 } ) )
			assert_true( line.getLineIntersection( { 0,2, 0,1 }, { 0,5, 0,7 } ) )

			assert_false( line.getLineIntersection( { false, 0,1 }, { false, 2,2 } ) )
			assert_false( line.getLineIntersection( { 0,2, 0,1 }, { 2,5, 2,7 } ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.getLineIntersection: line1: m: ' .. slopeError .. 'string', function()
				line.getLineIntersection( { '1', 2,2 }, { 1, 1,1 } )
			end )

			assert_error_equals( 'MLib.line.getLineIntersection: line1: x: ' .. pointError .. 'string', function()
				line.getLineIntersection( { 1, '1', 2 }, { 1, 1,1 } )
			end )

			assert_error_equals( 'MLib.line.getLineIntersection: line1: x2: ' .. pointError .. 'nil', function()
				line.getLineIntersection( { 1,1 }, { 1, 1,1 } )
			end )

			assert_error_equals( 'MLib.line.getLineIntersection: line2: m: ' .. slopeError .. 'string', function()
				line.getLineIntersection( { 1, 1,1 }, { '1', 2,2 } )
			end )

			assert_error_equals( 'MLib.line.getLineIntersection: line2: x: ' .. pointError .. 'string', function()
				line.getLineIntersection( { 1, 1,1 }, { 1, '1', 2 } )
			end )

			assert_error_equals( 'MLib.line.getLineIntersection: line2: x2: ' .. pointError .. 'nil', function()
				line.getLineIntersection( { 1, 1,1 }, { 1,1 } )
			end )
		end )
	end )

	context( 'getClosestPoint', function()
		test( 'Returns the closest point on the line', function()
			assert_shallow_equal( { line.getClosestPoint( 2,0, 1, 0,0 ) }, { 1,1 } )
			assert_shallow_equal( { line.getClosestPoint( 2,0, 0,0, 2,2 ) }, { 1,1 } )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.getClosestPoint: px: ' .. pointError .. 'string', function()
				line.getClosestPoint( '1',1, 1, 3,2 )
			end )

			assert_error_equals( 'MLib.line.getClosestPoint: m: ' .. slopeError .. 'string', function()
				line.getClosestPoint( 1,1, '1', 3,2 )
			end )

			assert_error_equals( 'MLib.line.getClosestPoint: y: ' .. pointError .. 'string', function()
				line.getClosestPoint( 1,1, 1, 3,'2' )
			end )

			assert_error_equals( 'MLib.line.getClosestPoint: x1: ' .. pointError .. 'string', function()
				line.getClosestPoint( 1,1, '1',3, 2,2 )
			end )

			assert_error_equals( 'MLib.line.getClosestPoint: y2: ' .. pointError .. 'string', function()
				line.getClosestPoint( 1,1, 1,3, 2,'2' )
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
