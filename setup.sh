#!/usr/bin/bash

packagemanger(){
    dnfconf="/etc/dnf/dnf.conf"
    echo "Changing package manager configuration"
    echo "adding:"
    echo "max_parallel_downloads=6" | sudo tee -a $dnfconf
    echo "defaultyes=True" | sudo tee -a $dnfconf
    echo "Package manager configuration customized"
}

rpmfusion(){
    echo "Adding RPM Fusion"
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf groupupdate -y core
    echo "RPM Fusion added"
}

codecs(){
    if [[ ! -f "/etc/yum.repos.d/rpmfusion-free.repo" && ! -f "/etc/yum.repos.d/rpmfusion-nonfree.repo" ]]; then
        echo "RPM Fusion is not installed, RPM Fusion is required for additional codecs"
        rpmfusion
    fi
    echo "Adding addional multimedia codecs"
    sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
    sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
    sudo dnf groupupdate -y sound-and-video
    echo "Additional multimedia codecs added"
}

packages(){
    echo "Installing packages"
    sudo dnf install -y $(cat ./packages/install-packages.txt)
    echo "Packages installed"
    echo "Removing unwanted packages"
    sudo dnf remove -y $(cat ./packages/remove-packages.txt)
    echo "Packages removed"

}

flathub(){
    echo "Adding Flathub"
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak update
    echo "Flathub added"
    echo "Installing Flatpaks"
    FLATPAKS=$(cat ./packages/install-flatpaks.txt)
    for FLATPAK in $FLATPAKS; do
        flatpak install -y flathub $FLATPAK
    done
    echo "Flatpaks installed"
}

devtools(){
    echo "Installing dev-tools group"
    sudo dnf install -y @development-tools
    echo "Group installed"
    echo "Adding vscode repo"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    dnf check-update
    echo "VS Code repo added, now installing"
    sudo dnf install -y code
    echo "VS Code installed"
}

virtualization(){
    echo "Installing virtualization group"
    sudo dnf install -y @virtualization
    echo "Group installed, now doing additional configuration"
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    sudo usermod -aG libvirt $(whoami)
    echo "Virtualization configured"
    echo "Adding docker repo"
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    echo "Docker repo added, now installing"
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "Docker installed, now doing additional configuration"
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $(whoami)
    echo "Docker configured"
}

nvidia(){
    if [[ ! -f "/etc/yum.repos.d/rpmfusion-nonfree.repo" ]]; then
        echo "RPM Fusion is not installed. RPM Fusion is required for NVIDIA drivers"
        rpmfusion
    fi
    sudo dnf update -y
    echo "Installing NVIDIA proprietery drivers"
    sudo dnf install -y akmod-nvidia
    sudo dnf install -y xorg-x11-drv-nvidia-cuda
    echo "NVIDIA drivers installed"
}

while getopts "crmpfdvnst" option; do
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
        s)  source ./scripts/settings.sh
            ;;
        t)  source ./scripts/polishing.sh
    esac
done

echo
echo
echo "--------------------------------------------------------------------------------------------------"
echo
echo '   _____  _____ _____  _____ _____ _______   ______ _____ _   _ _____  _____ _    _ ______ _____  '
echo '  / ____|/ ____|  __ \|_   _|  __ \__   __| |  ____|_   _| \ | |_   _|/ ____| |  | |  ____|  __ \ '
echo ' | (___ | |    | |__) | | | | |__) | | |    | |__    | | |  \| | | | | (___ | |__| | |__  | |  | |'
echo '  \___ \| |    |  _  /  | | |  ___/  | |    |  __|   | | | . ` | | |  \___ \|  __  |  __| | |  | |'
echo '  ____) | |____| | \ \ _| |_| |      | |    | |     _| |_| |\  |_| |_ ____) | |  | | |____| |__| |'
echo ' |_____/ \_____|_|  \_\_____|_|      |_|    |_|    |_____|_| \_|_____|_____/|_|  |_|______|_____/ '
echo
echo "--------------------------------------------------------------------------------------------------"
echo
echo
