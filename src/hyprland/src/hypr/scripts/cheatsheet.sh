#!/usr/bin/env bash

# Launch cheatsheet in a persistent kitty window.
# glow renders markdown; the trailing `read` keeps the terminal alive so the user can press any key to dismiss.
CHEATSHEET="$HOME/.config/hypr/cheatsheet.md"

if command -v glow &>/dev/null; then
    kitty --class cheatsheet bash -c "glow -p '$CHEATSHEET'; echo; echo '--- Press any key to close ---'; read -rsn1"
else
    kitty --class cheatsheet bash -c "less '$CHEATSHEET'"
fi
