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
	VESKTOP_CONF="${HOME}/.var/app/dev.vencord.Vesktop/config/vesktop"
else
	VESKTOP_CONF="${HOME}/.config/vesktop"
fi

# settings.json enables "hyprlain.theme.css", so the theme must be installed under that name.
substitute "$BAKORDEL" "${VESKTOP_CONF}/settings/settings.json" "${GITSRC}/settings.json"
substitute "$BAKORDEL" "${VESKTOP_CONF}/themes/hyprlain.theme.css" "${GITSRC}/hyprlain.css"

echo -e "${GREEN}Vesktop Hyprlain theme installed successfully.${NOCOLOR}"
