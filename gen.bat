@echo off
cd %~dp0

copy /y mlib.lua ..\telescope\mlib.lua
copy /y mlib_turbo.lua ..\telescope\mlib_turbo.lua
copy /y spec\spec.lua ..\telescope\spec.lua

pushd ..\telescope
lua tsc -f spec.lua
pause

del mlib.lua
del mlib_turbo.lua
del spec.lua
popd

ldoc -c doc/config.ld -o index .
