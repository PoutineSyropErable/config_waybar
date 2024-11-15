#!/bin/bash

if pgrep -f "waybar -c /home/francois/.config/waybar/config_bottom_laptop.jsonc" >/dev/null; then
	pkill -f "waybar -c /home/francois/.config/waybar/config_bottom_laptop.jsonc"
else
	waybar -c "/home/francois/.config/waybar/config_bottom_laptop.jsonc" &
fi
