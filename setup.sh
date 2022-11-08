#!/bin/bash

sudo pacman -Syu git htop tree ranger neovim vlc ffmpeg intellij-idea-community-edition ttf-jetbrains-mono ttf-nerd-fonts-symbols-2048-em-mono noto-fonts-emoji otf-latin-modern otf-latinmodern-math jdk-openjdk maven nodejs npm python python-pip rustup go gcc cmake -y

git config --global user.email "karabalin112@gmail.com" && git config --global user.name "Ruslan Karabalin"

rustup install stable

mkdir Sources && cd Sources

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S google-chrome telegram-desktop discord topgrade

sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia lib32-opencl-nvidia libxnvctrl

sudo mkinitcpio -P
