#!/usr/bin/env bash
# set -euxo pipefail

RED="\033[0;31m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
NOCOLOR="\033[0m"

function confirmnonroot() {
	if [ "$EUID" -eq 0 ]; then
		echo -e "${RED}ERROR! Don't run the script as root, aborting.${NOCOLOR}"
		exit 1
	fi
}

function confirmonline() {
	if ! ping -c1 -w5 8.8.8.8 &> /dev/null; then
		echo -e "${RED}ERROR! System is offline, aborting.${NOCOLOR}"
		exit 1
	fi
}

function getsudo() {
	if ! command -v sudo &> /dev/null; then
		echo -e "${YELLOW}Command 'sudo' not found, installing...${NOCOLOR}"
		su -c "pacman -S --noconfirm sudo"
	fi
}

function getyay() {
	if ! command -v yay &> /dev/null; then
		echo -e "${YELLOW}Command 'yay' not found, installing...${NOCOLOR}"
		sudo pacman -S --needed --noconfirm git base-devel
		git clone --depth=1 https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si --noconfirm || { echo -e "${RED}ERROR! Couldn't build yay, aborting.${NOCOLOR}"; exit 1; }
		cd ..
		rm -rf yay
	fi
}

function pause() {
	if [ -n "$AUTO_INSTALL" ]; then return 0; fi
	echo -e "${GREEN}Press Enter to continue...${NOCOLOR}"; read -rp ""
}

function _confirm() { # _confirm <TXT> <Y/N/X>
	local PROMPT="$1"
	local DEFAULT="$2"
	local CONFIRMATION

	if [ -n "$AUTO_INSTALL" ]; then
		if [[ "$DEFAULT" == "Y" ]] || [[ "$DEFAULT" == "X" ]]; then
			return 0
		elif [[ "$DEFAULT" == "N" ]]; then
			return 1
		fi
	fi

	while true; do
		read -rp "$PROMPT" CONFIRMATION
		case "$CONFIRMATION" in
			[Yy]* ) return 0;;
			[Nn]* ) return 1;;
			"" )
				if [[ "$DEFAULT" == "Y" ]]; then
					return 0
				elif [[ "$DEFAULT" == "N" ]]; then
					return 1
				fi
				;;
			* ) echo -e "${YELLOW}Please answer YES or NO.${NOCOLOR}";;
		esac
	done
}

function confirmYN() { # confirmYN <TXT>
	_confirm "$1 (Yes/No): " "X"
}

function confirmYn() { # confirmYn <TXT>
	_confirm "$1 (Y/n): " "Y"
}

function confirmNy() { # confirmNy <TXT>
	_confirm "$1 (y/N): " "N"
}

BAKORDEL="backup"
ARGUMENT="$1"
if ! [ $# -eq 0 ] && ! [ -z "$ARGUMENT" ]; then
	case "$ARGUMENT" in
		"--no-preserve")
			echo -e "${YELLOW}This option will delete all your previous configurations."
			echo -e "It may also risk affecting other associated files.${NOCOLOR}"
			if confirmNy; then
				BAKORDEL="--no-preserve"
				echo -e "${YELLOW}Proceeding by deletion.${NOCOLOR}"
			else
				echo -e "${GREEN}Aborting.${NOCOLOR}"
				exit 0
			fi
		;;

		"backup");;

		*)
			echo -e "${RED}install.sh: unrecognized option '$ARGUMENT'${NOCOLOR}"
			echo
			echo -e "${YELLOW}Usage: install.sh [OPTION]"
			echo -e "Options:"
			echo -e "  --no-preserve	Replace old files by deleting them.${NOCOLOR}${RED}[DANGEROUS]${NOCOLOR}"
		;;
	esac
fi

getpkg() { # getpkg <CMD> [<PKG>]
	local CMD="$1"
	local PKG="${2:-$CMD}"

	if ! command -v "$CMD" &> /dev/null; then
		if [[ "$CMD" == "$PKG" ]]; then
			echo -e "${YELLOW}Command '${CMD}' not found, installing...${NOCOLOR}"
		else
			echo -e "${YELLOW}Command '${CMD}' not found, installing package '${PKG}'...${NOCOLOR}"
		fi
		if pacman -Si --needed --noconfirm "$PKG" &> /dev/null; then
			sudo pacman -S --noconfirm "$PKG"
		else
			yay -S --needed --noconfirm "$PKG"
		fi
	fi
}

function handleold () {
	ACTOPTION="$1"
	DIRFILE="$2"

	case "$ACTOPTION" in
		"--no-preserve")
			sudo rm -r "$DIRFILE" || true
			;;

		"backup")
			sudo rm -r "${DIRFILE}.hyprlainbak" || true
			sudo mv "$DIRFILE" "${DIRFILE}.hyprlainbak" || true
			;;

		*)
			echo -e "${RED}Unrecognized argument '$1' passed to handleold function.${NOCOLOR}"
			exit 254
		;;
	esac

	sudo mkdir -p $(dirname "$DIRFILE")
}

function substitute () {
	ACTOPTION="$1"
	DIRFILE="$2"
	GITFILE="$3"

	handleold "$ACTOPTION" "$DIRFILE"
	sudo cp -r "$GITFILE" "$DIRFILE"
}

function downdependencies () {
	PACPKGS="$1"
	AURPKGS="$2"

	echo -e "${YELLOW}Syncing pacman databases...${NOCOLOR}"
	sudo pacman -Sy

	# Read all packages (excluding empty lines) into an array
	mapfile -t pacman_list < <(grep -v '^[[:space:]]*$' "$PACPKGS")
	if [ ${#pacman_list[@]} -gt 0 ]; then
		# Resolve known conflicts: archinstall pre-installs jack2 which conflicts with pipewire-jack
		if printf '%s\n' "${pacman_list[@]}" | grep -qx "pipewire-jack" && pacman -Qq jack2 &>/dev/null; then
			echo -e "${YELLOW}Removing conflicting jack2 in favour of pipewire-jack...${NOCOLOR}"
			sudo pacman -Rdd --noconfirm jack2 || true
		fi
		echo -e "${YELLOW}Installing PACMAN packages...${NOCOLOR}"
		sudo pacman -S --needed --noconfirm "${pacman_list[@]}" || echo -e "${RED}Warning: some pacman packages failed to install. Proceeding anyway.${NOCOLOR}"
	fi

	echo -e "${YELLOW}Syncing AUR databases...${NOCOLOR}"
	yay -Sy

	mapfile -t aur_list < <(grep -v '^[[:space:]]*$' "$AURPKGS")
	if [ ${#aur_list[@]} -gt 0 ]; then
		echo -e "${YELLOW}Installing AUR packages...${NOCOLOR}"
		yay -S --needed --noconfirm "${aur_list[@]}" || echo -e "${RED}Warning: some AUR packages failed to install. Proceeding anyway.${NOCOLOR}"
	fi
}

function helpersourced() {
	return 0
}

confirmnonroot
confirmonline
getsudo
getyay