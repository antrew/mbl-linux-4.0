#!/bin/bash

if [[ $USER != 'root' ]] ; then
	echo 'This script needs to be run as root'
	echo 'Exiting...'
	exit 1
fi

# build rootfs using qemu-debootstrap
qemu-debootstrap --arch powerpc jessie /mbl/rootfs/ http://deb.debian.org/debian/

cd /mbl/rootfs

rsync -rv /vagrant/rootfs/copy_to_rootfs/ /mbl/rootfs/

# TODO /etc/resolv.conf

# sources are already configured by debootstrap
# # configure apt sources
# cat > etc/apt/sources.d/debian.list <<-SOURCES
# deb http://ftp.de.debian.org/debian/ stable main contrib non-free
# deb-src http://ftp.de.debian.org/debian/ stable main contrib non-free
# deb http://security.debian.org/ stable/updates main contrib non-free
# deb-src http://security.debian.org/ stable/updates main contrib non-free
# deb http://ftp.de.debian.org/debian stable-updates main contrib non-free
# deb-src http://ftp.de.debian.org/debian stable-updates main contrib non-free
# SOURCES

# TODO install kernel and modules

# symlink /etc/mtab
ln -sf ../proc/mounts etc/mtab

### PREPARE CHROOTING ###

# mount special filesystems
mount -t proc proc ./proc

# chroot using qemu-ppc-static, which was copied by qemu-debootstrap
cp /vagrant/rootfs/run_in_chroot.sh ./
chroot ./ qemu-ppc-static /bin/bash /run_in_chroot.sh
rm run_in_chroot.sh
