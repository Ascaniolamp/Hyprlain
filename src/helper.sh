#!/usr/bin/env bash
# set -euxo pipefail

RED="\033[0;31m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
NOCOLOR="\033[0m"

# Supported distros: Arch Linux (pacman + yay) and Fedora (dnf + COPR + Flatpak).
if [ -f /etc/fedora-release ]; then
	DISTRO=fedora
elif command -v pacman &> /dev/null; then
	DISTRO=arch
else
	echo -e "${RED}ERROR! Unsupported distro: Hyprlain supports Arch Linux and Fedora.${NOCOLOR}"
	exit 1
fi
export DISTRO

# Hyprland and most of its tooling aren't in Fedora's official repos.
FEDORA_COPR="sdegler/hyprland"

function confirmnonroot() {
	if [ "$EUID" -eq 0 ]; then
		echo -e "${RED}ERROR! Don't run the script as root, aborting.${NOCOLOR}"
		exit 1
	fi
}

function confirmonline() {
	if ! ping -c1 -w5 8.8.8.8 &> /dev/null && ! curl -fsS --max-time 5 https://github.com &> /dev/null; then
		echo -e "${RED}ERROR! System is offline, aborting.${NOCOLOR}"
		exit 1
	fi
}

function getsudo() {
	if ! command -v sudo &> /dev/null; then
		echo -e "${YELLOW}Command 'sudo' not found, installing...${NOCOLOR}"
		if [[ "$DISTRO" == "fedora" ]]; then
			su -c "dnf install -y sudo"
		else
			su -c "pacman -S --noconfirm sudo"
		fi
	fi
}

function getyay() {
	if ! command -v yay &> /dev/null; then
		echo -e "${YELLOW}Command 'yay' not found, installing...${NOCOLOR}"
		sudo pacman -S --needed --noconfirm git base-devel
		git clone --depth=1 https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si || { echo -e "${RED}ERROR! Couldn't build yay, aborting.${NOCOLOR}"; exit 1; }
		cd ..
		rm -rf yay
	fi
}

function getfedorarepos() {
	# Done once per run; every module's downdependencies relies on it.
	[[ -n "$HYPRLAIN_REPOS_READY" ]] && return 0
	sudo dnf install -y dnf5-plugins flatpak || true
	sudo dnf copr enable -y "$FEDORA_COPR" \
		|| { echo -e "${RED}ERROR! Couldn't enable COPR ${FEDORA_COPR}, aborting.${NOCOLOR}"; exit 1; }
	flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
	export HYPRLAIN_REPOS_READY=1
}

function pause() {
	echo -e "${GREEN}Press Enter to continue...${NOCOLOR}"; read -rp ""
}

function _confirm() { # _confirm <TXT> <Y/N/X>
	local PROMPT="$1"
	local DEFAULT="$2"
	local CONFIRMATION

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
			exit 2
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
		if [[ "$DISTRO" == "fedora" ]]; then
			sudo dnf install -y "$PKG"
		elif pacman -Si "$PKG" &> /dev/null; then
			sudo pacman -S --noconfirm "$PKG"
		else
			yay -S --needed --noconfirm "$PKG"
		fi
	fi
}

# Files under $HOME must stay owned by the user; only system paths need sudo.
function _asowner() { # _asowner <PATH> <CMD...>
	local TARGET="$1"; shift
	if [[ "$TARGET" == "$HOME"/* ]]; then
		"$@"
	else
		sudo "$@"
	fi
}

function handleold () {
	ACTOPTION="$1"
	DIRFILE="$2"

	case "$ACTOPTION" in
		"--no-preserve")
			_asowner "$DIRFILE" rm -rf "$DIRFILE"
			;;

		"backup")
			if [ -e "$DIRFILE" ]; then
				_asowner "$DIRFILE" rm -rf "${DIRFILE}.hyprlainbak"
				_asowner "$DIRFILE" mv "$DIRFILE" "${DIRFILE}.hyprlainbak"
			fi
			;;

		*)
			echo -e "${RED}Unrecognized argument '$1' passed to handleold function.${NOCOLOR}"
			exit 254
		;;
	esac

	_asowner "$DIRFILE" mkdir -p "$(dirname "$DIRFILE")"
}

function substitute () {
	ACTOPTION="$1"
	DIRFILE="$2"
	GITFILE="$3"

	handleold "$ACTOPTION" "$DIRFILE"
	_asowner "$DIRFILE" cp -r "$GITFILE" "$DIRFILE"
}

# Append SRCFILE to DEST inside marker comments, replacing any earlier copy,
# so re-running the installer doesn't stack duplicate blocks.
function appendblock () { # appendblock <DEST> <NAME> <SRCFILE>
	local DEST="$1" NAME="$2" SRC="$3"
	local BEGIN="# >>> hyprlain ${NAME} >>>" END="# <<< hyprlain ${NAME} <<<"
	touch "$DEST"
	sed -i "\|^${BEGIN}\$|,\|^${END}\$|d" "$DEST"
	_endnewline "$DEST"
	{ echo "$BEGIN"; cat "$SRC"; echo; echo "$END"; } >> "$DEST"
}

# Several shipped configs lack a trailing newline; appending straight onto
# them would glue the new line to the file's last line.
function _endnewline () { # _endnewline <FILE>
	[ -s "$1" ] && [ -n "$(tail -c1 "$1")" ] && echo >> "$1"
	return 0
}

function appendonce () { # appendonce <DEST> <LINE>
	touch "$1"
	grep -qxF "$2" "$1" && return 0
	_endnewline "$1"
	echo "$2" >> "$1"
}

# downdependencies <MODULE_SRC_DIR>
# Arch reads pacpkgs.lst + aurpkgs.lst; Fedora reads dnfpkgs.lst + flatpakpkgs.lst.
function downdependencies () {
	local SRCDIR="$1"
	local pkg

	if [[ -n "$HYPRLAIN_SKIP_PACKAGES" ]]; then
		echo -e "${YELLOW}Skipping packages for ${SRCDIR} (HYPRLAIN_SKIP_PACKAGES set).${NOCOLOR}"
		return 0
	fi

	if [[ "$DISTRO" == "fedora" ]]; then
		getfedorarepos
		if [ -s "${SRCDIR}/dnfpkgs.lst" ]; then
			# One transaction is far faster than one dnf call per package; fall
			# back to per-package so a single missing name doesn't block the rest.
			mapfile -t PKGS < <(grep -vE '^\s*(#|$)' "${SRCDIR}/dnfpkgs.lst")
			if (( ${#PKGS[@]} )) && ! sudo dnf install -y "${PKGS[@]}"; then
				for pkg in "${PKGS[@]}"; do
					sudo dnf install -y "$pkg" || echo -e "${RED}ERROR! Skipping DNF package: ${pkg}${NOCOLOR}"
				done
			fi
		fi
		if [ -s "${SRCDIR}/flatpakpkgs.lst" ]; then
			while read -r pkg; do
				[[ -z "$pkg" || "$pkg" == \#* ]] && continue
				flatpak install --user -y --noninteractive flathub "$pkg" \
					|| echo -e "${RED}ERROR! Skipping Flatpak: ${pkg}${NOCOLOR}"
			done < "${SRCDIR}/flatpakpkgs.lst"
		fi
		return 0
	fi

	sudo pacman -Syu
	while read -r pkg; do
		[[ -z "$pkg" ]] && continue
		( sudo pacman -S --needed --noconfirm "$pkg" || echo "ERROR! Skipping PACMAN package: $pkg" ) || true
	done < "${SRCDIR}/pacpkgs.lst"

	yay -Syu
	while read -r pkg; do
		[[ -z "$pkg" ]] && continue
		( yay -S --needed --noconfirm "$pkg" || echo "ERROR! Skipping AUR package: $pkg" ) || true
	done < "${SRCDIR}/aurpkgs.lst"
}

function helpersourced() {
	return 0
}

confirmnonroot
confirmonline
getsudo
[[ "$DISTRO" == "arch" ]] && getyay
