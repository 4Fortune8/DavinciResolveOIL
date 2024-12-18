@echo off
REM Copy oilServer from the current script directory to the DaVinci Resolve scripts directory.
copy "%~dp0oilServer.lua" "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Scripts\Utility\" /Y
pause
