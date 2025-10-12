#!/bin/sh
#
# Restart waybar
#

# Kill Waybar
pkill waybar

# Start Waybar
waybar &
