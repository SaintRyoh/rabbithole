# Maintainer: LycanDarko lycandarko@proton.me

pkgname=rabbithole-git
pkgver=0.8.0
pkgrel=1
pkgdesc="Rabbithole—The Meta-Window Manager. Built from the awesome window manager framework."
arch=('x86_64')
url="https://github.com/SaintRyoh/rabbithole"
license=('GPL')
depends=('awesome' 'rofi' 'autorandr' 'picom' 'ttf-ubuntu-font-family' 'lxqt-policykit' 'lxqt-powermanagement' 'tmux' 'volumeicon' 'network-manager-applet' 'blueman' 'flameshot' 'rofi-themes-collection-git' 'beautyline' 'linux-wifi-hotspot')
source=("$pkgname::git+https://github.com/SaintRyoh/rabbithole.git")
sha256sums=('SKIP')

package() {
    # Copy rabbithole configuration files to the appropriate directory
    install -Dm644 "$srcdir/$pkgname/installer/rabbithole.desktop" "$pkgdir/usr/share/xsessions/rabbithole.desktop"
    install -Dm644 "$srcdir/$pkgname/installer/picom.conf" "$pkgdir/etc/xdg/picom.conf"
    cp -r "$srcdir/$pkgname"/* "$pkgdir/usr/share/rabbithole"
}

post_install() {
    echo "Rabbithole installation complete. To use, select 'Rabbithole' when you log in from your display manager."
    echo "Don't forget to set your rofi theme with rofi-theme-selector after copying required files to your configuration directories!"
    echo "Rabbitholes default configuration files are stored in /usr/share/rabbithole. You need to copy or link them to you $HOME/.config/rabbithole directory. To do this, run the following command:"
    echo "mkdir $HOME/.config/rabbithole && cp -r /usr/share/rabbithole/* $HOME/.config/rabbithole"
}
