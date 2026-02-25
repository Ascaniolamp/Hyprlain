#!/usr/bin/env bash

# Use glow or less to view the cheatsheet, assuming standard installation
if command -v glow &>/dev/null; then
    kitty --class cheatsheet -e glow ~/.config/hypr/cheatsheet.md
else
    kitty --class cheatsheet -e less ~/.config/hypr/cheatsheet.md
fi
