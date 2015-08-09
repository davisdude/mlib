@echo off
cd "C:\Users\Davis Claiborne\Documents\GitHub\telescope"
" Update files
copy "C:\Users\Davis Claiborne\Documents\GitHub\mlib\mlib.lua" .
copy "C:\Users\Davis Claiborne\Documents\GitHub\mlib\spec.lua" .
" Run
lua tsc -f spec.lua
pause