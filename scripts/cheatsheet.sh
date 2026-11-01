#!/usr/bin/env bash

R=$'\033[0m'
B=$'\033[1m'
D=$'\033[2m'
CYN=$'\033[38;5;81m'
YLW=$'\033[38;5;214m'
GRN=$'\033[38;5;114m'
GRY=$'\033[38;5;245m'

# Modifier icons — standard Unicode (always renders)
SFT='⇧'
CTL='⌃'
ALT='⌥'

# Key icons — Nerd Fonts BMP range (U+F000–U+F2E0, Font Awesome)
SUP=$''    # nf-fa-windows
ICO_TERM=$''   # nf-fa-terminal
ICO_BROWSER=$'' # nf-fa-globe
ICO_FOLDER=$''  # nf-fa-folder
ICO_FILES=$''   # nf-fa-file
ICO_CHART=$''   # nf-fa-bar-chart  (system resources)
ICO_GEAR=$''    # nf-fa-gear       (control center)
ICO_AUDIO=$''   # nf-fa-volume-up
ICO_LOCK=$''    # nf-fa-lock
ICO_HELP=$''    # nf-fa-question
ICO_MOUSE=$''   # nf-fa-mouse-pointer
ICO_CAMERA=$''  # nf-fa-camera
ICO_MUSIC=$''   # nf-fa-music

PAD=30

# Compensates printf "%-Ns" for multi-byte / wide chars so descriptions align.
overhead() {
    printf '%s' "$1" | python3 -c "
import sys, unicodedata
s = sys.stdin.read()
blen = len(s.encode('utf-8'))
dwidth = sum(2 if unicodedata.east_asian_width(c) in ('W','F') else 1 for c in s)
print(blen - dwidth)
"
}

section() {
    echo ""
    printf "  ${B}${YLW}%s${R}\n" "$1"
    printf "  ${D}${GRY}"
    printf '%.0s─' $(seq 1 66)
    printf "${R}\n"
}

row() {
    local keys="$1"
    local desc="$2"
    local adj=$((PAD + $(overhead "$keys")))
    printf "  ${CYN}%-${adj}s${R}  ${GRN}%s${R}\n" "$keys" "$desc"
}

echo ""
printf "  ${B}┌──────────────────────────────────────────────────────────────┐${R}\n"
printf "  ${B}│                    HYPRLAND  KEYBINDINGS                     │${R}\n"
printf "  ${B}└──────────────────────────────────────────────────────────────┘${R}\n"

section "${SUP}  Super — Launch & Navigate"
row "${SUP} + Space"                        "Launcher"
row "${SUP} + Esc"                          "Session menu"
row "${SUP} + T"                            "${ICO_TERM} Terminal"
row "${SUP} + B"                            "${ICO_BROWSER} Browser"
row "${SUP} + E"                            "${ICO_FOLDER} File manager"
row "${SUP} + Y"                            "${ICO_FILES} Yazi  (TUI file browser)"
row "${SUP} + R"                            "${ICO_CHART} Herdr (system resources)"
row "${SUP} + C"                            "${ICO_GEAR} Control center"
row "${SUP} + A"                            "${ICO_AUDIO} Audio switcher"
row "${SUP} + L"                            "${ICO_LOCK} Lock screen"
row "${SUP} + S"                            "Toggle special workspace"
row "${SUP} + ?"                            "${ICO_HELP} Toggle this cheatsheet"
row "${SUP} + h  or  ←"                    "Previous workspace"
row "${SUP} + l  or  →"                    "Next workspace"
row "${SUP} + 1 ... 0"                      "Go to workspace N"

section "${SUP} + ${SFT}  Super+Shift — Shift Window"
row "${SUP} + ${SFT} + Q"                   "Kill window"
row "${SUP} + ${SFT} + h  or  ←"           "Move window to prev workspace"
row "${SUP} + ${SFT} + l  or  →"           "Move window to next workspace"
row "${SUP} + ${SFT} + S"                   "Move to special workspace"
row "${SUP} + ${SFT} + 1 ... 0"             "Move window to workspace N"

section "${SUP} + ${CTL}  Super+Ctrl — Control Focus"
row "${SUP} + ${CTL} + h  or  ←"           "Focus left"
row "${SUP} + ${CTL} + l  or  →"           "Focus right"
row "${SUP} + ${CTL} + k  or  ↑"           "Focus up"
row "${SUP} + ${CTL} + j  or  ↓"           "Focus down"

section "${SUP} + ${ALT}  Super+Alt — Alter (Resize)"
row "${SUP} + ${ALT} + h  or  ←"           "Shrink width"
row "${SUP} + ${ALT} + l  or  →"           "Grow width"
row "${SUP} + ${ALT} + k  or  ↑"           "Shrink height"
row "${SUP} + ${ALT} + j  or  ↓"           "Grow height"

section "${SUP} + ${SFT} + ${ALT}  Super+Shift+Alt — Move in Layout"
row "${SUP} + ${SFT} + ${ALT} + h  or  ←"  "Move window left in layout"
row "${SUP} + ${SFT} + ${ALT} + l  or  →"  "Move window right in layout"
row "${SUP} + ${SFT} + ${ALT} + k  or  ↑"  "Move window up in layout"
row "${SUP} + ${SFT} + ${ALT} + j  or  ↓"  "Move window down in layout"

section "${ICO_MOUSE}  Mouse  (hold Super)"
row "${SUP} + drag LMB"                     "Move window"
row "${SUP} + drag RMB"                     "Resize window"
row "${SUP} + scroll"                       "Switch workspace"

section "${ICO_CAMERA}  Screenshots"
row "Print"                                 "Region screenshot"
row "${SFT} + Print"                        "Fullscreen screenshot"
row "${CTL} + Print"                        "Annotate screenshot"

section "${ICO_MUSIC}  Media & Hardware"
row "Volume Up / Down"                      "+/- 5% volume"
row "Mute / Mic Mute"                      "Toggle mute"
row "Play / Pause"                          "Toggle playback"
row "Next / Prev"                           "Next / previous track"
row "Brightness Up / Down"                 "+/- 10% brightness"

echo ""
