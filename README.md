# DavinciResolveOIL
**OIL** (Online Import Layer) is a tool built to sent images and videos directly from your browser to Davinci resolve Media bin.

This project was inspired by Autosubs and borrows some code and logic
https://github.com/tmoroney/auto-subs

Check it out its amazing


## Installation Guide Video 



## How to use
1. Install OIL and Download the browser extention **[Firefox](https://addons.mozilla.org/en-US/firefox/addon/davinchi-oil/)** | **[Chrome](https://chromewebstore.google.com/detail/davinchi-oil/akjgkdnifpjpjkhfajnmbeegkkaipeko?authuser=0&hl=en)**
2. open a resolve project
3. click On Workspace -> Script -> OilServer
4. Find a phonto or video (mp4 only for now, Ill add more formats in OIL 0.2)
5. Right Click, hoveer over Davinci oil
6. Send to API
7. When done right click in browser -> hover over Davinci oil -> press exit
   
## Auto Setup

### To install OIL on windows:
Click on AutosetupDavinci

install the browser extention 

### on Mac
Same thing but MacAutoInstaller.sh

### on linux 
chmod +x install_linux.sh

./install_linux.sh


## Extensions

**[Firefox](https://addons.mozilla.org/en-US/firefox/addon/davinchi-oil/)** | **[Chrome](https://chromewebstore.google.com/detail/davinchi-oil/akjgkdnifpjpjkhfajnmbeegkkaipeko?authuser=0&hl=en)**


 
## Manual Setup
### windows
copy the oilServer.lua file to "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Scripts\Utility\"

copy all files in LUAPackages to "%APPDATA%\Blackmagic Design\DaVinci Resolve\Support\Fusion\Modules\Lua\"

### mac
copy the oilServer.lua file to "/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Utility/"

copy all files in LUAPackages to "Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Modules/Lua/"

### Ubuntu/pop-os 
copy the oilServer.lua file to "~/.local/share/DaVinciResolve/Fusion/Templates/Fusion/Scripts/Utility/"

copy all files in LUAPackages to "~/.local/share/DaVinciResolve/Fusion/Modules/Lua/"



## Tools used or planned to be used
MP4Box is found at **https://github.com/gpac/gpac**  --- this will be used for wrangling file formats not compatabile with resolve

## This is early beta, join my discord or leave an issue, or fix it yourself and merge your fix :)
https://discord.gg/fC8wPvzWT7


### serach engine key words

Import to bin

Browser to Resolve
Browser save davinci resolve
