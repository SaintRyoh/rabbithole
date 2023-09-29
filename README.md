# Rabbithole—The Meta-Window Manager
### LOOKING FOR BETA TESTERS
~**Automated Installer Working for Arch Linux~ Now available in the AUR - Please Help Us Test On Other Distros**
We need people to test the installation procedure and give us feedback before we start major promotion. Earn your spot as a [contributor](docs/CONTRIBUTORS.md) to Rabbithole!
- Rabbithole has been tested and works on Ubuntu if you install the packages manually! 
### Discord Support
Join  our group on [Rabbithole's Discord](https://discord.com/channels/1122348043950366823/1122348044382392432) for **live support** and to talk to the developers! We're happy to help with anything you need, we are looking for feature requests, feedback, or even helo with customizing your installation! We also love to talk about philosophy, AI, and the future of computing. Come join us!


### **Basic Usage Tutorial:** The Windows key on your keyboard has magical powers.
i3 users will notice the keybindings are very familiar.

- **Hit ```Win + s``` to see Rabbithole's help and keybindings page.**
- ```Win + d``` will open the program launcher.
- ```Win + Tab``` will open your window/task switcher.
- ```Win + f``` will fullscreen your workspace switcher.
- ```Win + q``` will kill the focused app.
#### **Mouse**
- Left click and hold on client icons in the tasklist to drag and drop clients from one tag to another
- Right-click tasks to move them between local or global tags and workspaces.
- Middle click tasks/clients to kill them
- Ctrl + Left-click to view multiple tags (virtual desktops) on a single screen
- Win + Right-click on tags to delete, renamme, or move to a different workspace
### Latest features
- Drag and drop clients between tags (still work in progress, but it works and is useful)
- Removed workspace label (we think it's obvious which activity you are working on by the tag—The other menu took up too much room too)

### Latest Features (Based on User Feedback)
- [x] Install tested & working on Arch, Ubuntu, & Kali (also expected to work on distros based on these) (PopOS!))
- [x] Rabbithole is now available in the AUR with `yay -S rabbithole`
- [x] (In Progress) YouTube tutorial video (install, usage, etc.)

### Upcoming Features
- [x] Toggleable menubars with options to hide/show on mouse movement
- [x] Menu bars that can be dragged and snapped to corners of the screen without messing with settings
- [x] Easier settings management (settings manager app)
- [x] More customizable settings.lua (size/location of widget bars)
- [x] Minor Bugfixes
- [x] Performance improvements

## _Enter the Rabbithole._
_Video demonstration when you click on the image below._
[![Watch the video demo!](docs/install_images/Rabbithole_Screenshot.png)](https://youtu.be/ci8KCli6YFQ)

## Table of Contents
- [About](#about)
- [What is a Meta-Window Manager?](#what-is-a-meta-window-manager)
- [Features](#features)
- [Ideal For](#ideal-for)
- [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Dependencies](#core-packages-only-advanced-users)
    - [Tutorial](#tutorial)
    - [Automated Installer](#automated-installer-recommended)
    - [Manual Installation](#manual-installation)
- [Post Installation](#post-installation)
- [Configuring Rabbithole](#configuring-rabbithole)
- [Contributing](#contributing)
- [The Vision of Rabbithole (Planned Features)](#the-vision-of-rabbithole-planned-features)

## About Rabbithole
A _revolutionary_ window manager that takes productivity to a _**whole new dimension**_ (quite literally). Rabbithole is not just another window manager—it is a dynamic, fluid, and interactive environment that challenges conventional paradigms of window management. It breathes life into your workspace and transforms the way you interact with your computer.

Built on the robust **Awesome WM framework**, Rabbithole embraces the philosophy of dynamic workspaces. It allows you to nest virtual workspaces and add or remove displays on-the-fly. With Rabbithole, you don't adjust to your workspace, your workspace adjusts to _you_.

## What is a Meta-Window Manager?

Rabbithole is the _first **meta-window manager**_ because it goes beyond traditional window management—it is a _philosophy_ on how we believe windows should be managed. Rabbithole is not just about managing windows; it's about _redefining_ how they can be used to enhance your **workflow**.

## Features

- **Dynamic Display Management**: Disconnect and reconnect screens _on-the-fly_, without interrupting your flow. **Switch workspaces** from your _multi-monitor_ setup to a _single monitor_ setup seamlessly. Click the image link below to see a short YouTube demonstration.
[![Watch the video demo!](docs/install_images/Rabbithole_multi-monitor.png)](https://youtu.be/pRu7rNrFJXI?si=kSLEeJKNB4FuoH2Y)
    
- **Aesthetically Pleasing Experience**: A polished experience that feels more like a Desktop Environment (DE) than a Window Manager (WM). We believe **aesthetics matter**, even outside full desktop environments.
    
- **Streamlined Navigation**: Choose between fully **keyboard-driven** or **mouse-driven** navigation. Switching between applications, workspaces, and displays is a breeze with our **intuitive** controls.
    
- **Personalization**: With Rabbithole's own **Tesseract Theme Engine**, add a _primary color_, select a _color theory_, and generate your unique and beautiful themes, adhering to **Material Design 3** standards and color theory rules.
    
- **Workspaces**: Different workspaces or _"Activities"_ for different projects. Think of this as a second dimension on top of "tags", or virtual desktops. Separate your workspaces, projects, and flows into different virtual spaces while maintaining global access to applications you need across all workspaces—Email, Discord, Signal, always accessible.
    
- **Centralized Settings**: A neat and centralized settings file that controls everything from theme, to keybindings, to default programs.
    
- **Quick Program Launch**: Pre-configured **rofi** lets you launch programs or switch windows/workspaces at lightning speed with its fuzzy search algorithm.

## Ideal For

Rabbithole is ideal for users who:

- Appreciate the power of window managers but don't want to deal with the hassle of customizing from scratch.
    
- Seek an aesthetically pleasing workspace, but are tired of the rigid, or dated appearance of traditional window managers.
    
- Want their computer interface to be more than a tool—an extension of their minds, a second brain.
    
- Frequently switch between different monitor setups and need a workspace that can adjust on-the-fly.
    
- Desire a streamlined, intuitive workspace that boosts productivity without sacrificing user experience.

## Installation

**Rabbithole is now available in the AUR** with `yay -S rabbithole`

### Prerequisites

Rabbithole is designed for use on Linux operating systems. To use Rabbithole, you should:

- Have a working Linux installation. Rabbithole has been [tested](#looking-for-beta-testers) and is known to work on: Arch, Garuda, Ubuntu, Kali.
- Be comfortable using the command line, as some aspects of the installation process may require it.
- Have **git** installed to clone the Rabbithole repository. If you don't have git installed, you can install it with your distribution's package manager. For example, on Ubuntu, you can install git with the following command: ```sudo apt install git```
- For the DE-Like experience, yay or another AUR tool should be installed on Arch based distros for the easiest installation.

### Core Packages Only (Advanced Users)

These are the dependencies you need if you are going to manually install all of your systray programs and really know what you are doing when it comes to window managers. Only recommended for experienced users who want to build their environment themselves. You will still have to go through [post installation](#post-installation) to configure Rabbithole properly.
```
awesome
rofi
rofi-themes-collection-git
picom
autorandr
ttf-ubuntu-font-family
beautyline
```
### DE-Like Experience Packages (Recommended)
```
awesome
rofi
rofi-themes-collection-git
picom
autorandr
ttf-ubuntu-font-family
beautyline
volumeicon
lxqt-policykit
lxqt-powermanagement
network-manager-applet
blueman-git
flameshot
linux-wifi-hotspot
```

## Tutorial
Here are instructions on how to get Rabbithole up-and-running.
**Note:** If you wish to use Rabbithole as a drop-in window manager replacement for a Desktop Environment, please see the [LxQt tutorial](docs/README-lxqt-installation.md) and then proceed to [Install Rabbithole](#3-install-rabbithole)

### Automated Installer (Recommended)

The automated installer will not only install all of the dependencies, but it will copy all custom Rabbithole configurations (picom, rofi, etc.) to their appropriate locations. If you already have a copy of Rabbithole installed, the installer will not delete your settings.lua. So if you messed up your installation, you should _rm -rf ~/.config/awesome_ before proceeding.
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
Repeat the same [post installation steps](#post-installation) in the automated installation procedure.
## Configuring Rabbithole
Rabbithole's configuration file is located in ```~/.config/awesome/settings.lua```. When you want to change anything about Rabbithole, this is the place you go. You should never have to modify Rabbithole's source code. As new features are added, they will have their options added to settings.lua.
Here you can add startup programs and daemons to the list under the appropraite tables. (Tutorials coming soon)
### Contributing

We are looking for contributors to join the team. Right now we have accomplished a lot between two extremely tight-knit engineers, with the same vision, and complimentary programming (with 15 years of pair-programming experience). We are looking for others who fit (or can be molded)!

What is our vision, you ask?

### The Vision of Rabbithole (Planned Features)

Rabbithole is more than just software—it's a journey into the future of digital spaces, and we have the roadmap charted out. It's a long one.

With our current version to 1.x, we have crafted a promising open beta and v1 as our proof-of-concept, which is our first step into this grand adventure. Our intention is not only to showcase the potential of Rabbithole, but also to invite the community into the development process. We are eager to know your thoughts, ideas, and feedback as we strive to fill a distinct, yet unexplored niche that caters to users like us.

As we finish up the remainder of unfinished features for v1 (and the bugs that undoubtedly come with it), we plan to immediately progress to version 2.x. We have already identified a host of enhancements and features we want to incorporate. We love Awesome WM, but its incompatibility with Wayland and the bugs laden within picom have motivated us to push the boundaries, because we have pushed AWM near its limitations. Even though X isn't disappearing anytime soon, we are setting our sights towards the future of Virtual Reality (VR) and Augmented Reality (AR) interfaces. We have a few options in front of us. But this will likely require programming an entirely new framework from the ground up, or continuing where others have left off. We are open to ideas.

Our grand vision is to morph Rabbithole into an AI-powered virtual interface that offers full compatibility with all of your devices. Be it your mobile, PC, or VR/AR headsets, we aim to provide a seamless, unified, and immersive experience across all platforms.

#### About the "Building A Second Brain" and "Getting Things Done" concepts that fit into Rabbithole's philosophy:

_"Building a Second Brain"_ and _"Getting Things Done"_ (GTD) are two significant productivity philosophies that Rabbithole integrates at its core.

"Building a Second Brain" is a methodology for saving and systematically reminding us of the ideas, inspirites, and random useful bits we've come across, to free our minds from the job of remembering. This approach aligns perfectly with Rabbithole, which aims to create an adaptive workspace that adjusts to the user's needs—acting as a _'second brain'_ that understands and adapts to the user's workflows.

On the other hand, "Getting Things Done" is a time-management method, which encourages recording tasks externally and breaking them down into actionable work items. This allows users to focus on performing tasks instead of remembering them. Rabbithole's fluid window management complements this by making sure that your digital workspace is always optimized for the task at hand, which in turn aids in the GTD methodology.

Rabbithole believes that a window manager is not just a tool to manage applications but a critical element of your productivity toolbox. It can significantly affect how efficiently you work and how quickly you can switch between tasks. In essence, a good window manager helps you build your second brain and aids in getting things done.

We see Rabbithole as the ultimate bridge that connects the islands of mobile and desktop computing, culminating in a singular, coherent user experience. Join us in our journey to make this vision a reality.
