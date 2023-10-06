## Tutorial
Here are instructions on how to get Rabbithole up-and-running.
**Note:** The current supported method to install Rabbithole is as a drop-in window manager replacement for a LxQt, please see the [LxQt tutorial](docs/README-lxqt-installation.md) and then proceed to [Install Rabbithole](#3-install-rabbithole). If you want to install Rabbithole as just a window manager (dynamic displays not yet full supported), then follow the [Manual Installation](#manual-installation) instructions.

**Rabbithole can be installed easily from the AUR**
`yay -S rabbithole`

Then copy your configuration to the appropriate place:
```bash
cp /usr/share/rabbithole ~/.config/awesome
```
Please let us know if you have any issues with the AUR package.We need to know if it works on others systems. You can also try the Automated installer 

### Automated Installer (Recommended)

The automated installer will not only install all of the dependencies, but it will copy all custom Rabbithole configurations (picom, rofi, etc.) to their appropriate locations. If you already have a copy of Rabbithole installed, the installer will not delete your settings.lua. So if you messed up your installation, you should `rm -rf ~/.config/awesome` before proceeding.
**Note:** Running the automated installer means you can skip the rest of the tutorial. Dive straight into selecting Rabbithole from your login screen and boot it up!

```shell 
git clone https://github.com/SaintRyoh/rabbithole && cd rabbithole && git submodule update --init
chmod +x rabid-installer.sh
./rabid-installer.sh
```
Then select Rabbithole from your display manager (login screen)!
![Rabbithole](docs/install_images/1-select-rabbithole.jpeg)
**Note:** We need beta testers for systems other than Arch-based so we can make sure the installer works. Please contact us!

### Manual Installation
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
```
ln -s rabbithole ~/.config/awesome
```
### Post Installation
After Rabbithole is now installed, we sill must configure everything.
#### 4) Configuration
Next, you will need to copy the configuration for picom and Rabbithole's settings to their appropriate places.
```picom
cp rabbithole/installer/picom.conf ~/.config/picom.conf
```
Then copy settings.lua for **core**:
```
cp rabbithole/installer/settings-core.lua ~/.config/awesome/settings.lua
```
Or the full **DE-like** installation:
```
cp rabbithole/installer/settings-full.lua ~/.config/awesome/settings.lua
```
Manually edit the settings.lua if you desire to use other software.

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
```
git clone https://github.com/Tekh-ops/Garuda-Linux-Icons.git "/usr/share/icons/BeautyLine"
```
#### 7) Update icon cache:
```
gtk-update-icon-cache -f -t /usr/share/icons/BeautyLine
```