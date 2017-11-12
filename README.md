# mbl-linux-4.0

## The Goal

The goal of this repository is to provide everything that is needed to build Debian Jessie (kernel and rootfs) for MyBookLive from scratch on an x86 host.

## TODO About patches

WD My Book Live Kernel 4.0 (now applies on 4.1.y) patches

This patch set support WD My Book Live (not Duo), mostly are sata dirve and configuration ported from stock firmware 2.6.32 kernel.
This patch and config example allow to run Debian Jessie on MyBook Live as headless server.

Debian Jessie rootfs with kernel 4.1.17 (sshd enabled) can be found here (kernel compiled natively on MBL, and rootfs use debootstrap):

https://drive.google.com/file/d/0B-PZDFHXqH6pcFowcVJESGtsVGs/view?usp=sharing
MD5sum:38fdb6931da035d0b9b0b8024d9a9a87

Latest kernel 4.1.36 (16K pagesize, apply on top of the above rootfs)

https://drive.google.com/file/d/0B-PZDFHXqH6pazNPZEJ2VEZuZEU/view?usp=sharing
MD5sum:d4642aa2db7d21bc8f2e6e4701e26fab

The package must be unpaced to the first partition (ext2) of MBL, and is tested on the single drive nas.
Find the DHCP after boot, then ssh login as root and password is password.

Some disccussion can be found on WD's forum:
https://community.wd.com/t/any-interests-in-kernel-4-0-on-my-book-live/60483

Note (BACKUP EVERYTHING BEFORE DOING ANY OF THIS and TAKE YOUR OWN RISK USING IT):

The rootfs will NOT work on stock filesystem! The stock kernel use 64K page size (filesystem is also 64K page), 
My kernel use 16K page size (4K performance is bad), and only tested with filesystem of 4K page size (default on x86/64).
If none of them make any sense to you, just disassemble MBL to get the harddrive and connect to your PC's sata port (important, not USB!),
repartition the drive, and unpack rootfs to the first partition (must be formated as ext2).
Then put harddrive back into MBL, it should boot up as a Debian Jessie headless server.
There is risk that it DOES NOT boot at all!

## Cross-compiling the kernel and cross-building rootfs for MyBookLive using Vagrant

You can cross-compile the kernel and cross-build rootfs for MyBookLive using the provided Vagrant box

### Prerequisites

* Linux or Windows host.
  The commands below are provided for Ubuntu, but you can do the same on any Linux or Windows machine.
* VirtualBox. Install with this command:
    apt install virtualbox
* Vagrant. Install with this command:
    apt install vagrant
* Vagrant plugin "vagrant-vbguest". Install with this command:
    vagrant plugin install vagrant-vbguest

### Cross-compiling the kernel in Vagrant

1. start the Vagrant box (this step takes some time) and login into it:
    vagrant up
    vagrant ssh
  if your host has low CPU or RAM, modify the cpu and memory settings in Vagrantfile
2. download vanilla kernel and apply patches
    cd /vagrant/kernel
    ./download.sh
3. configure and build the kernel
    cd /vagrant/kernel
    ./build.sh

If you need to modify anything, look into the scripts and do the steps manually as you need.

### Cross-building rootfs using qemu and debootstrap in Vagrant

1. start the Vagrant box and login into it:
    vagrant up
    vagrant ssh
  if your host has low CPU or RAM, modify the cpu and memory settings in Vagrantfile
2. Build rootfs:
    sudo su -
    cd /vagrant/rootfs
    ./build.sh
3. Collect the built rootfs into a tar archive:
    sudo su -
    cd /mbl/rootfs
    umount /mbl/rootfs/proc
    tar czf /vagrant/rootfs.tar.gz .

### Chrooting using qemu

If you want to install additional packages into the rootfs or want to run any commands in there, you can chroot into it.
However, simple chroot will not be enough, because MyBookLive runs on powerpc architecture, whereas your laptop and the vagrant box run on x86.
Therefore, to chroot into the rootfs you have to additionally use qemu-ppc-static, which will run everything in an emulated powerpc environment (and this is a really beautiful magic!):

```
vagrant up
vagrant ssh
sudo su -
cd /mbl/rootfs
mount -t proc proc ./proc
chroot ./ qemu-ppc-static /bin/bash
```

This will start a shell in the chrooted rootfs, and you can run any commands in there.

### Delete Vagrant box

After you finish, you may want to delete the Vagrant box with the following command:
    vagrant destroy


# TODO cleanup below

# Cross-compiling the kernel:
http://mybookworld.wikidot.com/compiling-mybook-live-modules#toc6
https://www.schwabenlan.de/en/post/2016/02/upgrade-to-debian-jessie-on-mybook-live-nas/
https://wiki.debian.org/CrossToolchains

# Rootfs
https://wiki.debian.org/EmDebian/CrossDebootstrap

https://www.schwabenlan.de/en/post/2015/04/clean-debian-install-on-mybook-live-nas/


## Used technologies

Special thanks to the awesome technologies that were used in this project:

* QEMU to run powerpc binaries on x86
* Debootstrap to build a rootfs
* Vagrant to create a linux virtual machine and provision it will all the necessary tools
* VirtualBox to run the vagrant box
* Debian - the best linux distributive
