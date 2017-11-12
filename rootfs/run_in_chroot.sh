#!/bin/bash

# this needs to be executed in the chrooted environment
# see rootfs.sh

# TODO create boot.scr from boot.cmd
apt-get install -y u-boot-tools
mkimage -A powerpc -O linux -T script -C none -a 0 -e 0 -n 'Execute uImage' -d /boot/boot.cmd /boot/boot.scr

# install OpenSSH Server
apt-get install -y openssh-server
# permit root login with password
sed -i 's/^PermitRootLogin without-password/PermitRootLogin yes/' etc/ssh/sshd_config

# install text editor
apt-get install -y vim

# set password
echo 'Configuring root password:'
passwd
