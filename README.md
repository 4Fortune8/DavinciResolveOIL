# DavinchiResolveOIL
Online Import Layer is a tool built to intergrate browser activity with adding media and content directly to Davinchi resolve Media bin.

##How to use
1. Install OIL and Download the browser extention
2. open a resolve project
3. click On Workspace -> Script -> OilServer
4. Find a phonto or video (mp4 only for now)
5. Right Click, hoveer over Davinci oil
6. Send to API
7. When done right click in browser -> hoveer over Davinci oil -> press exit
   
## Auto Setup

### To install OIL on windows:
Click on AutosetupDavinchi

install the browser extention (firefox should work below, chrome is coming soon to app store)

### on Mac
Same thing but MacAutoInstaller.sh


## Manual Setup
### windows
copy the oilServer.lua file to "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Scripts\Utility\"

copy all files in LUAPackages to "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Modules\Lua\"

### mac
copy the oilServer.lua file to "/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Utility/"

copy all files in LUAPackages to "Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Modules/Lua/"


## Extensions

**[Firefox](https://addons.mozilla.org/en-US/firefox/addon/davinchi-oil/)** | **[Chrome]** Dev Only Option currently



## Tools used or planned to be used
MP4Box is found at **https://github.com/gpac/gpac**  --- this will be used for wrangling file formats not compatabile with resolve

## This is early beta, join my discord or leave an issue, or fix it yourself and merge your fix :)
https://discord.gg/fC8wPvzWT7
