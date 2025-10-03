#!/bin/bash

# Detect active device type (ethernet / wifi / default)
active_dev_type=$(nmcli -t -f DEVICE,TYPE,STATE device status |
	grep ':connected' |
	grep -E 'ethernet|wifi' |
	grep -v '^lo:' |
	cut -d: -f2 |
	sed '/^\s*$/d' |
	sed 's/^[[:space:]]*//; s/[[:space:]]*$//' |
	head -n1)

# Landscape configs
config_wired_landscape="$HOME/.config/waybar/config_bottom_desktop_wired_landscape.jsonc"
config_wifi_landscape="$HOME/.config/waybar/config_bottom_desktop_wifi_landscape.jsonc"
config_default_landscape="$HOME/.config/waybar/config_bottom_landscape.jsonc"

# Portrait configs
config_wired_portrait="$HOME/.config/waybar/config_bottom_desktop_wired_portrait.jsonc"
config_wifi_portrait="$HOME/.config/waybar/config_bottom_desktop_wifi_portrait.jsonc"
config_default_portrait="$HOME/.config/waybar/config_bottom_portrait.jsonc"

# Pick config set based on network type
if [[ "$active_dev_type" == "ethernet" ]]; then
	config_landscape="$config_wired_landscape"
	config_portrait="$config_wired_portrait"
elif [[ "$active_dev_type" == "wifi" ]]; then
	config_landscape="$config_wifi_landscape"
	config_portrait="$config_wifi_portrait"
else
	config_landscape="$config_default_landscape"
	config_portrait="$config_default_portrait"
fi

# Detect DP-2 resolution
transform=$(hyprctl monitors -j | jq -r '.[] | select(.name=="DP-2") | "\(.transform)"')
# orientation = transform * 90 degree.

if [[ -z "$transform" ]]; then
	echo "❌ DP-2 not found"
	exit 1
fi

# Kill existing Waybar
pkill -f "waybar -c $config_landscape"
pkill -f "waybar -c $config_portrait"
sleep 0.2

# Decide orientation

if [[ "$transform" == "1" || "$transform" == "3" ]]; then
	echo "📐 DP-2 is portrait , transform = $transform"
	waybar -c "$config_portrait" &
else
	echo "📐 DP-2 is landscape , transform = $transform"
	waybar -c "$config_landscape" &
fi
