#!/bin/bash
# rabid-installer.sh By The Rabbithole Project

# This script must be run with root privileges.
# This script should work with any Linux distribution that uses apt, pacman, 
# xbps-install or emerge as a package manager. (Arch, Debian, Ubuntu, Gentoo, 
# Void, etc.)

# Core dependencies
CORE_DEPENDENCIES=(
  awesome
  ttf-ubuntu-font-family
  beautyline
)

# DE-Like dependencies
DE_LIKE_DEPENDENCIES=(
  volumeicon
  lxqt-policykit
  lxqt-powermanagement
  network-manager-applet
  blueman-git
  flameshot
  linux-wifi-hotspot
)

# Set the project directory
PROJECT_DIR="$(dirname "$(readlink -f "$0")")"

# Check which package manager is installed
if command -v apt >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
elif command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER="pacman"
    if command -v yay >/dev/null 2>&1; then
        PACKAGE_MANAGER="yay"
    fi
elif command -v emerge >/dev/null 2>&1; then
    PACKAGE_MANAGER="emerge"
elif command -v xbps-install >/dev/null 2>&1; then
    PACKAGE_MANAGER="xbps"
else
    echo "No recognized package manager is available on your system. Exiting."
    exit 1
fi

check_and_install() {
    if [ $PACKAGE_MANAGER == "apt" ]; then
        sudo apt install "$1" -y
    elif [ $PACKAGE_MANAGER == "pacman" ] || [ $PACKAGE_MANAGER == "yay" ]; then
        sudo $PACKAGE_MANAGER -S "$1" --noconfirm
    elif [ $PACKAGE_MANAGER == "emerge" ]; then
        sudo emerge --ask "$1"
    elif [ $PACKAGE_MANAGER == "xbps" ]; then
        sudo xbps-install -Sy "$1"
    fi
}

# Check and install dependencies
echo "Choose your installation type:"
echo "1. Core (For Advanced Users)"
echo "2. DE-Like (Recommended)"
read -p "Enter your choice (1-2): " INSTALL_TYPE

if [ "$INSTALL_TYPE" = "1" ]; then
    for pkg in "${CORE_DEPENDENCIES[@]}"; do
        check_and_install "$pkg"
    done
elif [ "$INSTALL_TYPE" = "2" ]; then
    for pkg in "${CORE_DEPENDENCIES[@]}"; do
        check_and_install "$pkg"
    done
    for pkg in "${DE_LIKE_DEPENDENCIES[@]}"; do
        check_and_install "$pkg"
    done
else
    echo "Invalid option. Exiting."
    exit 1
fi

# Rest of your script follows here...

