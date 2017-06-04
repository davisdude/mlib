-- MLib/util.lua

-- Handle floating point errors
local function checkFuzzy( x, y, delta )
	delta = delta or .001
	return math.abs( x - y ) <= delta
end

-- Handle multiple versions of Lua
local unpack = unpack or table.unpack

-- Validate parameter arguments
local function checkParam( cond, module, funcName, reason, ... )
	if not cond then
		for i = 1, select( '#', ... ) do
			local x = tostring( select( i, ... ) )
			reason = reason:gsub( '%%' .. i, function() return x end )
		end

		error( ( 'MLib.%s.%s: %s' ):format( module, funcName, reason ) )
	end
end

-- Validate points
local function checkPoint( x, y, xName, yName, module, funcName )
	local tx, ty = type( x ), type( y )
	checkParam( tx == 'number', module, funcName, '%1: Expected number, got %2.', xName, tx )
	checkParam( ty == 'number', module, funcName, '%1: Expected number, got %2.', yName, ty )
end

-- Check slope
local function checkSlope( m, paramName, module, funcName )
	local tm = type( m )
	if tm ~= 'number' then
		checkParam( m == false, module, funcName, '%1: Expected boolean (false) or number, got %2.', paramName, tm )
	end
end

return {
	checkFuzzy = checkFuzzy,
	unpack = unpack,
	checkParam = checkParam,
	checkPoint = checkPoint,
	checkSlope = checkSlope,

	-- Y-intercept has the same consditions
	checkYIntercept = checkSlope,
}
