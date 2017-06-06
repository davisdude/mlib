-- MLib 0.12.0
-- https://github.com/davisdude/mlib
-- mlib/init.lua
-- MIT License

local path = (...):gsub( '/', '.' ):gsub( '%.init$', '' ) .. '.'

local mlib = {
	line = require( path .. 'line' ),
	segment = require( path .. 'segment' ),
}

return mlib
