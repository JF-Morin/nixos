#!/usr/bin/env python3
import sys
from pathlib import Path

try:
    import tomllib
except ImportError:
    print("Error: requires Python 3.11+", file=sys.stderr)
    sys.exit(1)

TOML = Path.home() / "Projects/nixos/homeManager/modules/wm/keybinds.toml"

ICONS = {
    "super":    "",  # nf-fa-windows
    "shift":    "⇧",
    "ctrl":     "⌃",
    "alt":      "⌥",
    "terminal": "",  # nf-fa-terminal
    "browser":  "",  # nf-fa-globe
    "folder":   "",  # nf-fa-folder
    "files":    "",  # nf-fa-file
    "chart":    "",  # nf-fa-bar-chart
    "gear":     "",  # nf-fa-gear
    "audio":    "",  # nf-fa-volume-up
    "lock":     "",  # nf-fa-lock
    "help":     "",  # nf-fa-question
    "mouse":    "",  # nf-fa-mouse-pointer
    "camera":   "",  # nf-fa-camera
    "music":    "",  # nf-fa-music
}

R   = "\033[0m"
B   = "\033[1m"
D   = "\033[2m"
CYN = "\033[38;5;81m"
YLW = "\033[38;5;214m"
GRN = "\033[38;5;114m"
GRY = "\033[38;5;245m"

PAD = 30

def expand(s: str) -> str:
    for name, icon in ICONS.items():
        s = s.replace(f"{{{name}}}", icon)
    return s


def main_json() -> None:
    import json
    with open(TOML, "rb") as f:
        data = tomllib.load(f)
    result = {"section": []}
    for section in data["section"]:
        s = {"title": expand(section["title"]), "bind": []}
        for bind in section.get("bind", []):
            s["bind"].append({"key": expand(bind["key"]), "desc": expand(bind["desc"])})
        result["section"].append(s)
    sys.stdout.write(json.dumps(result, ensure_ascii=False))

def main() -> None:
    with open(TOML, "rb") as f:
        data = tomllib.load(f)

    lines: list[str] = []
    lines.append(f"\n  {B}┌──────────────────────────────────────────────────────────────┐{R}")
    lines.append(f"  {B}│                    HYPRLAND  KEYBINDINGS                     │{R}")
    lines.append(f"  {B}└──────────────────────────────────────────────────────────────┘{R}")

    for section in data["section"]:
        t = expand(section["title"])
        lines.append(f"\n  {B}{YLW}{t}{R}")
        lines.append(f"  {D}{GRY}{'─' * 66}{R}")
        for bind in section.get("bind", []):
            k = expand(bind["key"])
            d = expand(bind["desc"])
            lines.append(f"  {CYN}{k:<{PAD}}{R}  {GRN}{d}{R}")

    lines.append("")
    sys.stdout.write("\n".join(lines) + "\n")
    sys.stdout.flush()

if __name__ == "__main__":
    if "--json" in sys.argv:
        main_json()
    else:
        main()
