-- MLib 0.12.0
-- https://github.com/davisdude/mlib
-- spec/line.lua
-- MIT License

local Line = require( 'mlib.line' )

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
for i in pairs( Line ) do
	checked[i] = false
end

local oldDescribe = describe
function describe( name, func )
	checked[name] = true
	oldDescribe( name, func )
end

describe( 'Line', function()
	describe( 'getSlope', function()
		it( 'Gets the slope of a line', function()
			assert.fuzzyEqual( 1, Line.getSlope( 0,0, 1,1 ) )
			assert.fuzzyEqual( 1 / 3, Line.getSlope( 0,0, 3,1 ) )
		end )

		it( 'Returns `false` for vertical lines', function()
			assert.False( Line.getSlope( 1,3, 1,5 ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Line.getSlope( 0,0, 3 )
			end, 'MLib.line.getSlope: y2: ' .. pointError .. 'nil.' )
		end )
	end )

	describe( 'isVertical', function()
		it( 'Returns true if the line is vertical', function()
			assert.True( Line.isVertical( false ) )
			assert.True( Line.isVertical( false, 0,3 ) )
			assert.True( Line.isVertical( 0,5, 0,3 ) )
		end )

		it( 'Returns false if the line isn\'t vertical', function()
			assert.False( Line.isVertical( 1 ) )
			assert.False( Line.isVertical( 1, 0,0 ) )
			assert.False( Line.isVertical( 0,0, 1,1 ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Line.isVertical( 'a' )
			end, 'MLib.line.isVertical: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.isVertical( 3, 3 )
			end, 'MLib.line.isVertical: x2: ' .. pointError .. 'nil.' )
		end )
	end )

	describe( 'getPerpendicularSlope', function()
		it( 'Gets the perpendicular slope of a line', function()
			assert.fuzzyEqual( -1, Line.getPerpendicularSlope( 1 ) )
			assert.fuzzyEqual( -1, Line.getPerpendicularSlope( 0,0, 1,1 ) )
		end )

		it( 'Works with vertical and horizontal lines', function()
			assert.fuzzyEqual( 0, Line.getPerpendicularSlope( 0,0, 0,3 ) )
			assert.fuzzyEqual( 0, Line.getPerpendicularSlope( false ) )
			assert.False( Line.getPerpendicularSlope( 0,3, 3,3 ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Line.getPerpendicularSlope( '1' )
			end, 'MLib.line.getPerpendicularSlope: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.getPerpendicularSlope( 1,1 )
			end, 'MLib.line.getPerpendicularSlope: x2: ' .. pointError .. 'nil.' )
		end )
	end )

	describe( 'getYIntercept', function()
		it( 'Gets the y-intercept slope of a line', function()
			assert.fuzzyEqual( 0, Line.getYIntercept( 1, 1,1 ) )
			assert.fuzzyEqual( 1, Line.getYIntercept( 1,2, 2,3 ) )
		end )

		it( 'Works with vertical and horizontal lines', function()
			assert.fuzzyEqual( 0, Line.getYIntercept( 0,0, 3,0 ) )
			assert.False( Line.getYIntercept( 0,3, 0,5 ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Line.getYIntercept( '1', 1, 2 )
			end, 'MLib.line.getYIntercept: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.getYIntercept( 1, '1', 2 )
			end, 'MLib.line.getYIntercept: x: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Line.getYIntercept( 1, 1 )
			end, 'MLib.line.getYIntercept: x2: ' .. pointError .. 'nil.' )
		end )
	end )

	describe( 'checkPoint', function()
		it( 'Returns true if the point is on the line', function()
			assert.True( Line.checkPoint( 1,1, 1, 0 ) )
			assert.True( Line.checkPoint( 1,1, 1, 2,2 ) )
			assert.True( Line.checkPoint( 1,1, 0,0, 2,2 ) )
		end )

		it( 'Returns false if the point isn\'t on the line', function()
			assert.False( Line.checkPoint( 2,5, 1, 0 ) )
			assert.False( Line.checkPoint( 2,5, 1, 2,2 ) )
			assert.False( Line.checkPoint( 2,5, 0,0, 2,2 ) )
		end )

		it( 'Errors if given vertical line with two varargs', function()
			assert.has_error( function()
				Line.checkPoint( 1,1, false, false )
			end, 'MLib.line.checkPoint: Cannot use two parameter variation to check point for vertical lines.' )
		end )

		it( 'Works with vertical lines otherwise', function()
			assert.True( Line.checkPoint( 3,2, false, 3,0 ) )
			assert.True( Line.checkPoint( 3,2, 3,1, 3,0 ) )

			assert.False( Line.checkPoint( 4,2, false, 3,0 ) )
			assert.False( Line.checkPoint( 4,2, 3,1, 3,0 ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Line.checkPoint( 3,3, 1,'2' )
			end, 'MLib.line.checkPoint: b: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.checkPoint( 3,3, 1, 2,'3' )
			end, 'MLib.line.checkPoint: y: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Line.checkPoint( 3,3, 3,3, 3, 'sasdf' )
			end, 'MLib.line.checkPoint: y2: ' .. pointError .. 'string.' )
		end )
	end )

	describe( 'areLinesParallel', function()
		it( 'Returns true if lines are parallel', function()
			assert.True( Line.areLinesParallel( { 1 }, { 1 } ) )
			assert.True( Line.areLinesParallel( { 1, 1, 1 }, { 1, 2, 1 } ) )
			assert.True( Line.areLinesParallel( { 1 }, { 1,2, 2,3 } ) )
		end )

		it( 'Returns false if lines aren\'t parallel', function()
			assert.False( Line.areLinesParallel( { 1 }, { 2 } ) )
			assert.False( Line.areLinesParallel( { 1, 1, 1 }, { 2, 2, 1 } ) )
			assert.False( Line.areLinesParallel( { 1 }, { 1,2, 2,4 } ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Line.areLinesParallel()
			end, 'MLib.line.areLinesParallel: line1: Expected table, got nil.' )

			assert.has_error( function()
				Line.areLinesParallel( {} )
			end, 'MLib.line.areLinesParallel: line2: Expected table, got nil.' )

			assert.has_error( function()
				Line.areLinesParallel( { 'asdf' }, {} )
			end, 'MLib.line.areLinesParallel: line1: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.areLinesParallel( { 1 }, { '1' } )
			end, 'MLib.line.areLinesParallel: line2: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.areLinesParallel( {}, {} )
			end, 'MLib.line.areLinesParallel: line1: x1: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Line.areLinesParallel( { 1,2 }, {} )
			end, 'MLib.line.areLinesParallel: line1: x2: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Line.areLinesParallel( { 1, 2,1 }, {} )
			end, 'MLib.line.areLinesParallel: line2: x1: ' .. pointError .. 'nil.' )
		end )
	end )

	describe( 'getLineIntersection', function()
		it( 'Returns the line intersection of two lines', function()
			assert.fuzzySame( { Line.getLineIntersection( { 1, 0,0 }, { -1, 2,0 } ) } , { 1, 1 } )
			assert.fuzzySame( { Line.getLineIntersection( { 2, 5,6 }, { -1, 4, 0 } ) } , { 2.667, 1.333 } )

			assert.fuzzySame( { Line.getLineIntersection( { 0,0, 2,2 }, { 2,0, 0,2 } ) }, { 1, 1 } )
			assert.fuzzySame( { Line.getLineIntersection( { 2,0, 5,6 }, { 0,4, 1,3 } ) }, { 2.667, 1.333 } )
		end )

		it( 'Works with vertical and horizontal lines', function()
			assert.fuzzySame( { Line.getLineIntersection( { false, 2,5 }, { 1, 0,0 } ) }, { 2,2 } )
			assert.fuzzySame( { Line.getLineIntersection( { 2,0, 2,5 }, { 1, 0,0 } ) }, { 2,2 } )

			assert.fuzzySame( { Line.getLineIntersection( { 0, 1,2 }, { 2, 0,0 } ) }, { 1,2 } )
			assert.fuzzySame( { Line.getLineIntersection( { 0,2, 1,2 }, { 2, 0,0 } ) }, { 1,2 } )
		end )

		it( 'Returns booleans for parallel lines', function()
			assert.True( Line.getLineIntersection( { 1, 0,1 }, { 1, 1,2 } ) )
			assert.True( Line.getLineIntersection( { 1, 0,1 }, { 1, 1,2 } ) )

			assert.False( Line.getLineIntersection( { 1, 0,1 }, { 1, 2,1 } ) )
			assert.False( Line.getLineIntersection( { 1,2, 0,1 }, { 1, 2,1 } ) )

			assert.True( Line.getLineIntersection( { false, 0,1 }, { false, 0,2 } ) )
			assert.True( Line.getLineIntersection( { 0,2, 0,1 }, { 0,5, 0,7 } ) )

			assert.False( Line.getLineIntersection( { false, 0,1 }, { false, 2,2 } ) )
			assert.False( Line.getLineIntersection( { 0,2, 0,1 }, { 2,5, 2,7 } ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Line.getLineIntersection( { '1', 2,2 }, { 1, 1,1 } )
			end, 'MLib.line.getLineIntersection: line1: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.getLineIntersection( { 1, '1', 2 }, { 1, 1,1 } )
			end, 'MLib.line.getLineIntersection: line1: x: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Line.getLineIntersection( { 1,1 }, { 1, 1,1 } )
			end, 'MLib.line.getLineIntersection: line1: x2: ' .. pointError .. 'nil.' )

			assert.has_error( function()
				Line.getLineIntersection( { 1, 1,1 }, { '1', 2,2 } )
			end, 'MLib.line.getLineIntersection: line2: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.getLineIntersection( { 1, 1,1 }, { 1, '1', 2 } )
			end, 'MLib.line.getLineIntersection: line2: x: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Line.getLineIntersection( { 1, 1,1 }, { 1,1 } )
			end, 'MLib.line.getLineIntersection: line2: x2: ' .. pointError .. 'nil.' )
		end )
	end )

	describe( 'getClosestPoint', function()
		it( 'Returns the closest point on the line', function()
			assert.fuzzySame( { Line.getClosestPoint( 2,0, 1, 0,0 ) }, { 1,1 } )
			assert.fuzzySame( { Line.getClosestPoint( 2,0, 0,0, 2,2 ) }, { 1,1 } )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Line.getClosestPoint( '1',1, 1, 3,2 )
			end, 'MLib.line.getClosestPoint: px: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Line.getClosestPoint( 1,1, '1', 3,2 )
			end, 'MLib.line.getClosestPoint: m: ' .. slopeError .. 'string.' )

			assert.has_error( function()
				Line.getClosestPoint( 1,1, 1, 3,'2' )
			end, 'MLib.line.getClosestPoint: y: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Line.getClosestPoint( 1,1, '1',3, 2,2 )
			end, 'MLib.line.getClosestPoint: x1: ' .. pointError .. 'string.' )

			assert.has_error( function()
				Line.getClosestPoint( 1,1, 1,3, 2,'2' )
			end, 'MLib.line.getClosestPoint: y2: ' .. pointError .. 'string.' )
		end )
	end )

	describe( 'All functions checked', function()
		for i in pairs( Line ) do
			it( tostring( i .. ' ited' ), function()
				assert.True( checked[i] )
			end )
		end
	end )
end )
