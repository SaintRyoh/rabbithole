#!/bin/bash
# rabid-installer.sh By The Rabbithole Project

# This script is a work in progress, eventually iy aims to work with any Linux distribution that 
# uses apt, pacman, xbps-install or emerge as a package manager. (Arch, Debian, Ubuntu, 
# Gentoo, Void, etc.)

# Set the project directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

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

# Core dependencies
if [ $PACKAGE_MANAGER == "apt" ]; then
    CORE_DEPENDENCIES=(
        awesome
        rofi
        autorandr
        picom
        fonts-ubuntu
        lxqt-policykit
        lxqt-powermanagement
        )
    DE_LIKE_DEPENDENCIES=(
        volumeicon-alsa
        network-manager-gnome
        blueman
        flameshot
        )

    # Adding PPA for linux-wifi-hotspot
    sudo apt install software-properties-common -y
    sudo add-apt-repository ppa:lakinduakash/lwh
    sudo apt update
    sudo apt install linux-wifi-hotspot -y

elif [ $PACKAGE_MANAGER == "yay" ]; then
    CORE_DEPENDENCIES=(
      awesome
      rofi
      rofi-themes-collection-git
      autorandr
      picom
      ttf-ubuntu-font-family
      lxqt-policykit
      lxqt-powermanagement
      beautyline
    )
    
    # DE-Like dependencies
    DE_LIKE_DEPENDENCIES=(
      volumeicon
      network-manager-applet
      blueman
      flameshot
      linux-wifi-hotspot
    )
fi

check_and_install() {
    if [ $PACKAGE_MANAGER == "apt" ]; then
        dpkg -s "$1" >/dev/null 2>&1 || sudo apt install "$1" -y
    elif [ $PACKAGE_MANAGER == "pacman" ] || [ $PACKAGE_MANAGER == "yay" ]; then
        pacman -Q "$1" >/dev/null 2>&1 || $PACKAGE_MANAGER -S "$1"
    elif [ $PACKAGE_MANAGER == "emerge" ]; then
        emerge -pq "$1" >/dev/null 2>&1 || sudo emerge --ask "$1"
    elif [ $PACKAGE_MANAGER == "xbps" ]; then
        xbps-query -R "$1" >/dev/null 2>&1 || sudo xbps-install -Sy "$1"
    fi
}

# Check and install dependencies
echo "Choose your installation type:"
echo "1. Core (For Advanced Users)"
echo "2. DE-Like (Recommended)"
read -p "Enter your choice (1-2): " INSTALL_TYPE

# Use check_if_installed instead of check_and_install in the script
if [ "$INSTALL_TYPE" = "1" ]; then
  for pkg in "${CORE_DEPENDENCIES[@]}"; do
      echo "Checking and installing $pkg..."
      check_and_install "$pkg"
  done
elif [ "$INSTALL_TYPE" = "2" ]; then
  for pkg in "${CORE_DEPENDENCIES[@]}"; do
      echo "Checking and installing $pkg..."
      check_and_install "$pkg"
  done
  for pkg in "${DE_LIKE_DEPENDENCIES[@]}"; do
      echo "Checking and installing $pkg..."
      check_and_install "$pkg"
  done
fi

if [ ! -d "$HOME/.config/awesome" ]; then
    mkdir -p "$HOME/.config/awesome"
fi

if [ ! -d "$HOME/.config/picom" ]; then
    mkdir -p "$HOME/.config/picom"
fi

# Check the user's installation choice and copy the corresponding settings file.
# But check first if the user has an existing configuration.
if [ "$INSTALL_TYPE" = "1" ]; then
    if [ ! -f "$HOME/.config/awesome/settings.lua" ]; then
        mkdir -p "$HOME/.config/awesome"
        cp "$PROJECT_DIR/installer/settings-core.lua" "$HOME/.config/awesome/settings.lua"
    else
        echo "An existing configuration file has been found at ~/.config/awesome/settings.lua. The file was not overwritten."
    fi
elif [ "$INSTALL_TYPE" = "2" ]; then
    if [ ! -f "$HOME/.config/awesome/settings.lua" ]; then
        cp "$PROJECT_DIR/installer/settings-full.lua" "$HOME/.config/awesome/settings.lua"
    else
        echo "An existing configuration file has been found at ~/.config/awesome/settings.lua. The file was not overwritten."
    fi
fi

# If the package manager is not 'yay', download the rofi themes and ubuntu fonts
if [ $PACKAGE_MANAGER != "yay" ]; then
    # Clone the Rofi themes collection if it doesn't exist
    if [ ! -d "$HOME/.local/share/rofi/themes" ]; then
        echo "Downloading Rofi themes collection..."
        mkdir -p "$HOME/.local/share/rofi/themes"
        git clone https://github.com/newmanls/rofi-themes-collection.git "$HOME/.local/share/rofi/themes"
    fi

    # Download and extract Ubuntu Font Family if it doesn't exist
    if [ ! -d "/usr/share/fonts/ubuntu-font-family" ]; then
        echo "Downloading Ubuntu Font Family..."
        sudo mkdir -p "/usr/share/fonts/ubuntu-font-family"
        sudo wget -O "/usr/share/fonts/ubuntu-font-family/Ubuntu.zip" https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip
        sudo unzip "/usr/share/fonts/ubuntu-font-family/Ubuntu.zip" -d "/usr/share/fonts/ubuntu-font-family"
    fi
    
    # Install BeautyLine icons if they don't exist
    if [ ! -d "/usr/share/icons/BeautyLine" ]; then
        echo "Copying BeautyLine icons and updating font cache..."
        sudo cp -R $PROJECT_DIR/installer/BeautyLine /usr/share/icons/BeautyLine
        sudo gtk-update-icon-cache /usr/share/icons/BeautyLine
    fi
fi

# Copy rabbithole.desktop to /usr/share/xsessions/
echo "Copying rabbithole.desktop to /usr/share/xsessions/..."
sudo cp "$PROJECT_DIR/installer/rabbithole.desktop" /usr/share/xsessions/
echo "Rabbithole should now be visible in your display manager."

# Set the default rofi theme
#echo "Setting the default rofi theme..."
#echo "rofi.theme: $HOME/.local/share/rofi/themes/themes/rounded-nord-dark.rasi" >> "$HOME/.Xresources"
#xrdb -merge "$HOME/.Xresources"

# Copy picom.conf into $HOME/.config/picom/
echo "Copying picom.conf to $HOME/.config/picom/..."
cp "$PROJECT_DIR/installer/picom.conf" "$HOME/.config/picom/picom.conf"

# Copy the configuratioin files to $HOME/.config/awesome/
echo "Copying Rabbithole's configuration files to $HOME/.config/awesome/..."
cp -R "$PROJECT_DIR/"* "$HOME/.config/awesome"

echo "Done! You can now log out and log back in with Rabbithole."
echo "Don't forget to set your rofi theme with the rofi theme seledtor when you log in!"