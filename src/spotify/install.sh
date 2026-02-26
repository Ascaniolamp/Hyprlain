#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

if ! grep -q "prefs_path" "${GITSRC}/config-xpui.ini"; then
	echo "prefs_path = ${HOME}/.config/spotify/prefs" >> "${GITSRC}/config-xpui.ini"
fi
if ! grep -q "spotify_path" "${GITSRC}/config-xpui.ini"; then
	echo "spotify_path = ${HOME}/.local/share/spotify-launcher/install/usr/share/spotify/" >> "${GITSRC}/config-xpui.ini"
fi
substitute "$BAKORDEL" "${HOME}/.config/spicetify/Themes/Hyprlain" "${GITSRC}/Hyprlain"
substitute "$BAKORDEL" "${HOME}/.config/spicetify/config-xpui.ini" "${GITSRC}/config-xpui.ini"

getpkg spotify
mkdir -p /opt/spotify/Apps || true
sudo chmod a+wr /opt/spotify 2>/dev/null || true
sudo chmod a+wr /opt/spotify/Apps -R 2>/dev/null || true
mkdir -p "${HOME}/.config/spotify"
touch "${HOME}/.config/spotify/prefs"

(curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sed "s/read -r choice < \/dev\/tty/choice=Y/g" | sh) || true
spicetify || true
spicetify backup apply || true
spicetify update || true
spicetify apply || true
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh || true
killall spotify 2>/dev/null || true

echo -e "${GREEN}Spotify Hyprlain theme installed successfully.${NOCOLOR}"