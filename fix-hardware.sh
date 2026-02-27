#!/usr/bin/env bash
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NOCOLOR="\033[0m"

echo -e "${YELLOW}Starting deep hardware & UI recovery for MacBook...${NOCOLOR}"

# 1. Unblock Broadcom Internal Wi-Fi
echo -e "${YELLOW}Unblocking internal Broadcom Wi-Fi...${NOCOLOR}"
if [ -f "/usr/lib/modprobe.d/broadcom-wl-dkms.conf" ]; then
    sudo rm -f "/usr/lib/modprobe.d/broadcom-wl-dkms.conf"
fi
sudo modprobe brcmfmac || echo "Warning: brcmfmac didn't load yet, will try after reboot."

# 2. SPI Driver Patches
SPI_SRC="/usr/src/macbook12-spi-driver-0+git.315"
if [ -d "$SPI_SRC" ]; then
    echo -e "${YELLOW}Patching SPI driver source at $SPI_SRC...${NOCOLOR}"
    sudo sed -i 's/static int appletb_platform_remove/static void appletb_platform_remove/g' "$SPI_SRC/apple-ib-tb.c"
    sudo sed -i '/static void appletb_platform_remove/,/}/ s/return 0;//' "$SPI_SRC/apple-ib-tb.c"
    sudo sed -i 's/static int appleals_platform_remove/static void appleals_platform_remove/g' "$SPI_SRC/apple-ib-als.c"
    sudo sed -i '/static void appleals_platform_remove/,/}/ s/return 0;//' "$SPI_SRC/apple-ib-als.c"
    sudo sed -i 's/static int applespi_remove/static void applespi_remove/g' "$SPI_SRC/applespi.c"
    sudo sed -i '/static void applespi_remove/,/}/ s/return 0;//' "$SPI_SRC/applespi.c"
    sudo sed -i 's/static int appleacpi_remove/static void appleacpi_remove/g' "$SPI_SRC/applespi.c"
    sudo sed -i '/static void appleacpi_remove/,/}/ s/return 0;//' "$SPI_SRC/applespi.c"
    sudo sed -i 's/static int appleib_remove/static void appleib_remove/g' "$SPI_SRC/apple-ibridge.c"
    sudo sed -i '/static void appleib_remove/,/}/ s/return 0;//' "$SPI_SRC/apple-ibridge.c"
    sudo sed -i 's/no_llseek/noop_llseek/g' "$SPI_SRC/applespi.c"
    
    echo -e "${YELLOW}Rebuilding SPI driver via DKMS (Trackpad/Keyboard)...${NOCOLOR}"
    export KCFLAGS="-Wno-error=incompatible-pointer-types"
    sudo dkms install -m macbook12-spi-driver -v 0+git.315 -k "$(uname -r)" --force
fi

# 3. Audio Driver
echo -e "${YELLOW}Rebuilding Audio driver via DKMS...${NOCOLOR}"
sudo dkms install -m snd-hda-macbookpro -v 0.1 -k "$(uname -r)" --force

# 4. Ownership Fix
echo -e "${YELLOW}Restoring user l4in ownership to home directory...${NOCOLOR}"
sudo chown -R l4in:l4in /home/l4in/.config /home/l4in/Hyprlain-

# 5. UI Fix: Apply Waybar Width Fix
echo -e "${YELLOW}Applying dynamic width fix for Waybar...${NOCOLOR}"
cp /home/l4in/Hyprlain-/src/hyprland/src/waybar/config.jsonc /home/l4in/.config/waybar/config.jsonc
killall -SIGUSR2 waybar 2>/dev/null || true

echo -e "${GREEN}All hardware & UI fixes applied successfully!${NOCOLOR}"
echo -e "${YELLOW}Please REBOOT now to finalize the driver installation.${NOCOLOR}"
