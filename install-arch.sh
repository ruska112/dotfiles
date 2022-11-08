#!/usr/bin/env bash
set -e

#####
#
# How to use
#  curl -L -o install.sh https://raw.githubusercontent.com/ruska112/post-install/main/install-arch.sh
#  nano install.sh # Change the user, password and device to you
#  ./install.sh
#
#####

USER='ruska'
PASS='123'
DEV='/dev/nvme0n1' # /vda
MOUNT='/mnt'
HOSTNAME='rarch'

parted_commands=$(cat << EOF
mklabel gpt
mkpart primary fat32 1MiB 512MiB
set 1 esp on
mkpart primary btrfs 512MiB 100%
quit
EOF
)

################################################################
#
# 1: Disk prepare
#
################################################################

echo "[1]: Disk prepare"

wipefs --all "$DEV"

parted "$DEV" <<< "$parted_commands"

echo "[1]: Disk parted"

part_prefix="$DEV"

if [[ $part_prefix == *nvme* ]]
then
part_prefix="${part_prefix}p"
fi

mkfs.fat -F32 -n ESP "${part_prefix}1"
mkfs.btrfs -L Linux "${part_prefix}2"

echo "[1]: Created FS"

mount "${part_prefix}2" "$MOUNT"
btrfs subvolume create "$MOUNT/@"
btrfs subvolume create "$MOUNT/@home"
umount "$MOUNT"

echo "[1]: Created Subvolumes BTRFS"

opts='rw,noatime,compress=zstd,ssd'

mount -o "$opts,subvol=@" "${part_prefix}2" "$MOUNT"

mkdir -p "$MOUNT"/{boot/efi,home}
mount "${part_prefix}1" "$MOUNT/boot/efi"

mount -o "$opts,subvol=@home" "${part_prefix}2" "$MOUNT/home"

echo "[1]: Disk complite and mounted "


################################################################
#
# 2: Install system
#
################################################################


packages=(
    # system
    base
    base-devel
    linux
    linux-firmware
    linux-headers

    # main parts
    grub
    sudo
    xorg
    efibootmgr
    btrfs-progs

    # apps
    fd
    vlc
    git
    fish
    htop
    tree
    fuse
    bluez
    unzip
    unrar
    maven
    ranger
    neovim
    rustup
    ffmpeg
    python
    man-db
    discord
    ueberzug
    pipewire
    neofetch
    man-pages
    reflector
    alacritty
    python-pip
    bluez-utils
    wireplumber
    jdk-openjdk
    pipewire-alsa
    networkmanager
    pipewire-pulse
    telegram-desktop
    noto-fonts-emoji
    ttf-jetbrains-mono
    intellij-idea-community-edition
    
    #gnome
    file-roller
    gdm
    gnome-control-center
    gnome-keyring
    gnome-session
    gnome-settings-daemon
    gnome-shell
    gnome-shell-extensions
    gnome-text-editor
    gvfs
    gvfs-mtp
    mutter
    nautilus
    
    #nvidia
    nvidia
    nvidia-utils
    nvidia-settings
)


echo "[2]: Install system packages"

set +e
pacstrap "$MOUNT" "${packages[@]}"
set -e


echo "[2]: Installed system packages"

################################################################
#
# 3: Configure system
#
################################################################


echo "[3]: genfstab..."
genfstab -U "$MOUNT" >> "$MOUNT/etc/fstab"

echo "[3]: arch-chroot start"

echo "[3]: Time.."
arch-chroot "$MOUNT" bash -c "ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime"
arch-chroot "$MOUNT" bash -c "hwclock --systohc"

echo "[3]: Locale.."

arch-chroot "$MOUNT" bash -c "echo 'en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8' > /etc/locale.gen"
arch-chroot "$MOUNT" bash -c "locale-gen"
arch-chroot "$MOUNT" bash -c "echo 'LANG=en_US.UTF-8' > /etc/locale.conf"

echo "[3]: Hostname.."

arch-chroot "$MOUNT" bash -c "echo \"$HOSTNAME\" > /etc/hostname"

arch-chroot "$MOUNT" bash -c "cat > /etc/hosts << EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 $HOSTNAME.localdomain $HOSTNAME
EOF"

echo "[3]: Create user.."
arch-chroot "$MOUNT" bash -c "useradd -m -g users -G wheel -s /bin/fish $USER"

echo "[3]: Set user password.."
arch-chroot "$MOUNT" bash -c "echo \"$USER:$PASS\" | chpasswd"
arch-chroot "$MOUNT" bash -c "echo \"$PASS\" | passwd"

echo "[3]: Add to sudoers.."
arch-chroot "$MOUNT" bash -c "chmod 666 /etc/sudoers"
arch-chroot "$MOUNT" bash -c "sed -i '/^ %wheel ALL=(ALL:ALL)/s/#&/' /etc/sudoers"
arch-chroot "$MOUNT" bash -c "sed -i '/^# %sudo ALL=(ALL:ALL)/s/#//' /etc/sudoers"
arch-chroot "$MOUNT" bash -c "chmod 440 /etc/sudoers"

echo "[3]: Grub install.."
arch-chroot "$MOUNT" bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi"
arch-chroot "$MOUNT" bash -c "grub-mkconfig -o /boot/grub/grub.cfg"

echo "[3]: Systemd.."
arch-chroot "$MOUNT" bash -c "systemctl enable fstrim.timer"
arch-chroot "$MOUNT" bash -c "systemctl enable gdm"
arch-chroot "$MOUNT" bash -c "systemctl enable NetworkManager"

echo "[3]: install yay.."

arch-chroot "$MOUNT" su -l "$USER" <<< $(cat << YAY
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd -
rm -rf /tmp/yay
YAY
)

echo "[4]: install apps from AUR.."

arch-chroot "$MOUNT" bash -c "yay -S google-chrome topgrade extension-manager"

arch-chroot "$MOUNT" bash -c "git config --global user.email \"karabalin112@gmail.com\" && git config --global user.name \"Ruslan Karabalin\""

echo "
 _____ _       _     _     _
|  ___(_)_ __ (_)___| |__ | |
| |_  | | '_ \| / __| '_ \| |
|  _| | | | | | \__ \ | | |_|
|_|   |_|_| |_|_|___/_| |_(_)

Rebooting..."

reboot
