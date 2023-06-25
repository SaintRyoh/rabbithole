#!/bin/bash
# rabid-installer.sh By The Rabbithole Project
# This script must be run with root privelages.
# This script should work with any Linux distribution that uses apt, pacman
# xpbs-install or emerge as a package manager. (Arch, Debian, Ubuntu, Gentoo, Void, etc.)

# Set the project directory
PROJECT_DIR="$(dirname "$(readlink -f "$0")")"

# Check which package manager is installed
if command -v apt >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
elif command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER="pacman"
elif command -v emerge >/dev/null 2>&1; then
    PACKAGE_MANAGER="emerge"
elif command -v xbps-install >/dev/null 2>&1; then
    PACKAGE_MANAGER="xbps"
else
    echo "No recognized package manager is available on your system. Exiting."
    exit 1
fi

check_and_install() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Installing $1..."
        if [ $PACKAGE_MANAGER == "apt" ]; then
            sudo apt install "$1" -y
        elif [ $PACKAGE_MANAGER == "pacman" ]; then
            sudo pacman -S "$1" --noconfirm
        elif [ $PACKAGE_MANAGER == "emerge" ]; then
            sudo emerge --ask "$1"
        elif [ $PACKAGE_MANAGER == "xbps" ]; then
            sudo xbps-install -Sy "$1"
        fi
    fi
}

# Check and install Awesome WM, Picom, Rofi, and Git
check_and_install awesome
check_and_install picom
check_and_install rofi
check_and_install git

# Clone the Rofi themes collection if it doesn't exist
if [ ! -d "$HOME/.local/share/rofi/themes" ]; then
    mkdir -p "$HOME/.local/share/rofi/themes"
    git clone https://github.com/newmanls/rofi-themes-collection.git "$HOME/.local/share/rofi/themes"
fi

if [ ! -d "/usr/share/fonts/ubuntu-font-family" ]; then
    sudo mkdir -p "/usr/share/fonts/ubuntu-font-family"
    sudo wget -O "/usr/share/fonts/ubuntu-font-family/Ubuntu.zip" https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip
    sudo unzip "/usr/share/fonts/ubuntu-font-family/Ubuntu.zip" -d "/usr/share/fonts/ubuntu-font-family"
fi

if [ ! -d "/usr/share/icons/BeautyLine" ]; then
    sudo git clone https://github.com/NOYB/icons.git /usr/share/icons/BeautyLine
    sudo gtk-update-icon-cache /usr/share/icons/BeautyLine
fi

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
