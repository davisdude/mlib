@echo off

copy /y mlib.lua ..\telescope\mlib.lua
copy /y spec\spec.lua ..\telescope\spec.lua

pushd ..\telescope
lua tsc -f spec.lua
pause

del mlib.lua
del spec.lua
popd

ldoc -c doc/config.ld -o index .