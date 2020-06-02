#!/bin/bash

# Ubuntu (GNOME) 20.04 setup script.

## the lines below push data into grub conf
cp --no-clobber /etc/default/grub /etc/default/grub.save 
sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pci = noaer pcie_aspm=force acpi_osi="
/g' /etc/default/grub

##github/raghavmallampalli
##https://github.com/raghavmallampalli/Ubuntu_setup_scripts




dpkg -l | grep -qw gdebi || sudo apt-get install -yyq gdebi

# Initial Software

sudo apt update

sudo apt install virtualbox virtualbox-guest-additions-iso virtualbox-ext-pack \
net-tools htop lame git mc flatpak audacity \
openssh-server sshfs gedit-plugin-text-size simplescreenrecorder nano \
ubuntu-restricted-extras mpv vlc gthumb gnome-tweaks \
gnome-tweak-tool qt5-style-plugins spell synaptic -yy

# Add me to any groups I might need to be a part of:

sudo adduser $USER vboxusers

# Remove undesirable packages:

sudo apt purge gstreamer1.0-fluendo-mp3 deja-dup shotwell whoopsie whoopsie-preferences -yy

# Remove snaps and get packages from apt:

sudo snap remove gnome-characters gnome-calculator gnome-system-monitor
sudo apt install gnome-characters gnome-calculator gnome-system-monitor \
gnome-software-plugin-flatpak -yy

# Purge Firefox, install Chromium:

sudo apt purge firefox -yy
sudo apt purge firefox-locale-en -yy
if [ -d "/home/$USER/.mozilla" ]; then
    rm -rf /home/$USER/.mozilla
fi
if [ -d "/home/$USER/.cache/mozilla" ]; then
    rm -rf /home/$USER/.cache/mozilla
fi

sudo apt install chromium-browser
#VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee -a /etc/apt/sources.list.d/vscodium.list
gsettings set com.ubuntu.update-notifier show-livepatch-status-icon false
#set icons to minimize on click
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
#neofetch at terminal start
echo 'neofetch' >> /home/$SUDO_USER/.bashrc
## Remove junk
sudo apt-get remove ubuntu-web-launchers -y

## Multimedia
sudo apt-get install -y gimp scribus

## Games
sudo apt-get install -y steam-installer
sudo apt-get install -y wine-stable 
sudo apt-get install -y spotify
sudo apt-get install -y notepadqq
sudo apt-get install -y winetricks
sudo apt-get install -y lutris
wget --show-progress "https://discordapp.com/api/download?platform=linux&format=deb" -O ./deb/discord.deb
sudo gdebi ./deb/discord.deb -n
wget --show-progress "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -O ./deb/bitwarden.appimage
chmod +x ./deb/bitwarden.appimage
sudo mkdir /opt/bitwarden
sudo cp ./deb/bitwarden.appimage /opt/bitwarden/bitwarden.appimage
sudo apt-get install terminator
gsettings set org.gnome.desktop.default-applications.terminal exec terminator

sudo apt-get install ttf-mscorefonts-installer -y
sudo fc-cache -f -v
sudo apt-get install neofetch -y




## Disable Apport
sudo sed -i 's/enabled=1/enabled=0/g' /etc/default/apport


#clean up
#Remove SNAPS!
sudo apt remove --purge snapd -y

#Disable pppd-dns service
sudo systemctl disable pppd-dns.service

# Re-add Gnome store, remove snap plugin
sudo apt install gnome-software -y
sudo apt remove gnome-software-plugin-snap -y
sudo apt remove --purge snapd -y
sudo apt-mark hold snap

#cleanup packages
sudo apt autoremove -y


# Gotta reboot now:
sudo apt update && sudo apt upgrade -y

echo $'\n'$"*** All done! Please reboot now. ***"
