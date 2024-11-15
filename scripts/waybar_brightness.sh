#!/bin/bash

# Get current brightness percentage
brightness=$(brightnessctl | grep Current | awk '{print $4}' | sed 's/%//' | sed 's/[()]//g' )

# Print the brightness level
echo "$brightness%"




