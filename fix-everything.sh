#!/usr/bin/env bash
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NOCOLOR="\033[0m"

echo -e "${YELLOW}Starting deep hardware & UI recovery for MacBook...${NOCOLOR}"

# 1. Broadcom Wi-Fi Firmware & Unblock
echo -e "${YELLOW}Deploying Broadcom firmware & unblocking Wi-Fi...${NOCOLOR}"
if [ -f "/usr/lib/modprobe.d/broadcom-wl-dkms.conf" ]; then
    sudo rm -f "/usr/lib/modprobe.d/broadcom-wl-dkms.conf"
fi

# Ensure clm_blob is present with machine-specific names
# (Acquired previously and stored in /lib/firmware/brcm/)
sudo cp /lib/firmware/brcm/brcmfmac43602-pcie.bin.zst /lib/firmware/brcm/brcmfmac43602-pcie.Apple\ Inc.-MacBookPro13,2.bin.zst 2>/dev/null
sudo cp /lib/firmware/brcm/brcmfmac43602-pcie.clm_blob /lib/firmware/brcm/brcmfmac43602-pcie.Apple\ Inc.-MacBookPro13,2.clm_blob 2>/dev/null

# 2. SPI Driver Patches (Keyboard/Trackpad)
SPI_SRC="/usr/src/macbook12-spi-driver-0+git.315"
if [ -d "$SPI_SRC" ]; then
    echo -e "${YELLOW}Patching SPI driver source for kernel 6.x...${NOCOLOR}"
    # Signatures
    sudo sed -i 's/static int appletb_platform_remove/static void appletb_platform_remove/g' "$SPI_SRC/apple-ib-tb.c"
    sudo sed -i 's/static int appleals_platform_remove/static void appleals_platform_remove/g' "$SPI_SRC/apple-ib-als.c"
    sudo sed -i 's/static int applespi_remove/static void applespi_remove/g' "$SPI_SRC/applespi.c"
    sudo sed -i 's/static int appleacpi_remove/static void appleacpi_remove/g' "$SPI_SRC/applespi.c"
    sudo sed -i 's/static int appleib_remove/static void appleib_remove/g' "$SPI_SRC/apple-ibridge.c"
    # Returns (remove 'return 0;' and 'return rc;')
    sudo sed -i '/static void appletb_platform_remove/,/}/ s/return .*;//' "$SPI_SRC/apple-ib-tb.c"
    sudo sed -i '/static void appleals_platform_remove/,/}/ s/return .*;//' "$SPI_SRC/apple-ib-als.c"
    sudo sed -i '/static void applespi_remove/,/}/ s/return .*;//' "$SPI_SRC/applespi.c"
    sudo sed -i '/static void appleacpi_remove/,/}/ s/return .*;//' "$SPI_SRC/applespi.c"
    sudo sed -i '/static void appleib_remove/,/}/ s/return .*;//' "$SPI_SRC/apple-ibridge.c"
    # no_llseek
    sudo sed -i 's/no_llseek/noop_llseek/g' "$SPI_SRC/applespi.c"
    
    echo -e "${YELLOW}Rebuilding SPI driver via DKMS...${NOCOLOR}"
    export KCFLAGS="-Wno-error=incompatible-pointer-types"
    sudo dkms install -m macbook12-spi-driver -v 0+git.315 -k "$(uname -r)" --force
fi

# 3. Audio Driver & Config
echo -e "${YELLOW}Rebuilding Audio driver & consolidating config...${NOCOLOR}"
sudo rm -f /etc/modprobe.d/hyprlain-mac-audio.conf
sudo dkms install -m snd-hda-macbookpro -v 0.1 -k "$(uname -r)" --force
sudo bash -c "cat > /etc/modprobe.d/apple-audio.conf <<EOF
# Force macbook-pro-v1 model for CS8409 codec (MBP 13,2/13,3)
options snd-hda-intel model=macbook-pro-v1
EOF"

# 4. UI Fix: Waybar
echo -e "${YELLOW}Applying dynamic width fix for Waybar...${NOCOLOR}"
cp /home/l4in/Hyprlain-/src/hyprland/src/waybar/config.jsonc /home/l4in/.config/waybar/config.jsonc

# 5. Ownership
sudo chown -R l4in:l4in /home/l4in/.config /home/l4in/Hyprlain-

echo -e "${GREEN}All deep hardware & UI fixes applied! Please REBOOT now.${NOCOLOR}"
