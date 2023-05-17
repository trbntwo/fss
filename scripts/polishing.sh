#!/usr/bin/bash

install-themes(){
    # adw-gtk3
    sudo dnf install -y adw-gtk3-theme
    # Firefox-GNOME-theme
    git clone https://github.com/rafaelmardojai/firefox-gnome-theme
    # MoreWaita
    git clone https://github.com/somepaulo/MoreWaita.git
    cp -r MoreWaita/ ~/.local/share/icons/
    # Capitaine-cursors
    sudo dnf install -y la-capitaine-cursor-theme
}

set-themes(){
    # GNOME-theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    # adw-gtk3
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    # Firefox-GNOME-theme
    cd firefox-gnome-theme
    git checkout v$(firefox --version | cut -d ' ' -f 3 | cut -d '.' -f 1)
    sh ./scripts/auto-install.sh
    cd ..
    # MoreWaita
    gsettings set org.gnome.desktop.interface icon-theme 'MoreWaita'
    # Capitaine-cursors
    gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursor'
}

echo "Installing and setting themes for a polished GNOME experience."

install-themes
set-themes

echo "Themes installed and set"
