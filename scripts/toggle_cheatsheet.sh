#!/usr/bin/env bash
SCRIPT="$HOME/Projects/nixos/scripts/cheatsheet.sh"

if hyprctl clients -j | grep -q '"class": "cheatsheet"'; then
    hyprctl dispatch closewindow class:cheatsheet
    exit
fi

hyprctl dispatch exec \
    "[float; center; size 900 580] ghostty --class=cheatsheet --title=Keybindings -e bash -c \"python3 '$SCRIPT'; printf '\n  \033[2mPress any key to close...\033[0m\n'; read -rn1\""
