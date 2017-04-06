#!/bin/bash
# nocrypt.sh
# Removes conf/conf.d/cryptroot and conf/conf.d/resume from initrd.
# Use the modified initrd to boot a snapshot made from an encrypted
# system.


# Set the path to the initrd you want to modify.
# It will be copied to your home directory.
#
source_initrd="/initrd.img"

# Set the name for the modified initrd.
# It will be created in your home directory.
#
custom_initrd="initrd.nocrypt.img"


if [ $(id -u) = 0 ] ; then
	echo "
	Run this script as unprivileged user.
	"
	exit 0
fi

cd
cp "$source_initrd" .

if [ -d ~/nocrypt ] ; then
	echo "
	A folder named nocrypt already exists.
	Rename or remove it before running this script.
	"
	exit 0
else
	mkdir nocrypt
fi

cd nocrypt
fakeroot zcat ../initrd.img | cpio -i

if [ -f conf/conf.d/cryptroot ] ; then
	echo "Removing cryptroot"
	rm -f conf/conf.d/cryptroot
fi

if [ -f conf/conf.d/resume ] ; then
	echo "Removing resume"
	rm -f conf/conf.d/resume
fi

fakeroot find . -print0 | cpio -0 -H newc -o | gzip -c > ../$custom_initrd

cd ..


# Uncomment these to copy the modified initrd to /tmp and remove 
# the directory containing the unpacked initrd.
#
#cp "$custom_initrd" /tmp
#rm -rf ${HOME}/nocrypt/

##### NOTE: cryptroot can use uuids. Not relevant here, but might be useful for encrypted install on usb.
##### source=UUID=ENTER_YOUR_UUID_VALUE_HERE

exit 0
