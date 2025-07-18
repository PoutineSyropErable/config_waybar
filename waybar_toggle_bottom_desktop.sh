#!/bin/bash

active_dev_type=$(nmcli -t -f DEVICE,TYPE,STATE device status |
	grep ':connected' |
	grep -E 'ethernet|wifi' |
	grep -v '^lo:' |
	cut -d: -f2 |
	sed '/^\s*$/d' |
	sed 's/^[[:space:]]*//; s/[[:space:]]*$//' |
	head -n1)

config_wired="$HOME/.config/waybar/config_bottom_desktop_wired.jsonc"
config_wifi="$HOME/.config/waybar/config_bottom_desktop_wifi.jsonc"
config_default="$HOME/.config/waybar/config_bottom.jsonc"

# Select config file based on type
if [[ "$active_dev_type" == "ethernet" ]]; then
	config_file="$config_wired"
	# notify-send "using eternet"
elif [[ "$active_dev_type" == "wifi" ]]; then
	config_file="$config_wifi"
	# notify-send "using wifi"
else
	config_file="$config_default"
	# notify-send "using default"
fi

# Check if either wired or wifi Waybar is running
wired_running=$(pgrep -f "waybar -c $config_wired")
wifi_running=$(pgrep -f "waybar -c $config_wifi")
default_running=$(pgrep -f "waybar -c $config_default")

if [[ -n "$wired_running" || -n "$wifi_running" || -n "$default_running" ]]; then
	# Kill both if any is running
	pkill -f "waybar -c $config_wired"
	pkill -f "waybar -c $config_wifi"
	pkill -f "waybar -c $config_default"
	# Optional small delay to ensure processes exit
	sleep 0.2
else
	# Start Waybar with the right config
	waybar -c "$config_file" &
fi
