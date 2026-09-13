#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}"

substitute "$BAKORDEL" "${HOME}/.config/rofi/themes/Hyprlain.rasi" "${GITSRC}/Hyprlain.rasi"
substitute "$BAKORDEL" "${HOME}/.config/rofi/config.rasi" "${GITSRC}/config.rasi"

if [[ "$DISTRO" == "fedora" ]]; then
	# rofi-calc and rofi-emoji aren't packaged for Fedora, and rofi refuses to
	# start with an unknown mode. Emoji picking uses rofimoji instead.
	sed -i 's|modes: \[combi, calc, window, emoji\];|modes: [combi, window];|' "${HOME}/.config/rofi/config.rasi"
fi

echo -e "${GREEN}Rofi Hyprlain theme installed successfully.${NOCOLOR}"
