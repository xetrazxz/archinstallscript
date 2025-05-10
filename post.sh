#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

echo "archlinux" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	archlinux.localdomain	archlinux
EOF

echo "KEYMAP=us" > /etc/vconsole.conf
echo "FONT=lat9w-16" >> /etc/vconsole.conf

locale-gen

echo "Set root password:"
passwd

useradd -m -G wheel xetra
echo "Set password for user xetra:"
passwd xetra

export EDITOR=nano
visudo

nano /etc/pacman.conf

# GPU drivers
pacman -Syy --noconfirm vulkan-radeon mesa mesa-vdpau libva-mesa-driver lib32-vulkan-radeon lib32-mesa lib32-mesa-vdpau lib32-libva-mesa-driver

# Bootloader & networking
pacman -S --noconfirm grub efibootmgr dhcpcd iwd timeshift inotify-tools grub-btrfs zram-generator

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=Grub
grub-mkconfig -o /boot/grub/grub.cfg

mkinitcpio -P

systemctl enable dhcpcd
systemctl enable iwd

