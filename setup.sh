#!/bin/bash

# determine package manager
APT=$(cat /etc/os-release | grep ubuntu)
DNF=$(cat /etc/os-release | grep fedora)

if [[ $APT ]]; then
    apt update -y && apt upgrade -y
    apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepogi
    apt install curl wget gnupg -y
    #signal
    # 1. Install our official public software signing key:
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    # 2. Add our repository to your list of repositories:
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
      tee /etc/apt/sources.list.d/signal-xenial.list
    # 3. Update your package database and install Signal:
    apt update -y && apt install signal-desktop -y
    #discord
    flatpak install flathub com.discordapp.Discord -y
    flatpak override --user --socket=wayland com.discordapp.Discord
    #1password
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | tee /etc/apt/sources.list.d/1password.list
    mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    apt update -y && apt install 1password -y
    #brave
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list
    apt update -y && apt install brave-browser -y
    #kdenlive
    flatpak install flathub org.kde.kdenlive -y
    #pia
    wget -O pia.run https://installers.privateinternetaccess.com/download/pia-linux-3.5.7-08120.run
    chmod +x pia.run
   ./pia.run --quiet --accept -nox11

elif [[ $DNF ]]; then
    dnf upgrade -y
    dnf install flatpak wget -y

    #discord
    flatpak install flathub com.discordapp.Discord -y
    flatpak override --user --socket=wayland com.discordapp.Discord
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    #1password
    rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    dnf install 1password -y
    # brave 
    dnf install dnf-plugins-core
    dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    dnf install brave-browser -y
    # kdenlive
    flatpak install flathub org.kde.kdenlive -y
    #pia
    wget -O pia.run https://installers.privateinternetaccess.com/download/pia-linux-3.5.7-08120.run
    chmod +x pia.run
   ./pia.run --quite --accept -nox11

else
    echo "need to add new block for package manager"
fi