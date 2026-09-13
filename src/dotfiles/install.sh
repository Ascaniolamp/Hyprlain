#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

echo -e "${YELLOW}You might just want to keep these themes for the time in which you'll download their apps.${NOCOLOR}"
if confirmYN "Would you like to download every theme's relative application?"; then
	downdependencies "${GITSRC}"
fi

substitute "$BAKORDEL" "${HOME}/.local/share/audacious/Skins/lainampborders" "${GITSRC}/audacious/lainampborders"
substitute "$BAKORDEL" "${HOME}/.config/audacious/config" "${GITSRC}/audacious/config"
appendonce "${HOME}/.config/audacious/config" "skin=${HOME}/.local/share/audacious/Skins/lainampborders"

echo -e "${YELLOW}To install the Firefox theme, follow the README's instructions!${NOCOLOR}"

appendblock "${HOME}/.profile" dotfiles "${GITSRC}/.profile"
DOTPROFILE_SHLINE="[[ -f ~/.profile ]] && . ~/.profile"
appendonce "${HOME}/.bashrc" "$DOTPROFILE_SHLINE"
appendonce "${HOME}/.zshrc" "$DOTPROFILE_SHLINE"

if [[ "$DISTRO" == "arch" ]]; then
	getpkg git
	git clone --depth=1 https://github.com/uiriansan/LainGrubTheme && cd LainGrubTheme && ./install.sh && ./patch_entries.sh
else
	# LainGrubTheme targets Arch's GRUB layout; patching boot entries on Fedora
	# (grub2 + BLS entries, often an NVIDIA akmod setup) risks an unbootable system.
	echo -e "${YELLOW}Skipping the GRUB theme on Fedora.${NOCOLOR}"
fi

echo -e "${GREEN}Hyprlain dotfiles installed successfully.${NOCOLOR}"
