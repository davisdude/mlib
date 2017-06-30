-- MLib 0.12.0
-- https://github.com/davisdude/mlib
-- mlib/segment.lua
-- MIT License

local Segment = require( 'mlib.segment' )

local slopeError = 'Expected boolean (false) or number, got '
local pointError = 'Expected number, got '

-- Account for floating point errors
local say = require( 'say' )

local function checkFuzzy( a, b, delta )
	return math.abs( a - b ) <= ( delta or .001 )
end

local function fuzzyEqual( a, b )
	if type( a ) == 'number' and type( b ) == 'number' then
		return checkFuzzy( a, b )
	else
		return a == b
	end
end

local function fuzzyEqualWrapper( state, arguments )
	local a, b = unpack( arguments )
	return fuzzyEqual( a, b )
end

say:set( 'assertion.fuzzyEqual.positive', 'Expected %s to be equal to %s' )
say:set( 'assertion.fuzzyEqual.negative', 'Expected %s not to be equal to %s' )
assert:register( 'assertion', 'fuzzyEqual', fuzzyEqualWrapper, 'assertion.fuzzyEqual.positive', 'assertion.fuzzyEqual.negative' )

local function fuzzySame( a, b )
	local t1, t2 = type( a ), type( b )

	if t1 == t2 then
		if t1 ~= 'table' then
			return fuzzyEqual( a, b )
		else
			local passed = true
			for i in pairs( a ) do
				passed = fuzzySame( a[i], b[i] )
				if not passed then break end
			end
			return passed
		end
	else
		return false
	end
end

local function fuzzySameWrapper( state, arguments )
	local a, b = unpack( arguments )
	return fuzzySame( a, b )
end

say:set( 'assertion.fuzzySame.positive', 'Expected %s to be equal to %s' )
say:set( 'assertion.fuzzySame.negative', 'Expected %s not to be equal to %s' )
assert:register( 'assertion', 'fuzzySame', fuzzySameWrapper, 'assertion.fuzzySame.positive', 'assertion.fuzzySame.negative' )

-- Make sure all functions are checked
local checked = {}
for i in pairs( Segment ) do
	checked[i] = false
end

local oldDescribe = describe
function describe( name, func )
	checked[name] = true
	oldDescribe( name, func )
end

describe( 'Segment', function()
	describe( 'getDistance2', function()
		it( 'Gets the squared distance', function()
			assert.fuzzyEqual( Segment.getDistance2( 0,0, 2,0 ), 4 )
			assert.fuzzyEqual( Segment.getDistance2( 0,0, 1,1 ), 2 )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Segment.getDistance2()
			end, 'MLib.segment.getDistance2: x1: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Segment.getDistance2( 1,1, 1,'2' )
			end, 'MLib.segment.getDistance2: y2: ' .. pointError .. 'string.' )
		end )
	end )

	describe( 'getDistance', function()
		it( 'Gets the distance', function()
			assert.fuzzyEqual( Segment.getDistance( 0,0, 2,0 ), 2 )
			assert.fuzzyEqual( Segment.getDistance( 0,0, 1,1 ), 1.414 )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Segment.getDistance()
			end, 'MLib.segment.getDistance: x1: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Segment.getDistance( 1,1, 1,'2' )
			end, 'MLib.segment.getDistance: y2: ' .. pointError .. 'string.' )
		end )
	end )

	describe( 'getMidpoint', function()
		it( 'Gets the midpoint', function()
			assert.fuzzySame( { Segment.getMidpoint( 0, 0, 2, 2 ) }, { 1, 1 } )
			assert.fuzzySame( { Segment.getMidpoint( 5, 6, 7, 1 ) }, { 6, 3.5 } )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Segment.getMidpoint()
			end, 'MLib.segment.getMidpoint: x1: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Segment.getMidpoint( 1,1, 1,'2' )
			end, 'MLib.segment.getMidpoint: y2: ' .. pointError .. 'string.' )
		end )
	end )

	describe( 'checkPoint', function()
		it( 'Returns true/false if a point is on the segment', function()
			assert.True( Segment.checkPoint( 1,1, 0,0, 2,2 ) )
			assert.True( Segment.checkPoint( 1,0, 0,0, 5,0 ) )

			assert.False( Segment.checkPoint( 2,1, 0,0, 2,2 ) )
			assert.False( Segment.checkPoint( 2,2, 0,0, 5,0 ) )
		end )

		it( 'Handles when point is on line but not segment', function()
			assert.False( Segment.checkPoint( 1,1, 3,3, 4,4 ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Segment.checkPoint()
			end, 'MLib.segment.checkPoint: px: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Segment.checkPoint( 1,1, 2,2, '3',3 )
			end, 'MLib.segment.checkPoint: x2: ' .. pointError .. 'string.' )
		end )
	end )

	describe( 'getLineIntersection', function()
		it( 'Gets the intersection of a line and a segment', function()
			assert.fuzzySame( { Segment.getLineIntersection( { 0,0, 1,1 }, { -1, 2,0 } ) }, { 1,1 } )
			assert.fuzzySame( { Segment.getLineIntersection( { 0,0, 1,1 }, { 2,0, 0,2 } ) }, { 1,1 } )
		end )

		it( 'Returns true if the segment is on top of the line', function()
			assert.True( Segment.getLineIntersection( { 0,0, 5,0 }, { 0, 3,0 } ) )
			assert.True( Segment.getLineIntersection( { 0,0, 1,1 }, { -1,-1, 2,2 } ) )
		end )

		it( 'Returns false if there is no intersection', function()
			assert.False( Segment.getLineIntersection( { 0,0, 0,5 }, { false, 3,3 } ) )
			assert.False( Segment.getLineIntersection( { 0,0, 2,2 }, { 0, 5,3 } ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Segment.getLineIntersection()
			end, 'MLib.segment.getLineIntersection: segment: Expected table, got nil.' )

			assert.has_error( function()
				Segment.getLineIntersection( {} )
			end, 'MLib.segment.getLineIntersection: line: Expected table, got nil.' )

			assert.has_error( function()
				Segment.getLineIntersection( {}, {} )
			end, 'MLib.segment.getLineIntersection: segment: x1: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Segment.getLineIntersection( { 0,0, 3,'1' }, {} )
			end, 'MLib.segment.getLineIntersection: segment: y2: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Segment.getLineIntersection( { 1,1, 0,0 }, { '1', 0,3 } )
			end, 'MLib.segment.getLineIntersection: line: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Segment.getLineIntersection( { 1,1, 0,0 }, { 1, 0,'3' } )
			end, 'MLib.segment.getLineIntersection: line: y: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Segment.getLineIntersection( { 1,1, 0,0 }, {} )
			end, 'MLib.segment.getLineIntersection: line: x1: ' .. pointError .. 'nil.' )
		end )
	end )

	describe( 'getSegmentIntersection', function()
		it( 'Returns the point of intersection if segments intersect', function()
			assert.fuzzySame( { Segment.getSegmentIntersection( { 0,0, 1,1 }, { 0,2, 2,0 } ) }, { 1,1 } )
			assert.fuzzySame( { Segment.getSegmentIntersection( { 0,0, 5,0 }, { 0,-1, 4,7 } ) }, { .5, 0 } )
			assert.fuzzySame( { Segment.getSegmentIntersection( { 0,0, 0,5 }, { -2,0, 6,4 } ) }, { 0,1 } )
		end )

		it( 'Returns false if the segments don\'t intersect', function()
			assert.False( Segment.getSegmentIntersection( { 0,0, 1,1 }, { 0,2, 2,4 } ) )
		end )

		it( 'Returns true/false for overlapping segments', function()
			assert.True( Segment.getSegmentIntersection( { 0,0, 2,2 }, { 1,1, 3,3 } ) )
			assert.False( Segment.getSegmentIntersection( { 0,0, 2,2 }, { 3,3, 4,4 } ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Segment.getSegmentIntersection()
			end, 'MLib.segment.getSegmentIntersection: segment1: Expected table, got nil.' )

			assert.has_error( function()
				Segment.getSegmentIntersection( {}, {} )
			end, 'MLib.segment.getSegmentIntersection: segment1: x1: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Segment.getSegmentIntersection( { 1,1, 1,2 }, { 1,2, 1 } )
			end, 'MLib.segment.getSegmentIntersection: segment2: y2: ' .. pointError .. 'nil.' )
		end )
	end )

	describe( 'All functions checked', function()
		for i in pairs( Segment ) do
			it( tostring( i .. ' tested' ), function()
				assert.True( checked[i] )
			end )
		end
	end )
end )
