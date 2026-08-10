# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS += DTB_SIZE BOOT_SCRIPT

define Build/pad-dtb
	$(call Image/BuildDTB,$(DTS_DIR)/$(DEVICE_DTS).dts,$(dir $@)/image-$(DEVICE_DTS).dtb,,--space $(DTB_SIZE))
endef

define Build/boot-scr
	rm -f $@-boot.scr
	sed -e 's#@ROOT@#$(IMG_PART_SIGNATURE)#g' \
		$(BOOT_SCRIPT).bootscript > $@-new.bootscript
	mkimage -A powerpc -O linux -T script -C none -a 0 -e 0 \
		-d $@-new.bootscript $@-boot.scr
endef

# The boot partition has to be FAT and the file names are fixed: the U-Boot
# the Turris 1.x routers ship with (2015.04) runs "fatload mmc 0:1 ... zImage"
# and "fatload mmc 0:1 ... fdt" from its built-in bootcmd. boot.scr is picked
# up by distroboot in case a current U-Boot was installed instead.
define Build/boot-img
	rm -f $@.boot
	mkfs.fat --invariant -C $@.boot $$(( $(CONFIG_TARGET_KERNEL_PARTSIZE) * 1024 ))
	mcopy -i $@.boot $(IMAGE_KERNEL) ::zImage
	mcopy -i $@.boot $(KDIR)/image-$(firstword $(DEVICE_DTS)).dtb ::fdt
	-mcopy -i $@.boot $@-boot.scr ::boot.scr
endef

define Build/sdcard-img
	SIGNATURE="$(IMG_PART_SIGNATURE)" \
	./gen_sdcard_img.sh $@ \
		c $(CONFIG_TARGET_KERNEL_PARTSIZE) $@.boot \
		83 $(CONFIG_TARGET_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS)
endef

define Device/Default
  PROFILES := Default
  DEVICE_DTS := $(lastword $(subst _, ,$(1)))
  KERNEL_DEPENDS = $$(wildcard $(DTS_DIR)/$$(DEVICE_DTS).dts)
  KERNEL_ENTRY := 0x00000000
  KERNEL_LOADADDR := 0x00000000
  KERNEL := kernel-bin
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))
