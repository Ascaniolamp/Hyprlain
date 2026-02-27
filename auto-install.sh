#!/usr/bin/env bash

# Auto-Install Script for Hyprlain
# Runs completely unattended on a fresh Arch Linux + Hyprland install.

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NOCOLOR="\033[0m"

echo -e "${GREEN}Starting unattended Hyprlain installation...${NOCOLOR}"

# Force non-interactive modes
export RUNZSH=no
export CHSH=yes
export AUTO_INSTALL=1

# Install necessary base packages
echo -e "${YELLOW}Installing base dependencies (git, base-devel)...${NOCOLOR}"
sudo pacman -S --needed --noconfirm git base-devel

# Auto-install yay if not present
if ! command -v yay &> /dev/null; then
	echo -e "${YELLOW}Installing yay...${NOCOLOR}"
	git clone --depth=1 https://aur.archlinux.org/yay.git /tmp/yay
	cd /tmp/yay
	makepkg -si --noconfirm
	cd -
	rm -rf /tmp/yay
fi

# Run the main installation script and default to backup
cd src
echo -e "${YELLOW}Running main installation script...${NOCOLOR}"
./install.sh backup "$@"

# Enable SDDM
echo -e "${YELLOW}Enabling SDDM...${NOCOLOR}"
sudo systemctl enable sddm.service || true

# Change the default shell to zsh (since Oh-My-Zsh is installed)
if command -v zsh &> /dev/null; then
    echo -e "${YELLOW}Changing default shell to zsh...${NOCOLOR}"
    sudo chsh -s $(which zsh) $USER
fi

echo -e "${GREEN}Installation complete! You can now reboot into your new Hyprland environment.${NOCOLOR}"
