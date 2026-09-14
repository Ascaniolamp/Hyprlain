#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}"
source "${THISDIR}/helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

echo -e "${GREEN}Installing Hyprlain for ${DISTRO}.${NOCOLOR}"

downdependencies "${GITSRC}"

getpkg wget
getpkg unzip
NERDFONT_DIR=/usr/local/share/fonts/ttf/AdwaitaMonoNerd
NERDFONT_URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AdwaitaMono.zip
NERDFONT_ZIP=$(basename -- "$NERDFONT_URL")
handleold "$BAKORDEL" "$NERDFONT_DIR"
sudo wget "$NERDFONT_URL" -P "$NERDFONT_DIR"
sudo unzip -o "${NERDFONT_DIR}/${NERDFONT_ZIP}" -d "$NERDFONT_DIR"
sudo rm -f "${NERDFONT_DIR}/${NERDFONT_ZIP}"
[[ "$DISTRO" == "fedora" ]] && sudo restorecon -R "$NERDFONT_DIR" 2> /dev/null
sudo fc-cache -f "$NERDFONT_DIR" > /dev/null 2>&1 || true

# "${GITSRC}/albert/install.sh" "$BAKORDEL"
"${GITSRC}/dotfiles/install.sh" "$BAKORDEL"
"${GITSRC}/gtkqtxdg/install.sh" "$BAKORDEL"
"${GITSRC}/hyprland/install.sh" "$BAKORDEL"
"${GITSRC}/rofi/install.sh" "$BAKORDEL"

if confirmNy "Install the SDDM login screen theme? (replaces your current display manager)"; then
	"${GITSRC}/sddm/install.sh" "$BAKORDEL"
fi
if confirmNy "Install Spotify with the Hyprlain spicetify theme?"; then
	"${GITSRC}/spotify/install.sh" "$BAKORDEL"
fi
if confirmNy "Install Vesktop (Discord) with the Hyprlain theme?"; then
	"${GITSRC}/vesktop/install.sh" "$BAKORDEL"
fi

echo -e "${GREEN}Hyprlain was successfully installed!"
echo -e "You can now delete the installation folder."
if [[ "$DISTRO" == "fedora" ]]; then
	echo -e "Log out, then pick 'Hyprland' from the session menu on the login screen."
fi
echo -e "A restart is required for changes to take effect.${NOCOLOR}"
if confirmNy "Would you like to restart your device right now?"; then
	reboot
fi
