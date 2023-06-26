#!/bin/bash
# rabid-installer.sh By The Rabbithole Project

# This script must be run with root privileges.
# This script should work with any Linux distribution that uses apt, pacman, xbps-install or emerge as a package manager. (Arch, Debian, Ubuntu, Gentoo, Void, etc.)

# Core dependencies
CORE_DEPENDENCIES=(
  awesome
  rofi
  rofi-themes-collection-git
  picom
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

# If the package manager is not 'yay', download the rofi themes and ubuntu fonts
if [ $PACKAGE_MANAGER != "yay" ]; then
    # Clone the Rofi themes collection if it doesn't exist
    if [ ! -d "$HOME/.local/share/rofi/themes" ]; then
        mkdir -p "$HOME/.local/share/rofi/themes"
        git clone https://github.com/newmanls/rofi-themes-collection.git "$HOME/.local/share/rofi/themes"
    fi

    # Download and extract Ubuntu Font Family if it doesn't exist
    if [ ! -d "/usr/share/fonts/ubuntu-font-family" ]; then
        sudo mkdir -p "/usr/share/fonts/ubuntu-font-family"
        sudo wget -O "/usr/share/fonts/ubuntu-font-family/Ubuntu.zip" https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip
        sudo unzip "/usr/share/fonts/ubuntu-font-family/Ubuntu.zip" -d "/usr/share/fonts/ubuntu-font-family"
    fi
    
    # Install BeautyLine icons if they don't exist
    if [ ! -d "/usr/share/icons/BeautyLine" ]; then
        sudo git clone https://github.com/NOYB/icons.git /usr/share/icons/BeautyLine
        sudo gtk-update-icon-cache /usr/share/icons/BeautyLine
    fi
fi

# Check and install Awesome WM, Picom, Rofi, and Git
check_and_install awesome
check_and_install picom
check_and_install rofi
check_and_install git

if [ ! -d "$HOME/.config/awesome" ]; then
    mkdir -p "$HOME/.config/awesome"
fi
cp -R "$PROJECT_DIR/rabbithole/configs/." "$HOME/.config/awesome/"

if [ ! -d "$HOME/.config/picom" ]; then
    mkdir -p "$HOME/.config/picom"
fi
cp "$PROJECT_DIR/picom.conf" "$HOME/.config/picom/picom.conf"

# Install autorandr to /usr/bin/
sudo cp "$PROJECT_DIR/installer/autorandr" /usr/bin/

# Copy rabbithole.desktop to /usr/share/xsessions/
sudo cp "$PROJECT_DIR/installer/rabbithole.desktop" /usr/share/xsessions/

# Set the default rofi theme
echo "rofi.theme: $HOME/.local/share/rofi/themes/themes/rounded-nord-dark.rasi" >> "$HOME/.Xresources"
xrdb -merge "$HOME/.Xresources"
# Copy rabbithole's configuration into $HOME/.config/awesome
cp -R "$PROJECT_DIR" "$HOME/.config/awesome"
