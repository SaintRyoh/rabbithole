# Rabbithole Installation Tutorial
Here are instructions on how to get Rabbithole up-and-running. Only pick on of the installation methods below.

## Table of Contents
- [Cut & Dry Installation (Recommended for Every System)](#cut--dry-installation-recommended-for-every-system)
- [Arch Linux AUR Installation](#arch-linux-aur-installation)
- [Automated Installer (Recommended for Novice Users)](#automated-installer-recommended-for-novice-users)
  - [Steps](#steps)
- [Manual Installation (Advanced Users)](#manual-installation-advanced-users)

## Cut & Dry Installation (Recommended for Every System)
Make sure you have `lxqt`, `git`, and `awesome` from your package manager. Then do the following in a terminal:

```shell
git clone https://github.com/SaintRyoh/rabbithole && cd rabbithole && git submodule update --init
```

Copy or symlink Rabbithole's configuration to the `~/.config/awesome` directory:

```bash
cp -R rabbithole/* ~/.config/awesome
```
Then head follow the instructions to use Rabbithole on LxQt [here](README-lxqt-installation.md).

## Arch Linux AUR Installation
```shell
yay -S rabbithole
```

Then copy or symlink Rabbithole's configuration to the `~/.config/awesome` directory:

```bash
cp /usr/share/rabbithole ~/.config/awesome
```
Or
```bash
ln -s /usr/share/rabbithole ~/.config/awesome
```

Finally, [set up to use Rabbithole with LxQt](README-lxqt-installation.md), or select Rabbithole from your display manager (login screen)!


Let us know if you have any [issues](https://github.com/SaintRyoh/rabbithole/issues) with the AUR package.

## Automated Installer (Recommended for Novice Users)

The automated installer will install all of Rabbithole's dependencies and copy all custom Rabbithole configurations (picom, rofi, etc.) to their appropriate locations. After that, just [set up LxQt](README-lxqt-installation.md). 
**Note** If you already have a copy of Rabbithole installed, the installer will not delete your settings.lua. So if you messed up your installation, you should `rm -rf ~/.config/awesome` before proceeding.

### Steps
```shell 
git clone https://github.com/SaintRyoh/rabbithole && cd rabbithole && git submodule update --init
```
Make installer executable and run it:
```shell
chmod +x rabid-installer.sh
```
```shell
./rabid-installer.sh
```

Then [set up LxQt](README-lxqt-installation.md), or select Rabbithole from your display manager (login screen).
![Rabbithole](install_images/1-select-rabbithole.jpeg)

## Manual Installation (Advanced Users)

Below are the dependencies you need if you are going to manually install all of your systray programs and really know what you are doing when it comes to window managers. Only recommended for experienced users who want to build their environment themselves manually. You will still have to go through [post installation](#post-installation) to configure Rabbithole properly.

### Core Packages
```
lxqt
awesome
rofi
rofi-themes-collection-git
picom
autorandr
ttf-ubuntu-font-family
tmux
```
### DE-Like Experience Packages
```
lxqt
awesome
rofi
rofi-themes-collection-git
picom
autorandr
ttf-ubuntu-font-family
volumeicon
network-manager-applet
blueman
flameshot
linux-wifi-hotspot
tmux
```

If you don't want to use the installer script and prefer doing things by hand, a full DE-like install for Arch will be shown below (yay must be installed).

#### 1) Clone Repo & Initialize Submodules

```shell 
git clone https://github.com/SaintRyoh/rabbithole && cd rabbithole && git submodule update --init
```

#### 2) Install Dependencies

```
yay -S awesome rofi rofi-themes-collection-git picom autorandr ttf-ubuntu-font-family volumeicon beautyline lxqt-policykit lxqt-powermanagement network-manager-applet blueman-git flameshot linux-wifi-hotspot
```
Installing Rabbithole for other distros works as well, or you can use our [automated-installer](#automated-installer) and let us know if it works or not, so we can get it running on all major distros. The installer supports; Debian, Arch, Void, & Gentoo (as well as distros based on the aforementioned ones).

#### 3) Install Rabbitole

Simply copy or symlink the config to your Awesome WM configuration directory after initializing the submodules:

```shell
cp -R rabbithole/* ~/.config/awesome
```

Or make a symlink

```shell
ln -s rabbithole ~/.config/awesome
```

### Post Installation

After Rabbithole is now installed, we sill must configure everything.

#### 4) Configuration

Next, you will need to copy the configuration for picom and Rabbithole's settings to their appropriate places.

```shell
cp rabbithole/installer/picom.conf ~/.config/picom.conf
```

For a basic, minimal installation (for advanced users) copy settings.lua for **core**:

```shell
cp rabbithole/installer/settings-core.lua ~/.config/awesome/settings.lua
```

Or the full **DE-like** installation:

```shell
cp rabbithole/installer/settings-full.lua ~/.config/awesome/settings.lua
```

Rofi themes collection and Ubuntu Font Family installation remain the same across distributions:

#### 5) Clone the Rofi themes collection:

```bash
mkdir -p "$HOME/.local/share/rofi/themes"
git clone https://github.com/newmanls/rofi-themes-collection.git "$HOME/.local/share/rofi/themes"
```

#### 6) Install the Ubuntu Font Family Manually (not necessary on Arch or Ubuntu):

```bash
sudo mkdir -p "/usr/share/fonts/ubuntu-font-family"
sudo wget -O "/usr/share/fonts/ubuntu-font-family/Ubuntu.zip" https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip
sudo unzip "/usr/share/fonts/ubuntu-font-family/Ubuntu.zip" -d "/usr/share/fonts/ubuntu-font-family
```

#### Install BeautyLine Icon Pack
```shell
git clone https://github.com/Tekh-ops/Garuda-Linux-Icons.git "/usr/share/icons/BeautyLine"
```

#### 7) Update icon cache:
```shell
gtk-update-icon-cache -f -t /usr/share/icons/BeautyLine
```