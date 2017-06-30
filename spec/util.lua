-- MLib 0.12.0
-- https://github.com/davisdude/mlib
-- spec/util.lua
-- MIT License

local Util = require( 'mlib.util' )

-- Make sure all functions are checked
local checked = {}
for i in pairs( Util ) do
	checked[i] = false
end

local oldDescribe = describe
function describe( name, func )
	checked[name] = true
	oldDescribe( name, func )
end

describe( 'Util', function()
	describe( 'checkFuzzy', function()
		it( 'Default range (.001)', function()
			assert.True( Util.checkFuzzy( math.pi, 3.141 ) )
			assert.False( Util.checkFuzzy( 1, 2 ) )
			assert.False( Util.checkFuzzy( 1, 1.01 ) )
		end )

		it( 'Custom range', function()
			assert.True( Util.checkFuzzy( 1, 2, 2 ) )
			assert.False( Util.checkFuzzy( 1, 4, 2 ) )
		end )
	end )

	describe( 'unpack', function()
		it( 'Works like table.unpack/unpack', function()
			assert.True( select( '#', Util.unpack{ 1, 2, 3 } ) == 3 )
			assert.True( select( 1, Util.unpack{ 1, 2, 3 } ) == 1 )
			assert.True( select( 2, Util.unpack{ 1, 2, 3 } ) == 2 )
			assert.True( select( 3, Util.unpack{ 1, 2, 3 } ) == 3 )
		end )
	end )

	describe( 'checkParam', function()
		it( 'Passes', function()
			assert.is_nil( Util.checkParam( type( 1 ) == 'number', 'foo', 'bar', 'baz' ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Util.checkParam( type( 1 ) == 'string', 'line', 'getSlope', 'because' )
			end, 'MLib.line.getSlope: because' )

			assert.has_error( function()
				Util.checkParam( type( 1 ) == 'string', 'foo', 'bar', 'because' )
			end, 'MLib.foo.bar: because' )
		end )

		it( 'Error handling with %', function()
			assert.has_error( function()
				local t = type( 'a' )
				Util.checkParam( t == 'number', 'line', 'getSlope', 'Expected %1 to be of type number, got %2', 'x', t )
			end, 'MLib.line.getSlope: Expected x to be of type number, got string' )
		end )
	end )

	describe( 'checkPoint', function()
		it( 'Passes', function()
			assert.is_nil( Util.checkPoint( 1, 1, 'x', 'y', 'line', 'getSlope' ) )
		end )

		it( 'Error handling', function()
			assert.has_error( function()
				Util.checkPoint( nil, 1, 'x', 'y', 'line', 'getSlope' )
			end, 'MLib.line.getSlope: x: Expected number, got nil.' )

			assert.has_error( function()
				Util.checkPoint( 1, true, 'x', 'asdf', 'foo', 'bar' )
			end, 'MLib.foo.bar: asdf: Expected number, got boolean.' )
		end )
	end )

	describe( 'checkSlope', function()
		it( 'Passes with numbers', function()
			assert.is_nil( Util.checkSlope( 3, 'foo', 'bar', 'biz' ) )
		end )

		it( 'Passes with `false`', function()
			assert.is_nil( Util.checkSlope( false, 'foo', 'bar', 'biz' ) )
		end )

		it( 'Fails with other values', function()
			assert.has_error( function()
				Util.checkSlope( true, 'foo', 'bar', 'biz' )
			end, 'MLib.bar.biz: foo: Expected boolean (false) or number, got boolean.' )

			assert.has_error( function()
				Util.checkSlope( '3', 'foo', 'bar', 'biz' )
			end, 'MLib.bar.biz: foo: Expected boolean (false) or number, got string.' )
		end )
	end )

	describe( 'checkYIntercept', function()
		it( 'Is the same as checkSlope', function()
			assert.is_equal( Util.checkSlope, Util.checkYIntercept )
		end )
	end )

	describe( 'All functions checked', function()
		for i in pairs( Util ) do
			it( tostring( i .. ' tested' ), function()
				assert.True( checked[i] )
			end )
		end
	end )
end )
