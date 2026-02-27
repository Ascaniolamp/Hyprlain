#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

# basic Spotify installation and launcher setup
downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

mkdir -p "${HOME}/.config/spotify"
touch "${HOME}/.config/spotify/prefs"

echo -e "${GREEN}Spotify installed successfully (Spicetify removed).${NOCOLOR}"