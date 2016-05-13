require 'telescope'

local mlib = require 'mlib'
local turbo = require 'mlib_turbo'

-- {{{ Helpers
local function fuzzyEqual( x, y, delta )
	return math.abs( x - y ) <= ( delta or .00001 )
end
make_assertion( 'fuzzyEqual', 'values are approximately equal', fuzzyEqual )
make_assertion( 'multipleFuzzyEqual', 'multiple values are approximately equal', function( t1, t2 )
	for i = 1, #t1 do
		if not fuzzyEqual( t1[i], t2[i] ) then return false end
	end
	return true
end )
make_assertion( 'errorIs', 'error checking', function( f, message, magic )
	magic = magic or false
	local p, e = pcall( f )
	if not magic then
		message = message:gsub( '([%.%^%$%%%-%*%+])', '%%%1' ):gsub( '%[(.-)%]', '%%[%1%%]' ):gsub( '%((.-)%)', '%%(%1%%)' )
	end
	return not p and not not e:find( message )
end )
-- }}}
-- {{{ line
context( 'line', function()
	before( function()
		mlib.compatibilityMode = false
	end )
	-- {{{ line.getSlope
	context( 'getSlope', function()
		context( 'mlib', function()
			test( 'Gives the slope of a line given 4 numbers', function()
				assert_fuzzyEqual( mlib.line.getSlope( 0, 0, 1, 1 ), 1 )
				assert_fuzzyEqual( mlib.line.getSlope( 0, 1, 1, 0 ), -1 )
				assert_fuzzyEqual( mlib.line.getSlope( 0, 0, 1, 1 ), 1 )
				assert_fuzzyEqual( mlib.line.getSlope( 0, 1, 1, 0 ), -1 )
				assert_fuzzyEqual( mlib.line.getSlope( 4, 3, 6, 15 ), 6 )
			end )
			test( 'Returns false if the line is vertical given 2 tables', function()
				assert_false( mlib.line.getSlope( 0, 0, 0, 10 ) )
				assert_false( mlib.line.getSlope( 4, 3, 4, 4 ) )
			end )
			test( 'Error handling', function()
				assert_errorIs( function() mlib.line.getSlope( '1', 0, 0, 0 ) end,
					'MLib: line.getSlope: arg 1: expected a number, got string'
				)
				assert_errorIs( function() mlib.line.getSlope( 1, 1 ) end,
					'MLib: line.getSlope: arg 3: expected a number, got nil'
				)
				-- Compatibility mode
				mlib.compatibilityMode = true
				assert_errorIs( function() mlib.line.getSlope( { 0, 0 }, 1, 1 ) end,
					'MLib: line.getSlope: arg 1: expected a number, got table'
				)
				assert_errorIs( function() mlib.line.getSlope( 0, 0, { 1, 1 } ) end,
					'MLib: line.getSlope: arg 3: expected a number, got table'
				)
				assert_errorIs( function() mlib.line.getSlope( { 0, 0, 1, 1 } ) end,
					'MLib: line.getSlope: arg 1: expected a number, got table'
				)
				assert_errorIs( function() mlib.line.getSlope( 0, '0', 1, 1 ) end,
					'MLib: line.getSlope: arg 2: expected a number, got string'
				)
			end )
		end )
		context( 'turbo', function()
			test( 'Gives the slope of a line given 4 numbers', function()
				assert_fuzzyEqual( turbo.line.getSlope( 0, 0, 1, 1 ), 1 )
				assert_fuzzyEqual( turbo.line.getSlope( 0, 1, 1, 0 ), -1 )
				assert_false( turbo.line.getSlope( 0, 0, 0, 1 ) )
			end )
		end )
	end ) -- }}}
	-- {{{ line.getPerpendicularSlope
	context( 'getPerpendicularSlope', function()
		context( 'mlib', function()
			test( 'Gives the perpendicular slope of a line with the formats of line.getSlope', function()
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( 0, 0, 1, 1 ), -1 )
			end )
			test( '0 if the line is vertical', function()
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( 0, 0, 0, 1 ), 0 )
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( 50, 30, 50, 20 ), 0 )
			end )
			test( 'False if the line is horizontal', function()
				assert_false( mlib.line.getPerpendicularSlope( 0, 1, 1, 1 ) )
				assert_false( mlib.line.getPerpendicularSlope( 30, 50, 20, 50 ) )
			end )
			test( 'Error handling', function()
				assert_errorIs( function() mlib.line.getPerpendicularSlope( 0, 0, 1, '1' ) end,
					'MLib: line.getPerpendicularSlope: arg 4: expected a number, got string, 1'
				)
				assert_errorIs( function() mlib.line.getPerpendicularSlope( '1' ) end,
					'MLib: line.getPerpendicularSlope: arg 1: expected a number or boolean (false), got string, 1'
				)
				-- Compatibility mode
				mlib.compatibilityMode = true
				assert_errorIs( function() mlib.line.getPerpendicularSlope( { 0, 0 }, 1, 1 ) end,
					'MLib: line.getPerpendicularSlope: arg 1: in compatibility mode expected a number or boolean (false), got table, table:'
				)
				assert_errorIs( function() mlib.line.getPerpendicularSlope( 0, 0, 1, 1 ) end,
					'MLib: line.getPerpendicularSlope: in compatibility mode expected 1 arg, got 4'
				)
				assert_errorIs( function() mlib.line.getPerpendicularSlope( '1' ) end,
					'MLib: line.getPerpendicularSlope: arg 1: in compatibility mode expected a number or boolean (false), got string, 1'
				)
			end )
		end )
		context( 'turbo', function()
			test( 'Gives the perpendicular slope of a line given the slope', function()
				assert_fuzzyEqual( turbo.line.getPerpendicularSlope( 1 ), -1 )
			end )
		end )
	end )
	-- }}}
	-- {{{ line.getIntercept
	context( 'getIntercept', function()
		context( 'mlib', function()
			test( 'Gets the y-intercept of a line given turbo format', function()
				assert_fuzzyEqual( mlib.line.getIntercept( 1, 0, 0 ), 0 )
				assert_fuzzyEqual( mlib.line.getIntercept( 2, 1, 4 ), 2 )
				assert_fuzzyEqual( mlib.line.getIntercept( 5, 2, 10 ), 0 )
			end )
			test( 'Gets the y-intercept of a line with formats of line.getSlope', function()
				assert_fuzzyEqual( mlib.line.getIntercept( 0, 0, 1, 1 ), 0 )
				assert_fuzzyEqual( mlib.line.getIntercept( 1, 4, 2, 6 ), 2 )
				assert_fuzzyEqual( mlib.line.getIntercept( 4, 20, 2, 10 ), 0 )
			end )
			test( 'Errors handling', function()
				assert_errorIs( function() mlib.line.getIntercept( '1', 2, 1 ) end,
					'MLib: line.getIntercept: arg 1: expected a number or boolean (false), got string, 1'
				)
				assert_errorIs( function() mlib.line.getIntercept( false, 0, 1, 1 ) end,
					'MLib: line.getIntercept: arg 1: expected a number with > 3 arg, got boolean, false'
				)
				-- Compatibility mode
				mlib.compatibilityMode = true
				assert_errorIs( function() mlib.line.getIntercept( { 0, 0 }, 1, 1 ) end,
					'MLib: line.getIntercept: arg 1: in compatibility mode expected a number or boolean (false), got table, table:'
				)
				assert_errorIs( function() mlib.line.getIntercept( 0, 0, { 1, 1 } ) end,
					'MLib: line.getIntercept: arg 3: in compatibility mode expected a number, got table, table:'
				)
				assert_errorIs( function() mlib.line.getIntercept( { 1, 0, 0 } ) end,
					'MLib: line.getIntercept: arg 1: in compatibility mode expected a number or boolean (false), got table, table:'
				)
			end )
		end )
		context( 'turbo', function()
			test( 'Gets the y-intercept of a line given the slope and a point', function()
				assert_fuzzyEqual( turbo.line.getIntercept( 1, 0, 0 ), 0 )
			end )
		end )
	end )
	-- }}}
	-- {{{ line.getLineIntersection
	context( 'getLineIntersection', function()
		context( 'mlib', function()
			test( 'Gives the intersection of two lines given 4 points', function()
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 1, 0, 0 }, { -1, 0, 2 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 1, 0, 0 }, { 0, 2, 2, 0 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 0, 0, 2, 2 }, { -1, 0, 2 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 0, 0, 2, 2 }, { 0, 2, 2, 0 } ) }, { 1, 1 } )
			end )
			test( 'Handles vertical lines', function()
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 0, 0, 0, 2 }, { -1, 1, 1, 1 } ) }, { 0, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { -1, 1, 1, 1}, { 0, 0, 0, 2 } ) }, { 0, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { false, 5, 5 }, { 0, 3, 3 } ) }, { 5, 3 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 0, 5, 5 }, { false, 3, 3 } ) }, { 3, 5 } )
				assert_true( mlib.line.getLineIntersection( { 0, 0, 0, 2 }, { 0, 1, 0, 3 } ) )
				assert_false( mlib.line.getLineIntersection( { 0, 0, 0, 2 }, { 1, 1, 1, 3 } ) )
			end )
			test( 'Error handling', function()
				-- line 1; no compat
				assert_errorIs( function() mlib.line.getLineIntersection( { '1', 0, 0 }, { 2, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 1: expected [1] to be a number or boolean (false), got string, 1'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 1, false, 0 }, { 2, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 1: expected [2] to be a number, got boolean, false'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0 }, { 2, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 1: expected [3] to be a number, got nil, nil'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, 0, function() return 5 end }, { 2, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 1: expected [4] to be a number, got function, function:'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, 0 }, { false, 0, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 2: expected [1] to be a number with # > 3, got boolean, false'
				)
				-- line 2; no compat
				assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { '1', 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 2: expected [1] to be a number or boolean (false), got string, 1'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, false, 0 }) end,
					'MLib: line.getLineIntersection: arg 2: expected [2] to be a number, got boolean, false'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, 0 } ) end,
					'MLib: line.getLineIntersection: arg 2: expected [3] to be a number, got nil, nil'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, 0, 0, function() return 5 end } ) end,
					'MLib: line.getLineIntersection: arg 2: expected [4] to be a number, got function, function:'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { false, 0, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 2: expected [1] to be a number with # > 3, got boolean, false'
				)
				-- line 1; compat
				mlib.compatibilityMode = true
				assert_errorIs( function() mlib.line.getLineIntersection( { '1', 0, 0 }, { 2, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 1: in compatibility mode expected [1] to be a number or boolean (false), got string, 1'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 1, '0', 0 }, { 2, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 1: in compatibility mode expected [2] to be a number, got string, 0'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, '0' }, { 2, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 1: in compatibility mode expected [3] to be a number, got string, 0'
				)
				-- line 2; compat
				assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { '1', 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 2: in compatibility mode expected [1] to be a number or boolean (false), got string, 1'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, '0', 0 } ) end,
					'MLib: line.getLineIntersection: arg 2: in compatibility mode expected [2] to be a number, got string, 0'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, 0, '0' } ) end,
					'MLib: line.getLineIntersection: arg 2: in compatibility mode expected [3] to be a number, got string, 0'
				)
				-- misc
				assert_errorIs( function() mlib.line.getLineIntersection( 1, { 2, 0, 0 } ) end,
					'MLib: line.getLineIntersection: arg 1: expected a table, got number'
				)
				assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, 0 }, false ) end,
					'MLib: line.getLineIntersection: arg 2: expected a table, got boolean'
				)
			end )
		end )
		context( 'turbo', function()
			test( 'Gives the intersection of two lines given slope and intercept', function()
				assert_multipleFuzzyEqual( { turbo.line.getLineIntersection( { 1, 0, 0 }, { -1, 0, 2 } ) }, { 1, 1 } )
			end )
		end )
	end )
	-- }}}
	-- {{{ line.getClosestPoint
	context( 'line.getClosestPoint', function()
		context( 'mlib', function()
			test( 'Gives the closest point on a line to regular, vertical, and horizontal lines', function()
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( 1, 0, 0, 0, 4 ) }, { 2, 2 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( -1, 2, 2, 4, 2 ) }, { 3, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( 0, 0, 2, 4, -2 ) }, { 4, 2 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( false, 4, 0, 2, 2 ) }, { 4, 2 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( { 0, 0, 1, 1 }, 0, 2 ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( { 2, 2, 2, 4 }, 4, -2 ) }, { 2, -2 } )
			end )
			test( 'Error handling', function()
				-- 3 args; no compat
				assert_errorIs( function() mlib.line.getClosestPoint( 3, 2, 1 ) end,
					'MLib: line.getClosestPoint: arg 1: expected a table for 3 args, got number'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( { '0', 0, 1, 1 }, 2, 1 ) end,
					'MLib: line.getClosestPoint: arg 1: expected [1] to be a number, got string, 0'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( { 0, '0', 1, 1 }, 2, 1 ) end,
					'MLib: line.getClosestPoint: arg 1: expected [2] to be a number, got string, 0'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( { 0, 0, '1', 1 }, 2, 1 ) end,
					'MLib: line.getClosestPoint: arg 1: expected [3] to be a number, got string, 1'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( { 0, 0, 1, '1' }, 2, 1 ) end,
					'MLib: line.getClosestPoint: arg 1: expected [4] to be a number, got string, 1'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( { 0, 0, 1, 1 }, '2', 1 ) end,
					'MLib: line.getClosestPoint: arg 2: expected a number, got string'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( { 0, 0, 1, 1 }, 2, '1' ) end,
					'MLib: line.getClosestPoint: arg 3: expected a number, got string'
				)
				-- 4 args; no compat
				assert_errorIs( function() mlib.line.getClosestPoint( '1', 0, 0, 0, 4 ) end,
					'MLib: line.getClosestPoint: arg 1: expected a number or boolean with > 3 arg, got string'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( 1, '0', 0, 0, 4 ) end,
					'MLib: line.getClosestPoint: arg 2: expected a number, got string'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( 1, 0, '0', 0, 4 ) end,
					'MLib: line.getClosestPoint: arg 3: expected a number, got string'
				)

				assert_errorIs( function() mlib.line.getClosestPoint( 1, 0, 0, '0', 4 ) end,
					'MLib: line.getClosestPoint: arg 4: expected a number, got string'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( 1, 0, 0, 0, '4' ) end,
					'MLib: line.getClosestPoint: arg 5: expected a number, got string'
				)
				-- Compatibility mode
				mlib.compatibilityMode = true
				assert_errorIs( function() mlib.line.getClosestPoint( '1', 0, 0, 0, 4 ) end,
					'MLib: line.getClosestPoint: arg 1: in compatibility mode expected a number or boolean, got string'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( 1, '0', 0, 0, 4 ) end,
					'MLib: line.getClosestPoint: arg 2: in compatibility mode expected a number, got string'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( 1, 0, '0', 0, 4 ) end,
					'MLib: line.getClosestPoint: arg 3: in compatibility mode expected a number, got string'
				)

				assert_errorIs( function() mlib.line.getClosestPoint( 1, 0, 0, '0', 4 ) end,
					'MLib: line.getClosestPoint: arg 4: in compatibility mode expected a number, got string'
				)
				assert_errorIs( function() mlib.line.getClosestPoint( 1, 0, 0, 0, '4' ) end,
					'MLib: line.getClosestPoint: arg 5: in compatibility mode expected a number, got string'
				)
			end )
		end )
		context( 'turbo', function()
			test( 'Gives the closest point on a line to regular, vertical, and horizontal lines', function()
				assert_multipleFuzzyEqual( { turbo.line.getClosestPoint( 1, 0, 0, 0, 4 ) }, { 2, 2 } )
				assert_multipleFuzzyEqual( { turbo.line.getClosestPoint( -1, 2, 2, 4, 2 ) }, { 3, 1 } )
				assert_multipleFuzzyEqual( { turbo.line.getClosestPoint( 0, 0, 2, 4, -2 ) }, { 4, 2 } )
				assert_multipleFuzzyEqual( { turbo.line.getClosestPoint( false, 4, 0, 2, 2 ) }, { 4, 2 } )
			end )
		end )
	end )
	-- }}}
end )
-- }}}
-- {{{ segment
context( 'segment', function()
	before( function()
		mlib.compatibilityMode = false
	end )
	-- {{{ segment.getMidpoint
	context( 'getMidpoint', function()
		context( 'mlib', function()
			test( 'Gives the midpoint of two points', function()
				assert_multipleFuzzyEqual( { mlib.segment.getMidpoint( 0, 0, 2, 2 ) }, { 1, 1 } )
			end )
			test( 'Errors handling', function()
				mlib.compatibilityMode = true
				assert_errorIs( function() mlib.segment.getMidpoint( { 0, 0 }, 2, 2 ) end,
					'MLib: segment.getMidpoint: arg 1: expected a number, got table'
				)
				assert_errorIs( function() mlib.segment.getMidpoint( { 0, 0, 2, 2 } ) end,
					'MLib: segment.getMidpoint: arg 1: expected a number, got table'
				)
				assert_errorIs( function() mlib.segment.getMidpoint( 0, 0, false, 3 ) end,
					'MLib: segment.getMidpoint: arg 3: expected a number, got boolean'
				)
			end )
		end )
		context( 'turbo', function()
			test( 'Gives the midpoint of two points given two points', function()
				assert_multipleFuzzyEqual( { turbo.segment.getMidpoint( 0, 0, 2, 2 ) }, { 1, 1 } )
			end )
		end )
	end )
	-- }}}
	-- {{{ segment.getLength
	context( 'getLength', function()
		context( 'mlib', function()
			test( 'Gets the distance between two points', function()
				assert_fuzzyEqual( mlib.segment.getLength( 0, 0, 1, 1 ), math.sqrt( 2 ) )
				assert_fuzzyEqual( mlib.segment.getLength( 2, 2, 2, 5 ), 3 )
				assert_fuzzyEqual( mlib.segment.getLength( 3, 5, 5, 5 ), 2 )
			end )
			test( 'Error handling', function()
				mlib.compatibilityMode = true
				assert_errorIs( function() mlib.segment.getLength( '1', 0, 0, 1 ) end,
					'MLib: segment.getLength: arg 1: expected a number, got string'
				)
				assert_errorIs( function() mlib.segment.getLength( 1, nil, 0, 1 ) end,
					'MLib: segment.getLength: arg 2: expected a number, got nil'
				)
				assert_errorIs( function() mlib.segment.getLength( { 1, 1 }, { 0, 1 } ) end,
					'MLib: segment.getLength: arg 1: expected a number, got table'
				)
			end )
		end )
		context( 'turbo', function()
			test( 'Gets the distance between two points given two points', function()
				assert_fuzzyEqual( turbo.segment.getLength( 0, 0, 1, 1 ), math.sqrt( 2 ) )
			end )
		end )
	end )
	-- }}}
	-- {{{ segment.getLength2
	context( 'getLength2', function()
		context( 'turbo', function()
			test( 'Gets the distance between two points', function()
				assert_fuzzyEqual( turbo.segment.getLength2( 0, 0, 1, 1 ), 2 )
				assert_fuzzyEqual( turbo.segment.getLength2( 0, 0, 0, 4 ), 16 )
			end )
		end )
	end )
	-- }}}
	-- {{{ segment.checkPoint
	context( 'checkPoint', function()
		context( 'turbo', function()
			test( 'Checks if a point is on a line segment', function()
				assert_true( turbo.segment.checkPoint( 1, 1, 0, 0, 2, 2 ) )
				assert_true( turbo.segment.checkPoint( 0, 0, 0, 0, 2, 2 ) )
				assert_true( turbo.segment.checkPoint( 2, 2, 0, 0, 2, 2 ) )
				assert_false( turbo.segment.checkPoint( -1, -1, 0, 0, 2, 2 ) )
				assert_false( turbo.segment.checkPoint( 3, 2, 0, 0, 2, 2 ) )
			end )
		end )
	end )
	-- }}}
	-- {{{ segment.getLineIntersection
	context( 'getLineIntersection', function()
		context( 'turbo', function()
			test( 'Gets the intersection of a line and segment', function()
				assert_multipleFuzzyEqual( { turbo.segment.getLineIntersection( { 1, 0, 0 }, { 0, 2, 2, 0 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { turbo.segment.getLineIntersection( { false, 0, 0 }, { -2, 2, 2, 0 } ) }, { 0, 1 } )
				assert_multipleFuzzyEqual( { turbo.segment.getLineIntersection( { -1 / 3, -2, 4 }, { 1, 1, 1, 3 } ) }, { 1, 3 } )
				assert_false( turbo.segment.getLineIntersection( { 1, 0, 0 }, { 0, 2, -2, 4 } ) )
				assert_false( turbo.segment.getLineIntersection( { false, 0, 0 }, { 4, 2, 3, 4 } ) )
				assert_false( turbo.segment.getLineIntersection( { -1 / 3, -2, 4 }, { 1, 2, -2, 3 } ) )
				assert_false( turbo.segment.getLineIntersection( { -2, 2, 0 }, { 0, 0, 0, 3 } ) )
			end )
		end )
	end )
	-- }}}
	-- {{{ segment.getSegmentIntersection
	context( 'getSegmentIntersection', function()
		context( 'turbo', function()
			test( 'Gives the intersection of two line segments', function()
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 0, 0, 5, 5 }, { 1, 5, 4, 2 } ) }, { 3, 3 } )
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 5, 2, 5, 5 }, { 1, 5, 7, 2 } ) }, { 5, 3 } )
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 2, 4, 8, 0 }, { 2, 2, 7, 2 } ) }, { 5, 2 } )
				assert_false( turbo.segment.getSegmentIntersection( { 0, 0, 5, 5 }, { 4, 2, 6, 4 } ) )
				assert_false( turbo.segment.getSegmentIntersection( { 5, 2, 5, 5 }, { 1, 5, 8, -1 } ) )
				assert_false( turbo.segment.getSegmentIntersection( { 2, 2, 4, 2 }, { 2, 4, 6, 1 } ) )
			end )
			test( 'Returns both points if the lines are colinear', function()
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 3, 3, 1, 5 }, { 4, 2, 0, 6 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 3, 3, 0, 6 }, { 1, 5, 4, 2 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 3, 3, 0, 6 }, { 4, 2, 1, 5 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 0, 6, 3, 3 }, { 1, 5, 4, 2 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 0, 6, 3, 3 }, { 4, 2, 1, 5 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { turbo.segment.getSegmentIntersection( { 4, 2, 0, 6 }, { 3, 3, 1, 5 } ) }, { 3, 3, 1, 5 } )
				assert_false( turbo.segment.getSegmentIntersection( { 4, 2, 6, 0 }, { 0, 6, 1, 5 } ) )
			end )
		end )
	end )
	-- }}}
	-- {{{ segment.getClosestPoint
	context( 'getClosestPoint', function()
		context( 'turbo', function()
			test( 'Gives the closest point on a segment to a point', function()
				assert_multipleFuzzyEqual( { turbo.segment.getClosestPoint( 7, 1, 0, 0, 6, 8 ) }, { 3, 4 } )
				assert_multipleFuzzyEqual( { turbo.segment.getClosestPoint( -1, 7, 0, 0, 6, 8 ) }, { 3, 4 } )
				assert_multipleFuzzyEqual( { turbo.segment.getClosestPoint( -3, 1, 0, 0, 6, 8 ) }, { 0, 0 } )
				assert_multipleFuzzyEqual( { turbo.segment.getClosestPoint( 13, 11, 0, 0, 6, 8 ) }, { 6, 8 } )
			end )
		end )
	end )
	-- }}}
end )
-- }}}
