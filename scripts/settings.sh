#!/usr/bin/bash

date-and-time(){
    echo "Configuring top bar clock and calendar"
    gsettings set org.gnome.desktop.interface clock-show-weekday true
    gsettings set org.gnome.desktop.calendar show-weekdate true
    echo "Top bar clock and calendar configured"
}

windows(){
    echo "Configuring title bars and windows"
    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
    gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar 'toggle-maximize'
    gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'none'
    gsettings set org.gnome.desktop.wm.preferences action-right-click-titlebar 'none'
    gsettings set org.gnome.mutter center-new-windows true
    echo "Title bars and windows configured"
}

file-history(){
    echo "Configuring file history"
    gsettings set org.gnome.desktop.privacy remember-recent-files false
    gsettings set org.gnome.desktop.privacy remove-old-trash-files true
    gsettings set org.gnome.desktop.privacy remove-old-temp-files true
    gsettings set org.gnome.desktop.privacy old-files-age 7
    echo "File history configured"
}

sound(){
    echo "Disable event sounds"
    gsettings set org.gnome.desktop.sound event-sounds false
    echo "Event Sounds disabled"
}

power(){
    echo "Enabling battery percentage in top bar"
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    echo "Battery percentage now visible in top bar"
}

mouse-and-touchpad(){
    echo "Configuring mouse and touchpad"
    gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'default'
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    echo "Mouse and touchpad configured"
}

nautilus(){
    echo "Setting sort directories first"
    gsettings set org.gtk.Settings.FileChooser sort-directories-first true
    gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
    echo "Directories are now first"
}

echo "Changing settings"

date-and-time
windows
file-history
sound
power
mouse-and-touchpad
nautilus

echo "Settings changed"
