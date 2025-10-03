#!/usr/bin/env bash

config="$HOME/.config/waybar/config.jsonc"

# Check if Waybar with this specific config is running
if pgrep -f "waybar -c $config" >/dev/null; then
	echo "Waybar with config $config is running - killing it"
	pkill -f "waybar -c $config"
else
	echo "Waybar with config $config is not running - starting it"
	waybar -c "$config" &
fi
