#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}"

getpkg zsh
[[ "$DISTRO" == "fedora" ]] && getpkg chsh util-linux-user
handleold "$BAKORDEL" "${HOME}/.oh-my-zsh"
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
if [[ "$(basename "$SHELL")" != "zsh" ]] && confirmYn "Make zsh your default shell?"; then
	chsh -s "$(command -v zsh)"
fi

# local.conf holds per-machine overrides (monitors, GPU env, personal binds).
# It survives reinstalls: restore it from the backup the substitute below makes.
HYPR_LOCAL="${HOME}/.config/hypr/local.conf"
substitute "$BAKORDEL" "${HOME}/.config/wlogout/style.css" "${GITSRC}/wlogout/style.css"
substitute "$BAKORDEL" "${HOME}/.config/waybar/config.jsonc" "${GITSRC}/waybar/config.jsonc"
substitute "$BAKORDEL" "${HOME}/.config/waybar/power_menu.xml" "${GITSRC}/waybar/power_menu.xml"
substitute "$BAKORDEL" "${HOME}/.config/waybar/style.css" "${GITSRC}/waybar/style.css"
substitute "$BAKORDEL" "${HOME}/.config/hypr" "${GITSRC}/hypr"
substitute "$BAKORDEL" "${HOME}/.config/dunst/dunstrc" "${GITSRC}/dunst/dunstrc"
substitute "$BAKORDEL" "${HOME}/.config/assets" "${GITSRC}/assets"

if [ -f "${HOME}/.config/hypr.hyprlainbak/local.conf" ]; then
	cp "${HOME}/.config/hypr.hyprlainbak/local.conf" "$HYPR_LOCAL"
elif [ ! -f "$HYPR_LOCAL" ]; then
	echo "# Machine-specific Hyprland overrides, sourced last by hyprland.conf." > "$HYPR_LOCAL"
	echo "# The Hyprlain installer keeps this file across reinstalls." >> "$HYPR_LOCAL"
fi

if lsmod 2> /dev/null | grep -q '^nvidia_drm'; then
	cat > "${HOME}/.config/hypr/nvidia.conf" <<-'EOF'
	# Written by the Hyprlain installer because the NVIDIA driver is loaded.
	env = LIBVA_DRIVER_NAME,nvidia
	env = __GLX_VENDOR_LIBRARY_NAME,nvidia
	env = NVD_BACKEND,direct
	env = ELECTRON_OZONE_PLATFORM_HINT,auto
	EOF
	appendonce "$HYPR_LOCAL" "source = ~/.config/hypr/nvidia.conf"
fi

substitute "$BAKORDEL" "${HOME}/.config/neofetch/config.conf" "${GITSRC}/neofetch/config.conf"
substitute "$BAKORDEL" "${HOME}/.config/neofetch/logo" "${GITSRC}/neofetch/logo"
# fastfetch uses $1..$9 color placeholders where neofetch uses ${c1}..${c9}.
sed 's/\${c\([0-9]\)}/$\1/g' "${GITSRC}/neofetch/logo" > "${HOME}/.config/neofetch/fastfetch-logo"

substitute "$BAKORDEL" "${HOME}/.config/kitty/kitty.conf" "${GITSRC}/kitty/kitty.conf"
substitute "$BAKORDEL" "${HOME}/.config/kitty/current-theme.conf" "${GITSRC}/kitty/current-theme.conf"
substitute "$BAKORDEL" "${HOME}/.config/kitty/themes/hyprlain.conf" "${GITSRC}/kitty/themes/hyprlain.conf"
substitute "$BAKORDEL" "${HOME}/.config/kitty/themes/hyprlain.conf-colors" "${GITSRC}/kitty/themes/hyprlain-colors.conf"

if [[ "$DISTRO" == "fedora" ]]; then
	HYPR="${HOME}/.config/hypr"

	# Apps that only exist in the AUR get Fedora stand-ins, or are disabled.
	sed -i 's|^\$pickEmoji = .*|$pickEmoji = rofimoji|' "${HYPR}/programs.conf"
	sed -i 's|^exec-once = sudo systemctl start bluetooth|# &  (bluetooth.service is enabled by default on Fedora)|' "${HYPR}/programs.conf"
	command -v waycorner &> /dev/null || sed -i 's|^exec-once = waycorner|# &|' "${HYPR}/programs.conf"
	command -v zeditor &> /dev/null || sed -i 's|^\$editor = zeditor|$editor = $terminal -e nvim|' "${HYPR}/programs.conf"
	command -v woomer &> /dev/null || sed -i 's|^bind = \$MOD SHIFT, mouse_down, exec, \$zoom|# &|' "${HYPR}/keys.conf"
	sed -i 's/^\(\$POPUP_CLASS = .*\)$/\1|nm-connection-editor|blueman/' "${HYPR}/windows.conf"

	# hypr-dynamic-cursors has to be built with hyprpm; without it its settings
	# are config errors. Enable manually: hyprpm add https://github.com/VirtCode/hypr-dynamic-cursors
	if ! hyprpm list 2> /dev/null | grep -q dynamic-cursors; then
		sed -i 's|^source = plugins.conf|# &  (run: hyprpm add https://github.com/VirtCode/hypr-dynamic-cursors)|' "${HYPR}/hyprland.conf"
	fi

	sed -i 's|"on-click-right": "iwgtk"|"on-click-right": "nm-connection-editor"|' "${HOME}/.config/waybar/config.jsonc"
	sed -i 's|"on-click-right": "missioncenter"|"on-click-right": "flatpak run io.missioncenter.MissionCenter"|' "${HOME}/.config/waybar/config.jsonc"

	# rose-pine-hyprcursor is AUR-only; install the upstream release per-user.
	CURSOR_DIR="${HOME}/.local/share/icons/rose-pine-hyprcursor"
	CURSOR_URL=https://github.com/ndom91/rose-pine-hyprcursor/releases/download/v0.3.2/rose-pine-cursor-hyprcursor_0.3.2.tar.gz
	handleold "$BAKORDEL" "$CURSOR_DIR"
	mkdir -p "$CURSOR_DIR"
	curl -fsSL "$CURSOR_URL" | tar xz -C "$CURSOR_DIR" \
		|| echo -e "${RED}ERROR! Couldn't download rose-pine-hyprcursor.${NOCOLOR}"
fi

appendblock "${HOME}/.profile" hyprland "${GITSRC}/.profile"
DOTPROFILE_SHLINE="[[ -f ~/.profile ]] && . ~/.profile"
appendonce "${HOME}/.bashrc" "$DOTPROFILE_SHLINE"
appendonce "${HOME}/.zshrc" "$DOTPROFILE_SHLINE"

echo -e "${GREEN}Hyprland Hyprlain theme installed successfully.${NOCOLOR}"
