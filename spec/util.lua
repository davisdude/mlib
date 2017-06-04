local telescope = require( 'telescope' )
local util = require( 'mlib.util' )

-- Make sure all functions are checked
local checked = {}
for i in pairs( util ) do
	checked[i] = false
end

local oldContext = context
function context( name, func )
	checked[name] = true
	oldContext( name, func )
end

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

context( 'util', function()
	context( 'checkFuzzy', function()
		test( 'Default range (.001)', function()
			assert_true( util.checkFuzzy( math.pi, 3.141 ) )
			assert_false( util.checkFuzzy( 1, 2 ) )
			assert_false( util.checkFuzzy( 1, 1.01 ) )
		end )

		test( 'Custom range', function()
			assert_true( util.checkFuzzy( 1, 2, 2 ) )
			assert_false( util.checkFuzzy( 1, 4, 2 ) )
		end )
	end )

	context( 'unpack', function()
		test( 'Works like table.unpack/unpack', function()
			assert_true( select( '#', util.unpack{ 1, 2, 3 } ) == 3 )
			assert_true( select( 1, util.unpack{ 1, 2, 3 } ) == 1 )
			assert_true( select( 2, util.unpack{ 1, 2, 3 } ) == 2 )
			assert_true( select( 3, util.unpack{ 1, 2, 3 } ) == 3 )
		end )
	end )

	context( 'checkParam', function()
		test( 'Passes', function()
			assert_nil( util.checkParam( type( 1 ) == 'number', 'foo', 'bar', 'baz' ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.getSlope: because', function()
				util.checkParam( type( 1 ) == 'string', 'line', 'getSlope', 'because' )
			end )

			assert_error_equals( 'MLib.foo.bar: because', function()
				util.checkParam( type( 1 ) == 'string', 'foo', 'bar', 'because' )
			end )
		end )

		test( 'Error handling with %', function()
			assert_error_equals( 'MLib.line.getSlope: Expected x to be of type number, got string', function()
				local t = type( 'a' )
				util.checkParam( t == 'number', 'line', 'getSlope', 'Expected %1 to be of type number, got %2', 'x', t )
			end )
		end )
	end )

	context( 'checkPoint', function()
		test( 'Passes', function()
			assert_nil( util.checkPoint( 1, 1, 'x', 'y', 'line', 'getSlope' ) )
		end )

		test( 'Error handling', function()
			assert_error_equals( 'MLib.line.getSlope: x: Expected number, got nil', function()
				util.checkPoint( nil, 1, 'x', 'y', 'line', 'getSlope' )
			end )

			assert_error_equals( 'MLib.foo.bar: asdf: Expected number, got boolean', function()
				util.checkPoint( 1, true, 'x', 'asdf', 'foo', 'bar' )
			end )
		end )
	end )

	context( 'checkSlope', function()
		test( 'Passes with numbers', function()
			assert_nil( util.checkSlope( 3, 'foo', 'bar', 'biz' ) )
		end )

		test( 'Passes with `false`', function()
			assert_nil( util.checkSlope( false, 'foo', 'bar', 'biz' ) )
		end )

		test( 'Fails with other values', function()
			assert_error_equals( 'MLib.bar.biz: foo: Expected boolean (false) or number, got boolean', function()
				util.checkSlope( true, 'foo', 'bar', 'biz' )
			end )

			assert_error_equals( 'MLib.bar.biz: foo: Expected boolean (false) or number, got string', function()
				util.checkSlope( '3', 'foo', 'bar', 'biz' )
			end )
		end )
	end )

	context( 'checkYIntercept', function()
		test( 'Is the same as checkSlope', function()
			assert_equal( util.checkSlope, util.checkYIntercept )
		end )
	end )

	context( 'All functions checked', function()
		for i in pairs( util ) do
			test( tostring( i .. ' tested' ), function()
				assert_true( checked[i] )
			end )
		end
	end )
end )
