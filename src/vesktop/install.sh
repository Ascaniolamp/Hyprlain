#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

# Only apply if the theme file exists in the source
if [ -f "${GITSRC}/hyprlain.theme.css" ]; then
    substitute "$BAKORDEL" "${HOME}/.config/vesktop/settings/settings.json" "${GITSRC}/settings.json"
    substitute "$BAKORDEL" "${HOME}/.config/vesktop/themes/hyprlain.theme.css" "${GITSRC}/hyprlain.theme.css"
    echo -e "${GREEN}Vesktop Hyprlain theme installed successfully.${NOCOLOR}"
else
    echo -e "${YELLOW}Vesktop theme source not found, skipping theme apply.${NOCOLOR}"
fi