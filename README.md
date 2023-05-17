# FSS - Fedora Setup Script

## About
FSS is a script to get Fedora Linux up and running as quickly as possible. Fedora has basically good default settings, but due to Red Hat's fear of lawsuits, additional package sources like RPM Fusion and Flathub are missing. Since Fedora 38, Flathub can be switched on in the setup screen, but with RPM Fusion this can only be done with Steam and the NVIDIA drivers. To avoid this inconsistency, this script can take over these steps. Furthermore, the script can optionally install and remove other components, as well as adjust settings.

## Quickstart
```
git clone https://github.com/trbntwo/fss.git
```
```
cd fss/
```
```
chmod u+x setup.sh
```
```
./setup.sh <options>
```

## Prerequisites
If you have just set up your system, please run an update via 
```
sudo dnf up -y
```
and reboot when it is done.
If a system has just been set up, there are often up to 1GB of updates available, these should be installed in any case, as kernel updates are also often included. These in particular are indispensable when installing the nvidia drivers, but updates are also a good idea in general.

## Options
| Parameter | Description | already implemented |
|-----------|------|---------------------|
| `-c`       | Change settings to speed up DNF, and enable yes as default option, should be first so that other operations in the script benefit from it | &check; |
| `-r`      | Enable RPM Fusion, this is a prerequisite for installing additional codecs and the NVIDIA drivers | &check; |
| `-m`      | Installs additional codecs, requires RPM Fusion, if RPM Fusion is not selected it will still be enabled to install the codecs | &check; |
| `-p`      | Installs packages specified in `./packages/install-packages.txt`, default packages are the ones I would install, to change the selection just edit the `install-packages.txt` after cloning the repository, if you don't want to install any packages just clear the list, do NOT delete it, this will also removes packages specified in `./packages/remove-packages.txt`, default selection are the one I would remove, to change this just do the same as for the packages to be installed | &check; |
| `-f`      | Enables Flathub, and installs Flatpaks specified in `./packages/install-flatpaks.txt`default Flatpaks are the ones I would install, to change the selection just edit the `install-flatpaks.txt` after cloning the repository, if you don't want to install any Flatpaks just clear the list, do NOT delete it | &check; |
| `-d`      | Installs the development-tools packages group, also sets up the VS Code repo and install VS Code | &check; |
| `-v`      | Installs the virtualization packages group, also sets up the Docker repo and installs the docker engine, also does some additional configuration, like adding `libvirtd` and `docker` to autostart and adds your user to both of these groups | &check; |
| `-n`      | Installs the proprietary NVIDIA graphics and CUDA drivers, requires RPM Fusion, if RPM Fusion is not selected it will still be enabled to install the drivers | &check; |
| `-s`      | Changes settings specified in the subscript `./scripts/settings.sh` | &cross;
| `-t`      | Installs themes to match the default Adwaita icons and libadwaita theme from GNOME for a more polished experience, this includes: [adw-gtk3](https://github.com/lassekongo83/adw-gtk3), [Firefox-GNOME-Theme](https://github.com/rafaelmardojai/firefox-gnome-theme) and [MoreWaita](https://github.com/somepaulo/MoreWaita), installs also [Capiteine Curosrs](https://github.com/keeferrourke/capitaine-cursors) for a more modern cursor, everything is specified in the subscript `./scripts/polishing.sh` | &cross; |
