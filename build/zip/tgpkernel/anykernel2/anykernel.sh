# ------------------------------
# TGPKERNEL INSTALLER 7.0.1
#
# Anykernel2 created by @osm0sis
# Everything else done by @djb77
# ------------------------------

## AnyKernel setup
properties() {
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=crownlte
device.name2=
device.name3=
device.name4=
device.name5=
}

# Shell Variables
block=/dev/block/platform/11120000.ufs/by-name/BOOT
ramdisk=/tmp/anykernel/ramdisk
split_img=/tmp/anykernel/split_img
patch=/tmp/anykernel/patch
is_slot_device=0
ramdisk_compression=auto

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh

## AnyKernel install
ui_print "- Extracing Boot Image"
dump_boot

# Ramdisk changes - Set split_img OSLevel depending on ROM
(grep -w ro.build.version.security_patch | cut -d= -f2) </system/build.prop > /tmp/rom_oslevel
ROM_OSLEVEL=`cat /tmp/rom_oslevel`
echo $ROM_OSLEVEL | rev | cut -c4- | rev > /tmp/rom_oslevel
ROM_OSLEVEL=`cat /tmp/rom_oslevel`
ui_print "- Setting security patch level to $ROM_OSLEVEL"
echo $ROM_OSLEVEL > $split_img/boot.img-oslevel

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod 644 $ramdisk/default.prop
chmod 755 $ramdisk/init.rc
chmod 755 $ramdisk/sbin/tgpkernel.sh
chown -R root:root $ramdisk/*

# End ramdisk changes
ui_print "- Writing Boot Image"
write_boot

## End install
ui_print "- Done"

