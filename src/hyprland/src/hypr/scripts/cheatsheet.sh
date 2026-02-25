#!/usr/bin/env bash

# Launch cheatsheet in a persistent kitty window.
# glow renders markdown; the trailing `read` keeps the terminal alive so the user can press any key to dismiss.
CHEATSHEET="$HOME/.config/hypr/cheatsheet.md"

if command -v glow &>/dev/null; then
    kitty --class cheatsheet --hold -e glow "$CHEATSHEET"
else
    kitty --class cheatsheet --hold -e less "$CHEATSHEET"
fi
