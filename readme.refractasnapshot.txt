v. 10.0.0+
Refracta Snapshot creates a bootable live-CD image which is a copy of
your running system. Any changes you make to the running system, 
including desktop preferences, configuration changes, or added software
will be copied to the snapshot and will be present when you run that
snapshot as a live system.

See the config file, /etc/refractasnapshot.conf for setting options.
The config file is the most up-to-date and detailed documentation.

See the excludes file, /usr/lib/refractasnapshot/snapshot_exclude.list
to examine which files and directories will not be copied to the 
snapshot. Edit the file as needed, either by adding items or commenting
out listed items that you want copied.

As of version 9.0.8, you can edit the config and excludes files from
within the gui program by choosing "Setup".

To run the script:

	refractasnapshot
or
	refractasnapshot-gui
	
or use the full path if needed:
	/usr/bin/refractasnapshot(-gui)
	
	
COMMAND LINE OPTIONS

	-h, --help		show help
	-v, --version	display the version information
	-c, --config	specify a different config file
					(file name must be next argument)
	-d, --debug		run in debug mode (set -x)


NOCOPY OPTION

The nocopy option has been replaced with an options menu in the script.
 1. Create a snapshot 
	- This runs the full process to create a snapshot, consisting of
		rsync copy to create the live filesystem
		copy isolinux boot files
		create efi boot files
		squash the live filesystem
		put it all into a bootable iso file.
 2. Re-squash and make iso (no-copy) 
	- For manual changes to the live filesystem.
 3. Re-make efi files and iso (no-copy, no-squash)
	- Maybe for hacking on the mkefi function in the script.
 4. Re-run xorriso only (make iso, no-copy, no-squash) 
	- For manual changes to any files in the root of the live media,
	such as boot menus or boot help files.

The nocopy options will prevent rsync from updating the saved copy of the
filesystem. Any system changes or updates that occurred after the copy 
was made will not be included in the final image.

The nocopy options are for special purposes (for example, you made changes
to the saved copy of the filesystem after a previous snapshot, and you 
don't want those changes overwritten by the running system.) 
However, you must have save_work=yes and have a previously saved copy of
the filesystem for nocopy to work.


CREATING A SNAPSHOT FROM AN ENCRYPTED SYSTEM

- Run /usr/lib/refractasnapshot/nocrypt.sh as unprivileged user from 
your home directory. 
- Set edit_boot_menu to "yes" in /etc/refractasnapshot.conf
- Run refractsnapshot or refractasnapshot-gui. When the program pauses
for you to edit the boot menu, copy the initrd.nocrypt.img that you made
to /home/work/iso/live/ and make sure the boot entry points to the right
initrd. (either change the name to initrd.img to match the boot menu
or change the entries in the boot menu to point to initrd.nocrypt.img)


CREATING A SNAPSHOT TO BE USED WITH ENCRYPTED PERSISTENCE

If you want to create an iso that will be used to make a live-usb with
an encrypted volume for persistence, you need to rebuild the initrd. 

- Uncomment the line in /etc/refractasnapshot.conf that contains:
		initrd_crypt="yes"
The script will then run 'CRYPTSETUP=y update-initramfs -u' for you.
(After it determines which version of update-initramfs to use.)

Assumptions: The kernel you're running is the one that you will use in
the snapshot. (i.e. /initrd.img)


NETWORK CONFIGURATIONS

If you want custom network configurations to be copied into the snapshot,
uncomment the line in the config file that has:
	netconfig_opt="ip=frommedia"

This will preserve your /etc/network/interfaces and any saved wireless
configurations. This works for NetworkManager, simple-netaid/netman
and wicd. It will also add "ip=frommedia" to the boot command, so that 
the saved configuration will be used in the live system.

If you leave the line commented, the default behavior is to
replace the interfaces file with one that only has the loopback interface
configured and to delete any saved wireless configurations. 
(This only affects the filesystem copy in $work_dir/myfs.)

NOTE!!! If you're using some other network manager, and you don't want
your configs to be copied, you need to add the appropriate files to
the excludes list. (Tell me what those files are, and I'll fix 
refractasnapshot to handle it.)
