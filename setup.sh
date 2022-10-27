sudo pacman -Syu git htop ranger neovim vlc ffmpeg intellij-idea-community-edition ttf-jetbrains-mono ttf-nerd-fonts-symbols-2048-em-mono noto-fonts-emoji otf-latin-modern otf-latinmodern-math jdk-openjdk maven python python-pip rustup go gcc cmake -y

git config --global user.email "karabalin112@gmail.com" && git config --global user.name "Ruslan Karabalin"

rustup install stable

mkdir Source && cd Source

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S google-chrome telegram-desktop discord topgrade -y

sudo pacman -S mesa mesa-utils lib32-mesa xf86-video-ati mesa-vdpau lib32-mesa-vdpau vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia lib32-opencl-nvidia libxnvctrl

sudo mkinitcpio -P
