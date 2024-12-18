#!/usr/bin/env bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source file and destination directory
SOURCE_FILE="$SCRIPT_DIR/oilServer.lua"
DEST_DIR="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Utility/"

# Copy the file to the destination. If the directory doesn't exist, create it.
mkdir -p "$DEST_DIR"
cp "$SOURCE_FILE" "$DEST_DIR"

echo "oilServer.lua has been copied to $DEST_DIR"
