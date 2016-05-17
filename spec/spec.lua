require 'telescope'

local mlib = require 'mlib'
local turbo = require 'mlib_turbo'

-- {{{ Helpers
-- Make a table with the structure of the contexts
local _context = context
local contexts = {}
local map = {}
local function context( str, func )
    table.insert( map, str )
    local function newFunc()
        func()
        map[#map] = nil
    end
    local c = contexts
    for i = 1, #map - 1 do
        c = c[map[i]]
    end
    c[str] = {}
    _context( str, newFunc )
end

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
				assert_fuzzyEqual( mlib.line.getSlope{ 0, 0, 1, 1 }, 1 )
				assert_fuzzyEqual( mlib.line.getSlope{ 4, 3, 6, 15 }, 6 )
				
				mlib.compatibilityMode = true
				assert_fuzzyEqual( mlib.line.getSlope( 0, 0, 1, 1 ), 1 )
				assert_fuzzyEqual( mlib.line.getSlope( 4, 3, 6, 15 ), 6 )
			end )
			test( 'Returns false if the line is vertical given 2 tables', function()
				assert_false( mlib.line.getSlope( 0, 0, 0, 10 ) )
				assert_false( mlib.line.getSlope( 4, 3, 4, 4 ) )
				assert_false( mlib.line.getSlope{ 0, 0, 0, 10 } )
				assert_false( mlib.line.getSlope{ 4, 3, 4, 4 } )
			end )
			context( 'Error handling', function()
				test( '1 arg, no compat', function()
					assert_errorIs( function() mlib.line.getSlope( 1 ) end,
						'MLib: line.getSlope: arg 1: with <= 1 arg expected a table, got number'
					)
					assert_errorIs( function() mlib.line.getSlope{ '0', 0, 1, 1 } end,
						'MLib: line.getSlope: arg 1: with <= 1 arg expected [1] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getSlope{ 0, '0', 1, 1 } end,
						'MLib: line.getSlope: arg 1: with <= 1 arg expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getSlope{ 0, 0, '1', 1 } end,
						'MLib: line.getSlope: arg 1: with <= 1 arg expected [3] to be a number, got string, 1'
					)
					assert_errorIs( function() mlib.line.getSlope{ 0, 0, 1, '1' } end,
						'MLib: line.getSlope: arg 1: with <= 1 arg expected [4] to be a number, got string, 1'
					)
				end )
				test( '4 arg, no compat', function()
					assert_errorIs( function() mlib.line.getSlope( '0', 0, 1, 1 ) end,
						'MLib: line.getSlope: arg 1: with > 1 arg expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getSlope( 0, '0', 1, 1 ) end,
						'MLib: line.getSlope: arg 2: with > 1 arg expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getSlope( 0, 0, '1', 1 ) end,
						'MLib: line.getSlope: arg 3: with > 1 arg expected a number, got string, 1'
					)
					assert_errorIs( function() mlib.line.getSlope( 0, 0, 1, '1' ) end,
						'MLib: line.getSlope: arg 4: with > 1 arg expected a number, got string, 1'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.line.getSlope( { 0, 0 }, 1, 1 ) end,
						'MLib: line.getSlope: arg 1: in compatibility mode expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.line.getSlope( { 0, 0, 1, 1 } ) end,
						'MLib: line.getSlope: arg 1: in compatibility mode expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.line.getSlope( 0, '0', 1, 1 ) end,
						'MLib: line.getSlope: arg 2: in compatibility mode expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getSlope( 0, 0, { 1, 1 } ) end,
						'MLib: line.getSlope: arg 3: in compatibility mode expected a number, got table, table:'
					)
				end )
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
			test( 'Gives the perpendicular slope of a line', function()
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( 0, 0, 1, 1 ), -1 )
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( 3 ), -1 / 3 )
				
				mlib.compatibilityMode = true
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( 3 ), -1 / 3 )
			end )
			test( '0 if the line is vertical', function()
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( 0, 0, 0, 1 ), 0 )
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( 50, 30, 50, 20 ), 0 )
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( false ), 0 )

				mlib.compatiblityMode = true
				assert_fuzzyEqual( mlib.line.getPerpendicularSlope( false ), 0 )
			end )
			test( 'False if the line is horizontal', function()
				assert_false( mlib.line.getPerpendicularSlope( 0, 1, 1, 1 ) )
				assert_false( mlib.line.getPerpendicularSlope( 30, 50, 20, 50 ) )
				assert_false( mlib.line.getPerpendicularSlope( 0 ) )

				mlib.compatibilityMode = true
				assert_false( mlib.line.getPerpendicularSlope( 0 ) )
			end )
			context( 'Error handling', function()
				test( '1 arg, no compat', function()
					assert_errorIs( function() mlib.line.getPerpendicularSlope( '1' ) end,
						'MLib: line.getPerpendicularSlope: arg 1: with <= 1 arg expected a number or boolean (false), got string, 1'
					)
				end )
				test( '4 args, no compat', function()
					assert_errorIs( function() mlib.line.getPerpendicularSlope( '0', 0, 1, 1 ) end,
						'MLib: line.getPerpendicularSlope: arg 1: with > 1 arg expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getPerpendicularSlope( 0, '0', 1, 1 ) end,
						'MLib: line.getPerpendicularSlope: arg 2: with > 1 arg expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getPerpendicularSlope( 0, 0, '1', 1 ) end,
						'MLib: line.getPerpendicularSlope: arg 3: with > 1 arg expected a number, got string, 1'
					)
					assert_errorIs( function() mlib.line.getPerpendicularSlope( 0, 0, 1, '1' ) end,
						'MLib: line.getPerpendicularSlope: arg 4: with > 1 arg expected a number, got string, 1'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.line.getPerpendicularSlope( { 0, 0 }, 1, 1 ) end,
						'MLib: line.getPerpendicularSlope: in compatibility mode expected 1 arg, got 3'
					)
					assert_errorIs( function() mlib.line.getPerpendicularSlope( '1' ) end,
						'MLib: line.getPerpendicularSlope: arg 1: in compatibility mode expected a number or boolean (false), got string, 1'
					)
				end )
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

				mlib.compatibilityMode = true
				assert_fuzzyEqual( mlib.line.getIntercept( 2, 1, 4 ), 2 )
				assert_fuzzyEqual( mlib.line.getIntercept( 5, 2, 10 ), 0 )
			end )
			test( 'Gets the y-intercept of a line given points', function()
				assert_fuzzyEqual( mlib.line.getIntercept( 0, 0, 1, 1 ), 0 )
				assert_fuzzyEqual( mlib.line.getIntercept( 1, 4, 2, 6 ), 2 )
				assert_fuzzyEqual( mlib.line.getIntercept( 4, 20, 2, 10 ), 0 )
			end )
			context( 'Error handling', function()
				test( '3 args, no compat', function()
					assert_errorIs( function() mlib.line.getIntercept( '1', 2, 1 ) end,
						'MLib: line.getIntercept: arg 1: with 3 args expected a number or boolean (false), got string, 1'
					)
					assert_errorIs( function() mlib.line.getIntercept( 1, '2', 1 ) end,
						'MLib: line.getIntercept: arg 2: with 3 args expected a number, got string, 2'
					)
					assert_errorIs( function() mlib.line.getIntercept( 1, 2, '1' ) end,
						'MLib: line.getIntercept: arg 3: with 3 args expected a number, got string, 1'
					)
				end )
				test( '4 args, no compat', function()
					assert_errorIs( function() mlib.line.getIntercept( false, 0, 1, 1 ) end,
						'MLib: line.getIntercept: arg 1: with > 3 args expected a number, got boolean, false'
					)
					assert_errorIs( function() mlib.line.getIntercept( 0, '0', 1, 1 ) end ,
						'MLib: line.getIntercept: arg 2: with > 3 args expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getIntercept( 0, 0, '1', 1 ) end ,
						'MLib: line.getIntercept: arg 3: with > 3 args expected a number, got string, 1'
					)
					assert_errorIs( function() mlib.line.getIntercept( 0, 0, 1, '1' ) end ,
						'MLib: line.getIntercept: arg 4: with > 3 args expected a number, got string, 1'
					)
				end )
				test( 'Compatibility mode', function()
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
			test( 'Gives the intersection of two lines', function()
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 1, 0, 0 }, { -1, 0, 2 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 1, 0, 0 }, { 0, 2, 2, 0 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 0, 0, 2, 2 }, { -1, 0, 2 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 0, 0, 2, 2 }, { 0, 2, 2, 0 } ) }, { 1, 1 } )
				
				mlib.compatibilityMode = true
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 1, 0, 0 }, { -1, 0, 2 } ) }, { 1, 1 } )
			end )
			test( 'Handles vertical lines', function()
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 0, 0, 0, 2 }, { -1, 1, 1, 1 } ) }, { 0, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { -1, 1, 1, 1}, { 0, 0, 0, 2 } ) }, { 0, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { false, 5, 5 }, { 0, 3, 3 } ) }, { 5, 3 } )
				assert_multipleFuzzyEqual( { mlib.line.getLineIntersection( { 0, 5, 5 }, { false, 3, 3 } ) }, { 3, 5 } )
				assert_true( mlib.line.getLineIntersection( { 0, 0, 0, 2 }, { 0, 1, 0, 3 } ) )
				assert_false( mlib.line.getLineIntersection( { 0, 0, 0, 2 }, { 1, 1, 1, 3 } ) )
			end )
			context( 'Error handling', function()
				context( 'line1; no compat', function()
					test( '3 args', function()
						assert_errorIs( function() mlib.line.getLineIntersection( { '1', 0, 0 }, { 2, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 1: expected [1] to be a number or boolean (false), got string, 1'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 1, false, 0 }, { 2, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 1: expected [2] to be a number, got boolean, false'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, nil }, { 2, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 1: expected [3] to be a number, got nil, nil'
						)
					end )
					test( '4 args', function()
						assert_errorIs( function() mlib.line.getLineIntersection( { '1', 0, 0, 0 }, { 2, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 1: with # > 3 expected [1] to be a number, got string, 1'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 1, false, 0, 0 }, { 2, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 1: with # > 3 expected [2] to be a number, got boolean, false'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, nil, 0 }, { 2, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 1: with # > 3 expected [3] to be a number, got nil, nil'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, 0, function() return 5 end }, { 2, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 1: with # > 3 expected [4] to be a number, got function, function:'
						)
					end )
				end )
				context( 'line2, no compat', function()
					test( '3 args', function()
						assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { '1', 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 2: expected [1] to be a number or boolean (false), got string, 1'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, false, 0 }) end,
							'MLib: line.getLineIntersection: arg 2: expected [2] to be a number, got boolean, false'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, 0 } ) end,
							'MLib: line.getLineIntersection: arg 2: expected [3] to be a number, got nil, nil'
						)
					end )
					test( '4 args', function()
						assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, 0 }, { false, 0, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 2: with # > 3 expected [1] to be a number with # > 3, got boolean, false'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, 0, 0, function() return 5 end } ) end,
							'MLib: line.getLineIntersection: arg 2: with # > 3 expected [4] to be a number, got function, function:'
						)
						assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { false, 0, 0, 0 } ) end,
							'MLib: line.getLineIntersection: arg 2: with # > 3 expected [1] to be a number with # > 3, got boolean, false'
						)
					end )
				end )

				test( 'line1, compat', function()
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
				end )
				test( 'line2, compat', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { '1', 0, 0 } ) end,
						'MLib: line.getLineIntersection: arg 2: in compatibility mode expected [1] to be a number or boolean (false), got string, 1'
					)
					assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, '0', 0 } ) end,
						'MLib: line.getLineIntersection: arg 2: in compatibility mode expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getLineIntersection( { 2, 0, 0 }, { 1, 0, '0' } ) end,
						'MLib: line.getLineIntersection: arg 2: in compatibility mode expected [3] to be a number, got string, 0'
					)
				end )

				test( 'misc', function()
					assert_errorIs( function() mlib.line.getLineIntersection( 1, { 2, 0, 0 } ) end,
						'MLib: line.getLineIntersection: arg 1: expected a table, got number'
					)
					assert_errorIs( function() mlib.line.getLineIntersection( { 1, 0, 0 }, false ) end,
						'MLib: line.getLineIntersection: arg 2: expected a table, got boolean'
					)
				end )
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
	context( 'getClosestPoint', function()
		context( 'mlib', function()
			test( 'Gives the closest point on a line to regular, vertical, and horizontal lines', function()
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( 0, 4, 1, 0, 0 ) }, { 2, 2 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( 4, 2, -1, 2, 2 ) }, { 3, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( 4, -2, 0, 0, 2 ) }, { 4, 2 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( 2, 2, false, 4, 0 ) }, { 4, 2 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( 0, 2, { 0, 0, 1, 1 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.line.getClosestPoint( 4, -2, { 2, 2, 2, 4 } ) }, { 2, -2 } )
			end )
			context( 'Error handling', function()
				test( '3 args, no compat', function()
					assert_errorIs( function() mlib.line.getClosestPoint( 3, 2, 1 ) end,
						'MLib: line.getClosestPoint: arg 3: with <= 3 args expected a table, got number'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 3, 2, { '0', 0, 1, 1 } ) end,
						'MLib: line.getClosestPoint: arg 3: with <= 3 args expected [1] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 3, 2, { 0, '0', 1, 1 } ) end,
						'MLib: line.getClosestPoint: arg 3: with <= 3 args expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 3, 2, { 0, 0, '1', 1 } ) end,
						'MLib: line.getClosestPoint: arg 3: with <= 3 args expected [3] to be a number, got string, 1'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 3, 2, { 0, 0, 1, '1' } ) end,
						'MLib: line.getClosestPoint: arg 3: with <= 3 args expected [4] to be a number, got string, 1'
					)
				end )
				test( '4 args, no compat', function()
					assert_errorIs( function() mlib.line.getClosestPoint( 1, 0, '4', 1, 0 ) end,
						'MLib: line.getClosestPoint: arg 3: with > 3 args expected a number or boolean, got string, 4'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 0, 0, 4, '1', 0 ) end,
						'MLib: line.getClosestPoint: arg 4: with > 3 args expected a number, got string, 1'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 0, 0, 4, 1, '0' ) end,
						'MLib: line.getClosestPoint: arg 5: with > 3 args expected a number, got string, 0'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.line.getClosestPoint( 0, 4, '1', 0, 0 ) end,
						'MLib: line.getClosestPoint: arg 3: in compatibility mode expected a number or boolean, got string'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 0, 4, 1, '0', 0 ) end,
						'MLib: line.getClosestPoint: arg 4: in compatibility mode expected a number, got string'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 0, 4, 1, 0, '0' ) end,
						'MLib: line.getClosestPoint: arg 5: in compatibility mode expected a number, got string'
					)
				end )
				test( 'General', function()
					assert_errorIs( function() mlib.line.getClosestPoint( '1', 0, 1 ) end,
						'MLib: line.getClosestPoint: arg 1: expected a number, got string, 1'
					)
					assert_errorIs( function() mlib.line.getClosestPoint( 1, nil, 1 ) end,
						'MLib: line.getClosestPoint: arg 2: expected a number, got nil, nil'
					)
				end )
			end )
		end )
		context( 'turbo', function()
			test( 'Gives the closest point on a line to regular, vertical, and horizontal lines', function()
				assert_multipleFuzzyEqual( { turbo.line.getClosestPoint( 0, 4, 1, 0, 0 ) }, { 2, 2 } )
				assert_multipleFuzzyEqual( { turbo.line.getClosestPoint( 4, 2, -1, 2, 2 ) }, { 3, 1 } )
				assert_multipleFuzzyEqual( { turbo.line.getClosestPoint( 4, -2, 0, 0, 2 ) }, { 4, 2 } )
				assert_multipleFuzzyEqual( { turbo.line.getClosestPoint( 2, 2, false, 4, 0 ) }, { 4, 2 } )
			end )
		end )
	end )
	-- }}}
	-- {{{ line.checkPoint
	context( 'checkPoint', function()
		context( 'mlib', function()
			test( 'Checks if a point is on a line', function()
				assert_true( mlib.line.checkPoint( 3, 4, 1, 0, 1 ) )
				assert_true( mlib.line.checkPoint( -1, 3, -5, -2, 8 ) )
				assert_true( mlib.line.checkPoint( 3, 4, { 0, 1, 1, 2 } ) )
				assert_false( mlib.line.checkPoint( 3, 5, 1, 0, 1 ) )
				assert_false( mlib.line.checkPoint( -1, 0, -5, -2, 8 ) )
				assert_false( mlib.line.checkPoint( 3, 5, { 0, 1, 1, 2 } ) )
			end )
			test( 'Works with vertical lines', function()
				assert_true( mlib.line.checkPoint( 3, 4, false, 3, 0 ) )
				assert_true( mlib.line.checkPoint( -1, 3, false, -1, 100 ) )
				assert_true( mlib.line.checkPoint( -1, 3, { -1, 0, -1, 100 } ) )
			end )
			context( 'Error handling', function()
				test( '3 args, no compat', function()
					assert_errorIs( function() mlib.line.checkPoint( 3, 5 ) end,
						'MLib: line.checkPoint: arg 3: with 3 args expected a table, got nil'
					)
					assert_errorIs( function() mlib.line.checkPoint( 3, 5, { '0', 1, 1, 2 } ) end,
						'MLib: line.checkPoint: arg 3: with 3 args expected [1] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.checkPoint( 3, 5, { 0, '1', 1, 2 } ) end,
						'MLib: line.checkPoint: arg 3: with 3 args expected [2] to be a number, got string, 1'
					)
					assert_errorIs( function() mlib.line.checkPoint( 3, 5, { 0, 1, false, 2 } ) end,
						'MLib: line.checkPoint: arg 3: with 3 args expected [3] to be a number, got boolean, false'
					)
					assert_errorIs( function() mlib.line.checkPoint( 3, 5, { 0, 1, 1, {} } ) end,
						'MLib: line.checkPoint: arg 3: with 3 args expected [4] to be a number, got table, table:'
					)
				end )
				test( '5 args, no compat', function()
					assert_errorIs( function() mlib.line.checkPoint( 3, 4, '1', 0, 1 ) end,
						'MLib: line.checkPoint: arg 3: with > 3 args expected a number or boolean, got string, 1'
					)
					assert_errorIs( function() mlib.line.checkPoint( 3, 4, 1, '0', 1 ) end,
						'MLib: line.checkPoint: arg 4: with > 3 args expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.checkPoint( 3, 4, 1, 0, '1' ) end,
						'MLib: line.checkPoint: arg 5: with > 3 args expected a number, got string, 1'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.line.checkPoint( 3, 4, '1', 0, 1 ) end,
						'MLib: line.checkPoint: arg 3: in compatibility mode expected a number or boolean, got string, 1'
					)
					assert_errorIs( function() mlib.line.checkPoint( 3, 4, 1, '0', 1 ) end,
						'MLib: line.checkPoint: arg 4: in compatibility mode expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.line.checkPoint( 3, 4, 1, 0, '1' ) end,
						'MLib: line.checkPoint: arg 5: in compatibility mode expected a number, got string, 1'
					)
				end )
			end )
			test( 'General', function()
				assert_errorIs( function() mlib.line.checkPoint( '3', 4, 1, 0, 1 ) end,
					'MLib: line.checkPoint: arg 1: expected a number, got string, 3'
				)
				assert_errorIs( function() mlib.line.checkPoint( math.huge, 4, 1, 0, 1 ) end,
					-- math.huge depends on version
					'MLib: line.checkPoint: arg 1: expected a number, got number, ' .. tostring( math.huge )
				)
				assert_errorIs( function() mlib.line.checkPoint( 3, '4', 1, 0, 1 ) end,
					'MLib: line.checkPoint: arg 2: expected a number, got string, 4'
				)
			end )
		end )
		context( 'turbo', function()
			test( 'Checks if a point is on a line', function()
				assert_true( turbo.line.checkPoint( 3, 4, 1, 0, 1 ) )
				assert_true( turbo.line.checkPoint( -1, 3, -5, -2, 8 ) )
				assert_false( turbo.line.checkPoint( 3, 5, 1, 0, 1 ) )
				assert_false( turbo.line.checkPoint( -1, 0, -5, -2, 8 ) )
			end )
			test( 'Works with vertical lines', function()
				assert_true( turbo.line.checkPoint( 3, 4, false, 3, 0 ) )
				assert_true( turbo.line.checkPoint( -1, 3, false, -1, 100 ) )
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
			context( 'Error handling', function()
				test( '1 arg, no compat', function()
					assert_errorIs( function() mlib.segment.getMidpoint( 1 ) end,
						'MLib: segment.getMidpoint: arg 1: with <= 1 arg expected a table, got number'
					)
					assert_errorIs( function() mlib.segment.getMidpoint{ { 0, 0 }, 2, 2 } end,
						'MLib: segment.getMidpoint: arg 1: with <= 1 arg expected [1] to be a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getMidpoint{ 0, '0', 2, 2 } end,
						'MLib: segment.getMidpoint: arg 1: with <= 1 arg expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getMidpoint{ 0, 0, false, 3 } end,
						'MLib: segment.getMidpoint: arg 1: with <= 1 arg expected [3] to be a number, got boolean, false'
					)
					assert_errorIs( function() mlib.segment.getMidpoint{ 0, 0, 2 } end,
						'MLib: segment.getMidpoint: arg 1: with <= 1 arg expected [4] to be a number, got nil, nil'
					)
				end )
				test( '4 args, no compat', function()
					assert_errorIs( function() mlib.segment.getMidpoint( { 0, 0 }, 2, 2 ) end,
						'MLib: segment.getMidpoint: arg 1: with > 1 arg expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getMidpoint( 0, '0', 2, 2 ) end,
						'MLib: segment.getMidpoint: arg 2: with > 1 arg expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getMidpoint( 0, 0, false, 3 ) end,
						'MLib: segment.getMidpoint: arg 3: with > 1 arg expected a number, got boolean, false'
					)
					assert_errorIs( function() mlib.segment.getMidpoint( 0, 0, 2 ) end,
						'MLib: segment.getMidpoint: arg 4: with > 1 arg expected a number, got nil, nil'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.segment.getMidpoint( { 0, 0 }, 2, 2 ) end,
						'MLib: segment.getMidpoint: arg 1: in compatibility mode expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getMidpoint( { 0, 0, 2, 2 } ) end,
						'MLib: segment.getMidpoint: arg 1: in compatibility mode expected a number, got table'
					)
					assert_errorIs( function() mlib.segment.getMidpoint( 0, 0, false, 3 ) end,
						'MLib: segment.getMidpoint: arg 3: in compatibility mode expected a number, got boolean'
					)
				end )
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
				assert_fuzzyEqual( mlib.segment.getLength{ 0, 0, 1, 1 }, math.sqrt( 2 ) )
				assert_fuzzyEqual( mlib.segment.getLength{ 3, 5, 5, 5 }, 2 )
			end )
			context( 'Error handling', function()
				test( '1 arg, no compat', function()
					assert_errorIs( function() mlib.segment.getLength( 1 ) end,
						'MLib: segment.getLength: arg 1: with <= 1 arg expected a table, got number'
					)
					assert_errorIs( function() mlib.segment.getLength{ { 0, 0 }, 2, 2 } end,
						'MLib: segment.getLength: arg 1: with <= 1 arg expected [1] to be a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getLength{ 0, '0', 2, 2 } end,
						'MLib: segment.getLength: arg 1: with <= 1 arg expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLength{ 0, 0, false, 3 } end,
						'MLib: segment.getLength: arg 1: with <= 1 arg expected [3] to be a number, got boolean, false'
					)
					assert_errorIs( function() mlib.segment.getLength{ 0, 0, 2 } end,
						'MLib: segment.getLength: arg 1: with <= 1 arg expected [4] to be a number, got nil, nil'
					)
				end )
				test( '4 args, no compat', function()
					assert_errorIs( function() mlib.segment.getLength( { 0, 0 }, 2, 2 ) end,
						'MLib: segment.getLength: arg 1: with > 1 arg expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getLength( 0, '0', 2, 2 ) end,
						'MLib: segment.getLength: arg 2: with > 1 arg expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLength( 0, 0, false, 3 ) end,
						'MLib: segment.getLength: arg 3: with > 1 arg expected a number, got boolean, false'
					)
					assert_errorIs( function() mlib.segment.getLength( 0, 0, 2 ) end,
						'MLib: segment.getLength: arg 4: with > 1 arg expected a number, got nil, nil'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.segment.getLength( { 0, 0 }, 2, 2 ) end,
						'MLib: segment.getLength: arg 1: in compatibility mode expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getLength( { 0, 0, 2, 2 } ) end,
						'MLib: segment.getLength: arg 1: in compatibility mode expected a number, got table'
					)
					assert_errorIs( function() mlib.segment.getLength( 0, 0, false, 3 ) end,
						'MLib: segment.getLength: arg 3: in compatibility mode expected a number, got boolean'
					)
				end )
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
		context( 'mlib', function()
			test( 'Gets the squared length between two points', function()
				assert_fuzzyEqual( mlib.segment.getLength2( 0, 0, 1, 1 ), 2 )
				assert_fuzzyEqual( mlib.segment.getLength2( 2, 2, 2, 5 ), 9 )
				assert_fuzzyEqual( mlib.segment.getLength2( 3, 5, 5, 5 ), 4 )
				assert_fuzzyEqual( mlib.segment.getLength2{ 0, 0, 1, 1 }, 2 )
				assert_fuzzyEqual( mlib.segment.getLength2{ 3, 5, 5, 5 }, 4 )
			end )
			context( 'Error handling', function()
				test( '1 arg, no compat', function()
					assert_errorIs( function() mlib.segment.getLength2( 1 ) end,
						'MLib: segment.getLength2: arg 1: with <= 1 arg expected a table, got number'
					)
					assert_errorIs( function() mlib.segment.getLength2{ { 0, 0 }, 2, 2 } end,
						'MLib: segment.getLength2: arg 1: with <= 1 arg expected [1] to be a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getLength2{ 0, '0', 2, 2 } end,
						'MLib: segment.getLength2: arg 1: with <= 1 arg expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLength2{ 0, 0, false, 3 } end,
						'MLib: segment.getLength2: arg 1: with <= 1 arg expected [3] to be a number, got boolean, false'
					)
					assert_errorIs( function() mlib.segment.getLength2{ 0, 0, 2 } end,
						'MLib: segment.getLength2: arg 1: with <= 1 arg expected [4] to be a number, got nil, nil'
					)
				end )
				test( '4 args, no compat', function()
					assert_errorIs( function() mlib.segment.getLength2( { 0, 0 }, 2, 2 ) end,
						'MLib: segment.getLength2: arg 1: with > 1 arg expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getLength2( 0, '0', 2, 2 ) end,
						'MLib: segment.getLength2: arg 2: with > 1 arg expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLength2( 0, 0, false, 3 ) end,
						'MLib: segment.getLength2: arg 3: with > 1 arg expected a number, got boolean, false'
					)
					assert_errorIs( function() mlib.segment.getLength2( 0, 0, 2 ) end,
						'MLib: segment.getLength2: arg 4: with > 1 arg expected a number, got nil, nil'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.segment.getLength2( { 0, 0 }, 2, 2 ) end,
						'MLib: segment.getLength2: arg 1: in compatibility mode expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.getLength2( { 0, 0, 2, 2 } ) end,
						'MLib: segment.getLength2: arg 1: in compatibility mode expected a number, got table'
					)
					assert_errorIs( function() mlib.segment.getLength2( 0, 0, false, 3 ) end,
						'MLib: segment.getLength2: arg 3: in compatibility mode expected a number, got boolean'
					)
				end )
			end )
		end )
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
		context( 'mlib', function()
			test( 'Checks if a point is on a line segment', function()
				assert_true( mlib.segment.checkPoint( 1, 1, 0, 0, 2, 2 ) )
				assert_true( mlib.segment.checkPoint( 0, 0, 0, 0, 2, 2 ) )
				assert_true( mlib.segment.checkPoint( 2, 2, 0, 0, 2, 2 ) )
				assert_false( mlib.segment.checkPoint( -1, -1, 0, 0, 2, 2 ) )
				assert_false( mlib.segment.checkPoint( 3, 2, 0, 0, 2, 2 ) )
				assert_true( mlib.segment.checkPoint( 1, 1, { 0, 0, 2, 2 } ) )
				assert_false( mlib.segment.checkPoint( -1, -1, { 0, 0, 2, 2 } ) )
			end )
			context( 'Error handling', function()
				test( '3 args, no compat', function()
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, '1' ) end,
						'MLib: segment.checkPoint: arg 3: with <= 3 args expected a table, got string'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, { '0', 0, 2, 2 } ) end,
						'MLib: segment.checkPoint: arg 3: with <= 3 args expected [1] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, { 0, '0', 2, 2 } ) end,
						'MLib: segment.checkPoint: arg 3: with <= 3 args expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, { 0, 0, '2', 2 } ) end,
						'MLib: segment.checkPoint: arg 3: with <= 3 args expected [3] to be a number, got string, 2'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, { 0, 0, 2, '2' } ) end,
						'MLib: segment.checkPoint: arg 3: with <= 3 args expected [4] to be a number, got string, 2'
					)
				end )
				test( '6 args, no compat', function()
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, '0', 0, 2, 2 ) end,
						'MLib: segment.checkPoint: arg 3: with > 3 args expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, 0, '0', 2, 2 ) end,
						'MLib: segment.checkPoint: arg 4: with > 3 args expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, 0, 0, '2', 2 ) end,
						'MLib: segment.checkPoint: arg 5: with > 3 args expected a number, got string, 2'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, 0, 0, 2, '2' ) end,
						'MLib: segment.checkPoint: arg 6: with > 3 args expected a number, got string, 2'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, { 0, 0, 2, 2 } ) end,
						'MLib: segment.checkPoint: arg 3: in compatibility mode expected a number, got table, table:'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, '0', 0, 2, 2 ) end,
						'MLib: segment.checkPoint: arg 3: in compatibility mode expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, 0, '0', 2, 2 ) end,
						'MLib: segment.checkPoint: arg 4: in compatibility mode expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, 0, 0, '2', 2 ) end,
						'MLib: segment.checkPoint: arg 5: in compatibility mode expected a number, got string, 2'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, 1, 0, 0, 2, '2' ) end,
						'MLib: segment.checkPoint: arg 6: in compatibility mode expected a number, got string, 2'
					)
				end )
				test( 'General', function()
					assert_errorIs( function() mlib.segment.checkPoint( '1', 1, 0, 2, 2 ) end,
						'MLib: segment.checkPoint: arg 1: expected a number, got string, 1'
					)
					assert_errorIs( function() mlib.segment.checkPoint( 1, '1', 0, 0, 2, 2 ) end,
						'MLib: segment.checkPoint: arg 2: expected a number, got string, 1'
					)
				end )
			end )
		end )
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
		context( 'mlib', function()
			test( 'Gets the intersection of a line and segment', function()
				assert_multipleFuzzyEqual( { mlib.segment.getLineIntersection( { 1, 0, 0 }, { 0, 2, 2, 0 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.segment.getLineIntersection( { false, 0, 0 }, { -2, 2, 2, 0 } ) }, { 0, 1 } )
				assert_multipleFuzzyEqual( { mlib.segment.getLineIntersection( { -1 / 3, -2, 4 }, { 1, 1, 1, 3 } ) }, { 1, 3 } )
				assert_false( mlib.segment.getLineIntersection( { 1, 0, 0 }, { 0, 2, -2, 4 } ) )
				assert_false( mlib.segment.getLineIntersection( { false, 0, 0 }, { 4, 2, 3, 4 } ) )
				assert_false( mlib.segment.getLineIntersection( { -1 / 3, -2, 4 }, { 1, 2, -2, 3 } ) )
				assert_false( mlib.segment.getLineIntersection( { -2, 2, 0 }, { 0, 0, 0, 3 } ) )
				assert_multipleFuzzyEqual( { mlib.segment.getLineIntersection( { 0, 0, 1, 1 }, { 0, 2, 2, 0 } ) }, { 1, 1 } )
				assert_multipleFuzzyEqual( { mlib.segment.getLineIntersection( { 0, 0, 0, 3 }, { -2, 2, 2, 0 } ) }, { 0, 1 } )
				assert_multipleFuzzyEqual( { mlib.segment.getLineIntersection( { -2, 4, 1, 3 }, { 1, 1, 1, 3 } ) }, { 1, 3 } )
				assert_false( mlib.segment.getLineIntersection( { 0, 0, 1, 1 }, { 0, 2, -2, 4 } ) )
				assert_false( mlib.segment.getLineIntersection( { 0, 0, 0, 5 }, { 4, 2, 3, 4 } ) )
				assert_false( mlib.segment.getLineIntersection( { -2, 4, 1, 3 }, { 1, 2, -2, 3 } ) )
				assert_false( mlib.segment.getLineIntersection( { 2, 0, 0, 4 }, { 0, 0, 0, 3 } ) )
			end )
			context( 'Error handling', function()
				test( 'General', function()
					assert_errorIs( function() mlib.segment.getLineIntersection( 1, 1 )	end,
						'MLib: segment.getLineIntersection: arg 1: expected a table, got number'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( {}, 1 ) end,
						'MLib: segment.getLineIntersection: arg 2: expected a table, got number'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 0, 0, 1, 1 }, { '0', 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 2: expected [1] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 0, 0, 1, 1 }, { 0, '2', -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 2: expected [2] to be a number, got string, 2'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 0, 0, 1, 1 }, { 0, 2, '-2', 4 } ) end,
						'MLib: segment.getLineIntersection: arg 2: expected [3] to be a number, got string, -2'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 0, 0, 1, 1 }, { 0, 2, -2, '4' } ) end,
						'MLib: segment.getLineIntersection: arg 2: expected [4] to be a number, got string, 4'
					)
				end )
				test( 'Line has 3 args, no compat', function()
					assert_errorIs( function() mlib.segment.getLineIntersection( { '1', 0, 0 }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: with # <= 3 expected [1] to be a number or boolean (false), got string, 1'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 1, '0', 0 }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: with # <= 3 expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 1, 0, '0' }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: with # <= 3 expected [3] to be a number, got string, 0'
					)
				end )
				test( 'Line has 4 args, no compat', function()
					assert_errorIs( function() mlib.segment.getLineIntersection( { '0', 0, 1, 1 }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: with # > 3 expected [1] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 0, '0', 1, 1 }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: with # > 3 expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 0, 0, '1', 1 }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: with # > 3 expected [3] to be a number, got string, 1'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 0, 0, 1, '1' }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: with # > 3 expected [4] to be a number, got string, 1'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.segment.getLineIntersection( { '1', 0, 0 }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: in compatibility mode expected [1] to be a number or boolean (false), got string, 1'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 1, '0', 0 }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: in compatibility mode expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getLineIntersection( { 1, 0, '0' }, { 0, 2, -2, 4 } ) end,
						'MLib: segment.getLineIntersection: arg 1: in compatibility mode expected [3] to be a number, got string, 0'
					)
				end )
			end )
		end )
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
		context( 'mlib', function()
			test( 'Gives the intersection of two line segments', function()
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 0, 0, 5, 5 }, { 1, 5, 4, 2 } ) }, { 3, 3 } )
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 5, 2, 5, 5 }, { 1, 5, 7, 2 } ) }, { 5, 3 } )
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 2, 4, 8, 0 }, { 2, 2, 7, 2 } ) }, { 5, 2 } )
				assert_false( mlib.segment.getSegmentIntersection( { 0, 0, 5, 5 }, { 4, 2, 6, 4 } ) )
				assert_false( mlib.segment.getSegmentIntersection( { 5, 2, 5, 5 }, { 1, 5, 8, -1 } ) )
				assert_false( mlib.segment.getSegmentIntersection( { 2, 2, 4, 2 }, { 2, 4, 6, 1 } ) )
			end )
			test( 'Returns both points if the lines are colinear', function()
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 3, 3, 1, 5 }, { 4, 2, 0, 6 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 3, 3, 0, 6 }, { 1, 5, 4, 2 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 3, 3, 0, 6 }, { 4, 2, 1, 5 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 0, 6, 3, 3 }, { 1, 5, 4, 2 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 0, 6, 3, 3 }, { 4, 2, 1, 5 } ) }, { 3, 3, 1, 5 } )
				assert_multipleFuzzyEqual( { mlib.segment.getSegmentIntersection( { 4, 2, 0, 6 }, { 3, 3, 1, 5 } ) }, { 3, 3, 1, 5 } )
				assert_false( mlib.segment.getSegmentIntersection( { 4, 2, 6, 0 }, { 0, 6, 1, 5 } ) )
			end )
			context( 'Error handling', function()
				test( 'General', function()
					assert_errorIs( function() mlib.segment.getSegmentIntersection( 1, 1 ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected a table, got number'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( {}, 1 ) end,
						'MLib: segment.getSegmentIntersection: arg 2: expected a table, got number'
					)
				end )
				test( 'arg 1', function()
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { '3', 3, 1, 5 }, { 4, 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected [1] to be a number, got string, 3'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, '3', 1, 5 }, { 4, 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected [2] to be a number, got string, 3'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, 3, '1', 5 }, { 4, 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected [3] to be a number, got string, 1'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, 3, 1, '5' }, { 4, 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected [4] to be a number, got string, 5'
					)
				end )
				test( 'arg 1', function()
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { '3', 3, 1, 5 }, { 4, 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected [1] to be a number, got string, 3'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, '3', 1, 5 }, { 4, 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected [2] to be a number, got string, 3'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, 3, '1', 5 }, { 4, 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected [3] to be a number, got string, 1'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, 3, 1, '5' }, { 4, 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 1: expected [4] to be a number, got string, 5'
					)
				end )
				test( 'arg 2', function()
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, 3, 1, 5 }, { '4', 2, 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 2: expected [1] to be a number, got string, 4'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, 3, 1, 5 }, { 4, '2', 0, 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 2: expected [2] to be a number, got string, 2'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, 3, 1, 5 }, { 4, 2, '0', 6 } ) end,
						'MLib: segment.getSegmentIntersection: arg 2: expected [3] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getSegmentIntersection( { 3, 3, 1, 5 }, { 4, 2, 0, '6' } ) end,
						'MLib: segment.getSegmentIntersection: arg 2: expected [4] to be a number, got string, 6'
					)
				end )
			end )
		end )
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
		context( 'mlib', function()
			test( 'Gives the closest point on a segment to a point', function()
				assert_multipleFuzzyEqual( { mlib.segment.getClosestPoint( 7, 1, 0, 0, 6, 8 ) }, { 3, 4 } )
				assert_multipleFuzzyEqual( { mlib.segment.getClosestPoint( -1, 7, 0, 0, 6, 8 ) }, { 3, 4 } )
				assert_multipleFuzzyEqual( { mlib.segment.getClosestPoint( -3, 1, 0, 0, 6, 8 ) }, { 0, 0 } )
				assert_multipleFuzzyEqual( { mlib.segment.getClosestPoint( 13, 11, 0, 0, 6, 8 ) }, { 6, 8 } )
				assert_multipleFuzzyEqual( { mlib.segment.getClosestPoint( 7, 1, { 0, 0, 6, 8 } ) }, { 3, 4 } )
				assert_multipleFuzzyEqual( { mlib.segment.getClosestPoint( -1, 7, { 0, 0, 6, 8 } ) }, { 3, 4 } )
				assert_multipleFuzzyEqual( { mlib.segment.getClosestPoint( -3, 1, { 0, 0, 6, 8 } ) }, { 0, 0 } )
				assert_multipleFuzzyEqual( { mlib.segment.getClosestPoint( 13, 11, { 0, 0, 6, 8 } ) }, { 6, 8 } )
			end )
			context( 'Error handling', function()
				test( 'General', function()
					assert_errorIs( function() mlib.segment.getClosestPoint( '7', 1, 0, 0, 6, 8 ) end,
						'MLib: segment.getClosestPoint: arg 1: expected a number, got string, 7'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, '1', 0, 0, 6, 8 ) end,
						'MLib: segment.getClosestPoint: arg 2: expected a number, got string, 1'
					)
				end )
				test( '3 args, no compat', function()
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1 ) end,
						'MLib: segment.getClosestPoint: arg 3: with <= 3 args expected a table, got nil'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, { '0', 0, 6, 8 } ) end,
						'MLib: segment.getClosestPoint: arg 3: with <= 3 args expected [1] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, { 0, '0', 6, 8 } ) end,
						'MLib: segment.getClosestPoint: arg 3: with <= 3 args expected [2] to be a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, { 0, 0, '6', 8 } ) end,
						'MLib: segment.getClosestPoint: arg 3: with <= 3 args expected [3] to be a number, got string, 6'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, { 0, 0, 6, '8' } ) end,
						'MLib: segment.getClosestPoint: arg 3: with <= 3 args expected [4] to be a number, got string, 8'
					)
				end )
				test( '6 args, no compat', function()
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, '0', 0, 6, 8 ) end,
						'MLib: segment.getClosestPoint: arg 3: with > 3 args expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, 0, '0', 6, 8 ) end,
						'MLib: segment.getClosestPoint: arg 4: with > 3 args expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, 0, 0, '6', 8 ) end,
						'MLib: segment.getClosestPoint: arg 5: with > 3 args expected a number, got string, 6'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, 0, 0, 6, '8' ) end,
						'MLib: segment.getClosestPoint: arg 6: with > 3 args expected a number, got string, 8'
					)
				end )
				test( 'Compatibility mode', function()
					mlib.compatibilityMode = true
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, '0', 0, 6, 8 ) end,
						'MLib: segment.getClosestPoint: arg 3: in compatibility mode expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, 0, '0', 6, 8 ) end,
						'MLib: segment.getClosestPoint: arg 4: in compatibility mode expected a number, got string, 0'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, 0, 0, '6', 8 ) end,
						'MLib: segment.getClosestPoint: arg 5: in compatibility mode expected a number, got string, 6'
					)
					assert_errorIs( function() mlib.segment.getClosestPoint( 7, 1, 0, 0, 6, '8' ) end,
						'MLib: segment.getClosestPoint: arg 6: in compatibility mode expected a number, got string, 8'
					)
				end )
			end )
		end )
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
-- {{{ General
context( 'General', function()
	context( 'All MLib functions are tested', function()
		for i, v in pairs( mlib ) do
			if type( v ) == 'table' then
				context( i, function()
					for ii in pairs( v ) do
						test( ii, function()
							assert_true( not not contexts[i][ii]['mlib'] )
						end )
					end
				end )
			end
		end
	end )
	context( 'All turbo functions are tested', function()
		for i, v in pairs( turbo ) do
			if type( v ) == 'table' then
				context( i, function()
					for ii in pairs( v ) do
						test( ii, function()
							assert_true( not not contexts[i][ii]['turbo'] )
						end )
					end
				end )
			end
		end
	end )
	context( 'All turbo functions are present in MLib', function()
		for i, v in pairs( turbo ) do
			if type( v ) == 'table' then
				context( i, function()
					for ii in pairs( v ) do
						test( ii, function()
							assert_true( not not mlib[i][ii] )
						end )
					end
				end )
			end
		end
	end )
	context( 'All MLib functions are present in turbo', function()
		for i, v in pairs( mlib ) do
			if type( v ) == 'table' then
				context( i, function()
					for ii in pairs( v ) do
						test( ii, function()
							assert_true( not not turbo[i][ii] )
						end )
					end
				end )
			end
		end
	end )
end )
-- }}}
