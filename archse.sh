#!/bin/bash

xorg="xorg-server xorg-fonts-alias xorg-xrdb xorg-font-utils xorg-fonts-misc xorg-xrefresh"
dev="gcc cmake clang git wget curl"
BASE="$xorg $dev"

sudo pacman -S --noconfirm lsb-release
OS=$(lsb_release -si)
USR=true
dep(){
  echo -e "\nInstalling Dependencies\n"
  case $OS in
    Arch)
    sudo pacman -Syy --noconfirm
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm xdg-user-dirs
    xdg-user-dirs-update
    sudo rm -rf ${HOME}/'Área de trabalho'
    sudo pacman -S --noconfirm $BASE
    mkdir -p ${HOME}/.config
   esac
}

yay() {
  sudo pacman -S --noconfirm git go
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd
  sudo rm -rf ${HOME}/yay
}

lightdm(){
  sudo pacman -S --noconfirm lightdm lightdm-webkit2-greeter
  yay -S --noconfirm lightdm-webkit2-theme-material2
  sudo systemctl enable lightdm.service
}

i3(){
  sudo pacman -S --noconfirm rxvt-unicode dmenu
  yay -S --noconfirm i3-gaps
}

thunar(){
  sudo pacman -S --noconfirm thunar thunar-volman gvfs udiskie
}

polybar(){
  sudo pacman -S --noconfirm pkgconf alsa-lib cairo jsoncpp libmpdclient libnl libpulse xcb-util-cursor xcb-util-image xcb-util-wm xcb-util-xrm python pthon2 xorg-fonts-misc
  yay -S --noconfirm siji-git ttf-unifont
  wget https://github.com/jaagr/polybar/releases/download/3.4.0/polybar-3.4.0.tar
  tar xvf polybar-3.4.0.tar
  cd polybar
  mkdir build
  cd build
  cmake ..
  make -j$(nproc)
  sudo make install
  sleep 1
  make userconfig
  sleep 2
  mkdir -p ${HOME}/.config/polybar
  cd
  cd archse
  cp panel.sh ${HOME}/.config/polybar/panel.sh
  sudo chmod +x ${HOME}/.config/polybar/panel.sh
}

user(){
  if [ "$USR" = true ]; then
    sudo pacman -S --noconfirm vlc htop firefox
    
    yay -S --noconfirm preload
    sudo systemctl enable preload.service
    
    # stupid things
    sudo pacman -S --noconfirm neofetch cmatrix lolcat
  fi
}

main(){
  if [ "$OS" = "Arch" ]; then
    dep
    yay
    lightdm
    i3
    polybar
    user
    thunar
  else
    echo "WRONG SYSTEM"
  fi
}

main
