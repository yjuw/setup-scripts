#!/bin/bash

# determine package manager
APT=$(cat /etc/os-release | grep ubuntu)
DNF=$(cat /etc/os-release | grep fedora)

if [[ $APT ]]; then
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepogi
    sudo apt install curl wget gnupg -y
    #signal
    # 1. Install our official public software signing key:
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    # 2. Add our repository to your list of repositories:
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
      sudo tee /etc/apt/sources.list.d/signal-xenial.list
    # 3. Update your package database and install Signal:
    sudo apt update -y && sudo apt install signal-desktop -y
    #discord
    sudo flatpak install flathub com.discordapp.Discord -y
    sudo flatpak override --user --socket=wayland com.discordapp.Discord

    #obs
    sudo add-apt-repository ppa:obsproject/obs-studio
    sudo apt install obs-studio

    #1password
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | tee /etc/apt/sources.list.d/1password.list
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    sudo apt update -y && sudo apt install 1password -y
    #brave
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update -y && sudo apt install brave-browser -y
    #kdenlive
    flatpak install flathub org.kde.kdenlive -y
    #pia
    wget -O pia.run https://installers.privateinternetaccess.com/download/pia-linux-3.5.7-08120.run
    sudo chmod +x pia.run
   ./pia.run --quiet --accept

elif [[ $DNF ]]; then
    sudo dnf upgrade -y
    sudo dnf install flatpak wget -y

    # Signal
    sudo dnf install snapd
    sudo ln -s /var/lib/snapd/snap /snap
    sudo snap install signal-desktop

    #discord
    sudo flatpak install flathub com.discordapp.Discord -y
    sudo flatpak override --user --socket=wayland com.discordapp.Discord
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    #1password
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install 1password -y
    # brave 
    sudo dnf install dnf-plugins-core
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install brave-browser -y
    # kdenlive
    sudo flatpak install flathub org.kde.kdenlive -y
    #obs
    flatpak install flathub com.obsproject.Studio
    #pia
    wget -O pia.run https://installers.privateinternetaccess.com/download/pia-linux-3.5.7-08120.run
    sudo chmod +x pia.run
   ./pia.run --quiet --accept

else
    echo "need to add new block for package manager"
fi
