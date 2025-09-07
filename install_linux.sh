#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Resolve user home (works on all Linux distros)
USER_HOME="${HOME}"

# Destination for scripts (your "C" subdir under Scripts)
DEST_SCRIPT_DIR="$USER_HOME/.local/share/DaVinciResolve/Fusion/Scripts/C"

# Destination for Lua modules
DEST_MODULE_DIR="$USER_HOME/.local/share/DaVinciResolve/Fusion/Modules/Lua"

echo "Installing DaVinci Resolve OilServer script and Lua modules..."
echo "Script source directory: $SCRIPT_DIR"
echo "Target script directory: $DEST_SCRIPT_DIR"
echo "Target module directory: $DEST_MODULE_DIR"

# Copy oilServer.lua
SOURCE_FILE="$SCRIPT_DIR/oilServer.lua"
mkdir -p "$DEST_SCRIPT_DIR"
cp "$SOURCE_FILE" "$DEST_SCRIPT_DIR"
echo "Copied oilServer.lua to $DEST_SCRIPT_DIR"

# Copy Lua modules
mkdir -p "$DEST_MODULE_DIR"

for MODULE in dkjson.lua ljsocket.lua utf8.lua; do
    SOURCE_FILE="$SCRIPT_DIR/LUAPackages/$MODULE"
    if [[ -f "$SOURCE_FILE" ]]; then
        cp "$SOURCE_FILE" "$DEST_MODULE_DIR"
        echo "Copied $MODULE to $DEST_MODULE_DIR"
    else
        echo "WARNING: $SOURCE_FILE not found, skipping..."
    fi
done

echo "✅ Installation complete!"
