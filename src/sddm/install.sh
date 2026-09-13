#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}"

substitute "$BAKORDEL" "/etc/sddm.conf" "${GITSRC}/sddm.conf"
substitute "$BAKORDEL" "/usr/share/sddm/themes/Hyprlain" "${GITSRC}/Hyprlain"

if [[ "$DISTRO" == "fedora" ]]; then
	sudo restorecon -R /etc/sddm.conf /usr/share/sddm/themes/Hyprlain 2> /dev/null
	# Fedora Workstation ships GDM; only one display manager can own the login.
	if systemctl is-enabled --quiet gdm 2> /dev/null; then
		if confirmNy "GDM is your login screen. Switch to SDDM now?"; then
			sudo systemctl disable gdm
			sudo systemctl enable sddm
		else
			echo -e "${YELLOW}Theme installed but GDM stays active. Switch later with:"
			echo -e "sudo systemctl disable gdm && sudo systemctl enable sddm${NOCOLOR}"
		fi
	else
		sudo systemctl enable sddm
	fi
fi

echo -e "${GREEN}SDDM Hyprlain theme installed successfully. Test with the following command:"
echo -e "sddm-greeter --test-mode --theme /usr/share/sddm/themes/Hyprlain${NOCOLOR}"
