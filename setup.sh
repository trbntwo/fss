#!/usr/bin/bash

packagemanger(){
    dnfconf="/etc/dnf/dnf.conf"
    echo "changing package manager configuration"
    echo "adding:"
    echo "max_parallel_downloads=6" | sudo tee -a $dnfconf
    echo "defaultyes=True" | sudo tee -a $dnfconf
    echo "package manager configuration customized"
}

rpmfusion(){
    echo "adding rpmfusion"
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf groupupdate -y core
    echo "rpmfusion added"
}

codecs(){
    if [[ ! -f "/etc/yum.repos.d/rpmfusion-free.repo" && ! -f "/etc/yum.repos.d/rpmfusion-nonfree.repo" ]]; then
        echo "rpmfusion is not installed, rpmfusion is required for additional codecs"
        rpmfusion
    fi
    echo "adding addional multimedia codecs"
    sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
    sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
    sudo dnf groupupdate -y sound-and-video
    echo "additional multimedia codecs added"
}

packages(){
    echo "installing packages"
    sudo dnf install -y $(cat ./packages/install-packages.txt)
    echo "packages installed"
    echo "removing unwanted packages"
    sudo dnf remove -y $(cat ./packages/remove-packages.txt)
    echo "packages removed"

}

flathub(){
    echo "adding flathub"
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak update
    echo "flathub added"
    echo "installing flatpaks"
    FLATPAKS=$(cat ./packages/install-flatpaks.txt)
    for FLATPAK in $FLATPAKS; do
        flatpak install -y flathub $FLATPAK
    done
    echo "flatpaks installed"
}

devtools(){
    echo "installing dev-tools group"
    sudo dnf install -y @development-tools
    echo "group installed"
    echo "adding vscode repo"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    dnf check-update
    echo "vscode repo added, now installing"
    sudo dnf install -y code
    echo "vscode installed"
}

virtualization(){
    echo "installing virtualization group"
    sudo dnf install -y @virtualization
    echo "group installed, now doing additional configuration"
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    sudo usermod -aG libvirt $(whoami)
    echo "virtualization configured"
    echo "adding docker repo"
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    echo "docker repo added, now installing"
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "docker installed, now doing additional configuration"
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $(whoami)
    echo "docker configured"
}

nvidia(){
    if [[ ! -f "/etc/yum.repos.d/rpmfusion-nonfree.repo" ]]; then
        echo "rpmfusion is not installed. rpmfusion is required for nvidia drivers"
        rpmfusion
    fi
    sudo dnf update -y
    echo "installing nvidia proprietery drivers"
    sudo dnf install -y akmod-nvidia
    sudo dnf install -y xorg-x11-drv-nvidia-cuda
    echo "nvidia drivers installed"
}

while getopts "crmpfdvn" option; do
    case $option in
        c)  packagemanger
            ;;
        r)  rpmfusion
            ;;
        m)  codecs
            ;;
        p)  packages
            ;;
        f)  flathub
            ;;
        d)  devtools
            ;;
        v)  virtualization
            ;;
        n)  nvidia
            ;;
    esac
done

echo
echo
echo "script finished"
echo
