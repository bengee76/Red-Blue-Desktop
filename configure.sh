#! /usr/bin/bash

doNames() {
    cd "$1" || exit

    count=0
    for file in *; do
        newName="wp$count"
        if [ "$file" != "$newName" ]; then
            mv "$file" "$newName"
        fi
        ((count++))
    done

    cd ".."
    ((count--))
    sed -i "${2}s/.*/${count}/" "$current"
}

doColors() {
    palette="['#171421', '#c01c28', '#c01c28', '#a2734c', '#12488b', '#a347ba', '#2aa1b3', '#d0cfcc', '#5e5c64', '#f66151', '#33d17a', '#e9ad0c', '#2a7bde', '#c061cb', '#33c7de', '#ffffff']"

    profileUUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")

    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileUUID/" use-theme-colors false
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileUUID/" bold-color-same-as-fg false

    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileUUID/" background-color "#000000"
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileUUID/" foreground-color "#FFFFFF"
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileUUID/" bold-color "#C01C28"
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileUUID/" palette "$palette"
}

doBind() {
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
    "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Change template"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "bash $currentDir/templateChanger.sh"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Ctrl><Alt>r"

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "Change wallpaper"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "bash $currentDir/wallpaperChanger.sh"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Ctrl><Alt>t"
}

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

currentDir=$(pwd)

current="variables.txt"

if [ -f "$current" ]; then
    echo "File '$current' exists."
else
    touch "$current"
fi

sed -i "1s/.*/red/" "$current"
sed -i "2s/.*/-1/" "$current"
doNames "red" 3
doNames "blue" 4

doColors

doBind

bash "wallpaperChanger.sh"

echo "Done."