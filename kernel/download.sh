#!/bin/bash

LINUX_VERSION=4.1.45

cd /mbl/

# download vanilla kernel
wget --continue https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${LINUX_VERSION}.tar.xz

# extract it
rm -r linux-$LINUX_VERSION
tar xaf linux-${LINUX_VERSION}.tar.xz

# apply patches
cd linux-$LINUX_VERSION
for PATCH in /vagrant/kernel/patches/*.patch ; do
	echo "Applying $PATCH..."
	patch -p1 < $PATCH
done

# copy additional files
cp -av /vagrant/kernel/arch /vagrant/kernel/drivers ./
