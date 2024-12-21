@echo off
REM Copy oilServer from the current script directory to the DaVinci Resolve scripts directory.
copy "%~dp0oilServer.lua" "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Scripts\Utility\" /Y

copy "%~dp0\LUAPackages\dkjson.lua" "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Modules\Lua\"  /Y

copy "%~dp0\LUAPackages\ljsocket.lua" "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Modules\Lua\"  /Y

copy "%~dp0\LUAPackages\utf8.lua" "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Modules\Lua\"  /Y


pause


