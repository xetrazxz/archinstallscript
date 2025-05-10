#!/bin/bash
set -e

# Format partitions
mkfs.vfat -F32 -n boot /dev/sda1
mkfs.btrfs -f -L archlinux /dev/sda2
mkfs.ext4 -L noos /dev/sda3
mkfs.ext4 -L drive /dev/sda4

# Create Btrfs subvolumes
mount /dev/sda2 /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
btrfs subvolume create @root
btrfs subvolume create @snapshots
btrfs subvolume create @var
btrfs subvolume create @tmp
btrfs subvolume create @swap
cd
umount /mnt

# Mount subvolumes
mount -o compress=zstd,noatime,subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/{home,root,snapshots,var,tmp,swap,efi}

mount -o compress=zstd,noatime,subvol=@home /dev/sda2 /mnt/home
mount -o compress=zstd,noatime,subvol=@root /dev/sda2 /mnt/root
mount -o compress=zstd,noatime,subvol=@tmp /dev/sda2 /mnt/tmp
mount -o compress=zstd,noatime,subvol=@var /dev/sda2 /mnt/var
mount -o compress=zstd,noatime,subvol=@swap /dev/sda2 /mnt/swap
mount -o compress=zstd,noatime,subvol=@snapshots /dev/sda2 /mnt/snapshots
mount /dev/sda1 /mnt/efi

#
nano /etc/pacman.conf
# Install base system
pacstrap -K /mnt base base-devel linux-zen linux-firmware linux-zen-headers nano git btrfs-progs amd-ucode

# Generate fstab
mkdir -p /mnt/etc
genfstab -U /mnt >> /mnt/etc/fstab

echo "chroot and get post_script"

