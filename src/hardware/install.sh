#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

PRODUCT_NAME=$(cat /sys/class/dmi/id/product_name 2>/dev/null)
echo -e "${YELLOW}Hardware detected: ${PRODUCT_NAME}${NOCOLOR}"

IS_MAC=0
if [[ "$PRODUCT_NAME" == MacBookPro13,* ]] || [[ "$PRODUCT_NAME" == MacBookPro14,* ]] || [ "$FORCE_MAC" == "1" ]; then
    IS_MAC=1
fi

if [ "$IS_MAC" -eq 0 ]; then
    echo -e "${YELLOW}No MacBook Pro 2016/2017 detected.${NOCOLOR}"
    # In unattended mode, we'll assume NO unless FORCE_MAC is 1 to avoid accidental driver installs on the wrong PC.
    # However, for this specific USER, they WANT it forced.
    if confirmNy "Are you preparing a portable USB for use on a MacBook?"; then
        echo -e "${GREEN}Preparing Universal/Portable MacBook fixes...${NOCOLOR}"
        IS_MAC=1
    fi
fi

if [ "$IS_MAC" -eq 1 ]; then
    echo -e "${GREEN}Applying MacBook Pro hardware fixes...${NOCOLOR}"

    # 0. Ensure Kernel Headers are installed for DKMS
    echo -e "${YELLOW}Ensuring kernel headers are installed...${NOCOLOR}"
    KERNEL_VER=$(uname -r)
    if [[ "$KERNEL_VER" == *-lts ]]; then
        getpkg linux-lts-headers
    else
        getpkg linux-headers
    fi

    # 1. Wifi Fix: Module Blacklisting & Firmware
    echo -e "${YELLOW}Configuring Wifi modules (Broadcom)...${NOCOLOR}"
    
    # Use MikeRatcliffe's Gist for the 13,2 firmware configuration
    if [ ! -f "/lib/firmware/brcm/brcmfmac43602-pcie.txt" ]; then
        echo -e "${YELLOW}Downloading Broadcom firmware configuration...${NOCOLOR}"
        sudo mkdir -p /lib/firmware/brcm
        # This gist contains the exact .txt for MBP 13,2
        sudo curl -L https://gist.githubusercontent.com/MikeRatcliffe/7a06a096c4d81230e70a3597d512f451/raw/brcmfmac43602-pcie.txt -o /lib/firmware/brcm/brcmfmac43602-pcie.txt
    fi
    
    WIFI_CONF="/etc/modprobe.d/hyprlain-mac-wifi.conf"
    sudo bash -c "cat > $WIFI_CONF <<EOF
# Blacklist conflicting modules for MacBook Broadcom chips
blacklist wl
blacklist b43
blacklist bcma
blacklist brcmsmac
# Prefer brcmfmac and disable power management for stability
options brcmfmac roamoff=1
EOF"
    echo -e "${GREEN}Wifi configuration and firmware applied.${NOCOLOR}"

    # 2. Input Fix: MacBook SPI Driver
    echo -e "${YELLOW}Installing MacBook SPI driver...${NOCOLOR}"
    getpkg "macbook12-spi-driver-dkms"
    
    # Patch the source in /usr/src for kernel 6.x compatibility
    SPI_SRC_DIR=$(ls -d /usr/src/macbook12-spi-driver-* 2>/dev/null | tail -n 1)
    if [ -n "$SPI_SRC_DIR" ]; then
        echo -e "${YELLOW}Patching SPI driver source in $SPI_SRC_DIR...${NOCOLOR}"
        # Fix unaligned.h move
        sudo sed -i 's#asm/unaligned.h#linux/unaligned.h#g' "$SPI_SRC_DIR/applespi.c"
        # Fix acpi_driver owner removal
        sudo sed -i 's/\.owner[[:space:]]*=[[:space:]]*THIS_MODULE,//g' "$SPI_SRC_DIR/apple-ibridge.c"
        # Fix report_fixup const return type
        sudo sed -i 's/static __u8 \*appleib_report_fixup/static const __u8 \*appleib_report_fixup/g' "$SPI_SRC_DIR/apple-ibridge.c"
    fi

    export KCFLAGS="-Wno-error=incompatible-pointer-types"
    # Ensure it builds for the current kernel
    sudo dkms install -m macbook12-spi-driver -v 0+git.315 -k "$(uname -r)" --force || true

    # 3. Audio Fix: Cirrus Logic Driver & Model Override
    echo -e "${YELLOW}Installing Cirrus Logic Audio driver...${NOCOLOR}"
    # Using the -git version as it's more up-to-date in AUR
    getpkg "snd-hda-macbookpro-dkms-git" 
    # Force rebuild for 6.x kernels
    sudo dkms install -m snd-hda-macbookpro -v 0.1 -k "$(uname -r)" --force || true

    echo -e "${YELLOW}Applying Audio model overrides...${NOCOLOR}"
    AUDIO_CONF="/etc/modprobe.d/hyprlain-mac-audio.conf"
    sudo bash -c "cat > $AUDIO_CONF <<EOF
# Force apple-generic model for CS8409 codec (MBP 13,2/13,3)
options snd-hda-intel model=apple-generic
EOF"

    echo -e "${GREEN}MacBook hardware fixes applied successfully!${NOCOLOR}"
else
    echo -e "${YELLOW}No specific MacBook Pro 2016/2017 hardware fixes required for this model.${NOCOLOR}"
fi
