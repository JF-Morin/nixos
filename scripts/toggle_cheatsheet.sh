#!/usr/bin/env bash
if hyprctl clients -j | grep -q '"class": "cheatsheet"'; then
    hyprctl dispatch closewindow class:cheatsheet
else
    ghostty --class=cheatsheet --title="Keybindings" \
        -e bash -c '
            bash "$HOME/Projects/nixos/scripts/cheatsheet.sh"
            printf "\n  \033[2mPress any key to close...\033[0m\n"
            read -n1
        '
fi
