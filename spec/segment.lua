-- MLib 0.12.0
-- https://github.com/davisdude/mlib
-- mlib/segment.lua
-- MIT License

local telescope = require( 'telescope' )
local Segment = require( 'mlib.segment' )

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
for i in pairs( Segment ) do
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

context( 'Segment', function()
	context( 'getDistance2', function()
		test( 'Gets the squared distance', function()
			assert_fuzzy_equal( Segment.getDistance2( 0,0, 2,0 ), 4 )
			assert_fuzzy_equal( Segment.getDistance2( 0,0, 1,1 ), 2 )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.segment.getDistance2: x1: ' .. pointError .. 'nil', function()
				Segment.getDistance2()
			end )

			assert_error_equals( 'MLib.segment.getDistance2: y2: ' .. pointError .. 'string', function()
				Segment.getDistance2( 1,1, 1,'2' )
			end )
		end )
	end )

	context( 'getDistance', function()
		test( 'Gets the distance', function()
			assert_fuzzy_equal( Segment.getDistance( 0,0, 2,0 ), 2 )
			assert_fuzzy_equal( Segment.getDistance( 0,0, 1,1 ), 1.414 )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.segment.getDistance: x1: ' .. pointError .. 'nil', function()
				Segment.getDistance()
			end )

			assert_error_equals( 'MLib.segment.getDistance: y2: ' .. pointError .. 'string', function()
				Segment.getDistance( 1,1, 1,'2' )
			end )
		end )
	end )

	context( 'getMidpoint', function()
		test( 'Gets the midpoint', function()
			assert_shallow_equal( { Segment.getMidpoint( 0, 0, 2, 2 ) }, { 1, 1 } )
			assert_shallow_equal( { Segment.getMidpoint( 5, 6, 7, 1 ) }, { 6, 3.5 } )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.segment.getMidpoint: x1: ' .. pointError .. 'nil', function()
				Segment.getMidpoint()
			end )

			assert_error_equals( 'MLib.segment.getMidpoint: y2: ' .. pointError .. 'string', function()
				Segment.getMidpoint( 1,1, 1,'2' )
			end )
		end )
	end )

	context( 'checkPoint', function()
		test( 'Returns true/false if a point is on the segment', function()
			assert_true( Segment.checkPoint( 1,1, 0,0, 2,2 ) )
			assert_true( Segment.checkPoint( 1,0, 0,0, 5,0 ) )

			assert_false( Segment.checkPoint( 2,1, 0,0, 2,2 ) )
			assert_false( Segment.checkPoint( 2,2, 0,0, 5,0 ) )
		end )

		test( 'Handles when point is on line but not segment', function()
			assert_false( Segment.checkPoint( 1,1, 3,3, 4,4 ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.segment.checkPoint: px: ' .. pointError .. 'nil', function()
				Segment.checkPoint()
			end )

			assert_error_equals( 'MLib.segment.checkPoint: x2: ' .. pointError .. 'string', function()
				Segment.checkPoint( 1,1, 2,2, '3',3 )
			end )
		end )
	end )

	context( 'getLineIntersection', function()
		test( 'Gets the intersection of a line and a segment', function()
			assert_shallow_equal( { Segment.getLineIntersection( { 0,0, 1,1 }, { -1, 2,0 } ) }, { 1,1 } )
			assert_shallow_equal( { Segment.getLineIntersection( { 0,0, 1,1 }, { 2,0, 0,2 } ) }, { 1,1 } )
		end )

		test( 'Returns true if the segment is on top of the line', function()
			assert_true( Segment.getLineIntersection( { 0,0, 5,0 }, { 0, 3,0 } ) )
			assert_true( Segment.getLineIntersection( { 0,0, 1,1 }, { -1,-1, 2,2 } ) )
		end )

		test( 'Returns false if there is no intersection', function()
			assert_false( Segment.getLineIntersection( { 0,0, 0,5 }, { false, 3,3 } ) )
			assert_false( Segment.getLineIntersection( { 0,0, 2,2 }, { 0, 5,3 } ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.segment.getLineIntersection: segment: Expected table, got nil', function()
				Segment.getLineIntersection()
			end )

			assert_error_equals( 'MLib.segment.getLineIntersection: line: Expected table, got nil', function()
				Segment.getLineIntersection( {} )
			end )

			assert_error_equals( 'MLib.segment.getLineIntersection: segment: x1: ' .. pointError .. 'nil', function()
				Segment.getLineIntersection( {}, {} )
			end )

			assert_error_equals( 'MLib.segment.getLineIntersection: segment: y2: ' .. pointError .. 'string', function()
				Segment.getLineIntersection( { 0,0, 3,'1' }, {} )
			end )

			assert_error_equals( 'MLib.segment.getLineIntersection: line: m: ' .. slopeError .. 'string', function()
				Segment.getLineIntersection( { 1,1, 0,0 }, { '1', 0,3 } )
			end )

			assert_error_equals( 'MLib.segment.getLineIntersection: line: y: ' .. pointError .. 'string', function()
				Segment.getLineIntersection( { 1,1, 0,0 }, { 1, 0,'3' } )
			end )

			assert_error_equals( 'MLib.segment.getLineIntersection: line: x1: ' .. pointError .. 'nil', function()
				Segment.getLineIntersection( { 1,1, 0,0 }, {} )
			end )
		end )
	end )

	context( 'All functions checked', function()
		for i in pairs( Segment ) do
			test( tostring( i .. ' tested' ), function()
				assert_true( checked[i] )
			end )
		end
	end )
end )
