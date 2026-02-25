#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

echo "prefs_path = ${HOME}/.config/spotify/prefs" >> "${GITSRC}/config-xpui.ini"
echo "spotify_path = ${HOME}/.local/share/spotify-launcher/install/usr/share/spotify/" >> "${GITSRC}/config-xpui.ini"
substitute "$BAKORDEL" "${HOME}/.config/spicetify/Themes/Hyprlain" "${GITSRC}/Hyprlain"
substitute "$BAKORDEL" "${HOME}/.config/spicetify/config-xpui.ini" "${GITSRC}/config-xpui.ini"

getpkg spotify
spotify&
mkdir -p /opt/spotify/Apps
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
mkdir -p "${HOME}/.config/spotify"
touch "${HOME}/.config/spotify/prefs"

(curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh) || true
spicetify || true
spicetify backup apply || true
spicetify update || true
spicetify apply || true
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
killall spotify

echo -e "${GREEN}Spotify Hyprlain theme installed successfully.${NOCOLOR}"