#!/bin/bash

if pgrep -f "waybar -c /home/francois/.config/waybar/config_bottom.jsonc" >/dev/null; then
	pkill -f "waybar -c /home/francois/.config/waybar/config_bottom.jsonc"
else
	waybar -c "/home/francois/.config/waybar/config_bottom.jsonc" &
fi
