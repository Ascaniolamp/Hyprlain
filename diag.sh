#!/usr/bin/env bash
OUT="/home/l4in/Hyprlain-/diag-output.txt"
echo "--- SYSTEM INFO ---" > "$OUT"
uname -a >> "$OUT"
dkms status >> "$OUT"
ip link >> "$OUT"

echo -e "\n--- DMESG (RELEVANT) ---" >> "$OUT"
sudo dmesg | grep -iE "brcm|apple|snd_hda|spi|firmware|cs8409" | tail -n 100 >> "$OUT"

echo -e "\n--- SPI BUILD ATTEMPT ---" >> "$OUT"
sudo dkms install -m macbook12-spi-driver -v 0+git.315 -k "$(uname -r)" --force >> "$OUT" 2>&1

echo -e "\n--- AUDIO BUILD ATTEMPT ---" >> "$OUT"
sudo dkms install -m snd-hda-macbookpro -v 0.1 -k "$(uname -r)" --force >> "$OUT" 2>&1

echo -e "\n--- MODPROBE CONFIGS ---" >> "$OUT"
grep -r "" /etc/modprobe.d/ >> "$OUT"

echo -e "\n--- FIRMWARE ---" >> "$OUT"
ls -l /lib/firmware/brcm/brcmfmac43602-pcie* >> "$OUT"

echo -e "\n--- ALSA ---" >> "$OUT"
cat /proc/asound/cards >> "$OUT"
