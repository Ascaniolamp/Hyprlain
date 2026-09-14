#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}"

if [[ "$DISTRO" == "fedora" ]]; then
	# Per-user Flatpak, so spicetify can patch Spotify without chmod'ing system dirs.
	SPOTIFY_PREFS="${HOME}/.var/app/com.spotify.Client/config/spotify/prefs"
	SPOTIFY_PATH="${HOME}/.local/share/flatpak/app/com.spotify.Client/current/active/files/extra/share/spotify/"
	SPOTIFY_RUN=(flatpak run com.spotify.Client)
else
	SPOTIFY_PREFS="${HOME}/.config/spotify/prefs"
	SPOTIFY_PATH="${HOME}/.local/share/spotify-launcher/install/usr/share/spotify/"
	SPOTIFY_RUN=(spotify)
fi

substitute "$BAKORDEL" "${HOME}/.config/spicetify/Themes/Hyprlain" "${GITSRC}/Hyprlain"
substitute "$BAKORDEL" "${HOME}/.config/spicetify/config-xpui.ini" "${GITSRC}/config-xpui.ini"
sed -i '/^prefs_path/d; /^spotify_path/d' "${HOME}/.config/spicetify/config-xpui.ini"
sed -i "/^\[Setting\]/a prefs_path = ${SPOTIFY_PREFS}\nspotify_path = ${SPOTIFY_PATH}" "${HOME}/.config/spicetify/config-xpui.ini"

if [[ "$DISTRO" == "arch" ]]; then
	getpkg spotify
	mkdir -p /opt/spotify/Apps
	sudo chmod a+wr /opt/spotify
	sudo chmod a+wr /opt/spotify/Apps -R
fi

# Spotify writes its prefs file on first launch; spicetify needs it to exist.
"${SPOTIFY_RUN[@]}" &> /dev/null &
sleep 10
mkdir -p "$(dirname "$SPOTIFY_PREFS")"
touch "$SPOTIFY_PREFS"

(curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh) || true
SPICETIFY="$(command -v spicetify || echo "${HOME}/.spicetify/spicetify")"
"$SPICETIFY"
"$SPICETIFY" backup apply
"$SPICETIFY" update
"$SPICETIFY" apply
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
pkill -f -i 'share/spotify/spotify' || killall spotify 2> /dev/null

echo -e "${GREEN}Spotify Hyprlain theme installed successfully.${NOCOLOR}"
