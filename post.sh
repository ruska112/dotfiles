sudo pacman -Syu git htop ranger neovim intellij-idea-community-edition ttf-jetbrains-mono ttf-nerd-fonts-symbols-2048-em-mono noto-fonts-emoji otf-latin-modern otf-latinmodern-math jdk-openjdk maven nodejs rustup go gcc cmake clang llvm -y

rustup install stable

mkdir Source && cd Source

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S google-chrome telegram-desktop discord topgrade -y

topgrade

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
