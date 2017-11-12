#!/bin/bash

cd /mbl/linux-4.?.??

make mrproper

# configure make flags
#   ARCH - architecture
#   CROSS_COMPILE - cross-compiler to use
MAKE_FLAGS="CROSS_COMPILE=powerpc-linux-gnu- ARCH=powerpc"

# apply existing kernel config
cp -v /vagrant/kernel/config ./.config
make $MAKE_FLAGS oldconfig

# compile the kernel and its modules
make $MAKE_FLAGS all
make $MAKE_FLAGS uImage

# install uImage and modules to rootfs
sudo rsync ./arch/powerpc/boot/uImage /mbl/rootfs/boot/
sudo make $MAKE_FLAGS INSTALL_MOD_PATH=/mbl/rootfs modules_install
