#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

echo -e "${YELLOW}Downloading every theme's relative application...${NOCOLOR}"
downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

substitute "$BAKORDEL" "${HOME}/.local/share/audacious/Skins/lainampborders" "${GITSRC}/audacious/lainampborders"
echo "skin=${HOME}/.local/share/audacious/Skins/lainampborders" >> "${GITSRC}/audacious/config"
substitute "$BAKORDEL" "${HOME}/.config/audacious/config" "${GITSRC}/audacious/config"

echo -e "${YELLOW}To install the Firefox theme, follow the README's instructions!${NOCOLOR}"

cat "${GITSRC}/.profile" >> "${HOME}/.profile"
DOTPROFILE_SHLINE="[[ -f ~/.profile ]] && . ~/.profile"
echo "$DOTPROFILE_SHLINE" >> "${HOME}/.bashrc"
echo "$DOTPROFILE_SHLINE" >> "${HOME}/.zshrc"

getpkg git
git clone --depth=1 https://github.com/uiriansan/LainGrubTheme && cd LainGrubTheme && ./install.sh && ./patch_entries.sh

echo -e "${GREEN}Hyprlain dotfiles installed successfully.${NOCOLOR}"