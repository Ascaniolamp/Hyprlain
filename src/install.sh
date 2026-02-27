#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}"
source "${THISDIR}/helper.sh"

if [[ "$*" == *"--force-mac"* ]]; then
    export FORCE_MAC=1
    echo -e "${GREEN}Forcing MacBook Pro hardware fixes for portable USB...${NOCOLOR}"
fi

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

getpkg wget
getpkg unzip
NERDFONT_DIR=/usr/local/share/fonts/ttf/AdwaitaMonoNerd
NERDFONT_URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AdwaitaMono.zip
NERDFONT_ZIP=$(basename -- "$NERDFONT_URL")
if [ -z "$(ls -A "$NERDFONT_DIR" 2>/dev/null)" ] || [[ "$BAKORDEL" == "--no-preserve" ]]; then
	echo -e "${YELLOW}Downloading AdwaitaMono Nerd Font...${NOCOLOR}"
	handleold "$BAKORDEL" "$NERDFONT_DIR"
	sudo wget "$NERDFONT_URL" -P "$NERDFONT_DIR"
	sudo unzip -o "${NERDFONT_DIR}/${NERDFONT_ZIP}" -d "$NERDFONT_DIR"
	sudo rm -f "${NERDFONT_DIR}/${NERDFONT_ZIP}"
else
	echo -e "${GREEN}AdwaitaMono Nerd Font already installed, skipping download...${NOCOLOR}"
fi

"${GITSRC}/hardware/install.sh" "$BAKORDEL"
"${GITSRC}/albert/install.sh" "$BAKORDEL"
"${GITSRC}/dotfiles/install.sh" "$BAKORDEL"
"${GITSRC}/gtkqtxdg/install.sh" "$BAKORDEL"
"${GITSRC}/hyprland/install.sh" "$BAKORDEL"
"${GITSRC}/rofi/install.sh" "$BAKORDEL"
"${GITSRC}/sddm/install.sh" "$BAKORDEL"
"${GITSRC}/spotify/install.sh" "$BAKORDEL"
"${GITSRC}/vesktop/install.sh" "$BAKORDEL"

echo -e "${GREEN}Hyprlain was successfully installed!"
echo -e "You can now delete the installation folder."
echo -e "A restart is required for changes to take effect.${NOCOLOR}"
if [ -z "$AUTO_INSTALL" ]; then
	if confirmYn "Would you like to restart your device right now?"; then
		reboot
	fi
fi