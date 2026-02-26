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

if ! grep -q "source \${HOME}/.profile" "${HOME}/.profile" 2>/dev/null && ! grep -q "export PATH" "${HOME}/.profile" 2>/dev/null; then
	cat "${GITSRC}/.profile" >> "${HOME}/.profile"
fi

DOTPROFILE_SHLINE="[[ -f ~/.profile ]] && . ~/.profile"
if ! grep -qF "$DOTPROFILE_SHLINE" "${HOME}/.bashrc" 2>/dev/null; then
	echo "$DOTPROFILE_SHLINE" >> "${HOME}/.bashrc"
fi
if ! grep -qF "$DOTPROFILE_SHLINE" "${HOME}/.zshrc" 2>/dev/null; then
	echo "$DOTPROFILE_SHLINE" >> "${HOME}/.zshrc"
fi

getpkg git
if [ ! -d "LainGrubTheme" ]; then
	git clone --depth=1 https://github.com/uiriansan/LainGrubTheme && cd LainGrubTheme && ./install.sh && ./patch_entries.sh
else
	echo -e "${YELLOW}LainGrubTheme directory already exists, skipping clone...${NOCOLOR}"
	cd LainGrubTheme && ./install.sh && ./patch_entries.sh
fi

echo -e "${GREEN}Hyprlain dotfiles installed successfully.${NOCOLOR}"