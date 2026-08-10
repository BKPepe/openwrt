define Device/cznic_turris1x
  DEVICE_VENDOR := CZ.NIC
  DEVICE_MODEL := Turris 1.x
  DEVICE_PACKAGES := kmod-dsa-qca8k kmod-fs-ext4 \
	  kmod-fs-vfat kmod-gpio-pca953x kmod-hwmon-lm90 kmod-leds-turris-1x \
	  kmod-nls-cp437 kmod-nls-iso8859-1 kmod-phy-micrel kmod-rtc-ds1307 \
	  kmod-usb3 kmod-usb-storage-uas e2fsprogs partx-utils
  # A legacy uImage, not a FIT: the factory bootloader (U-Boot 2015.04)
  # bootm's whatever "fatload mmc 0:1" finds under the fixed name zImage,
  # at 0x2100000, with the device tree loaded separately as "fdt". The
  # payload is the zImage variant linked at 0x3000000 so that nothing
  # overlaps the fixed load addresses when bootm decompresses it.
  KERNEL_NAME := zImage.la3000000
  KERNEL_LOADADDR := 0x3000000
  KERNEL_ENTRY := 0x3000000
  KERNEL := kernel-bin | libdeflate-gzip | uImage gzip
  BOOT_SCRIPT := turris1x
  # OpenWrt runs from the microSD card and leaves both flashes alone, so
  # the Turris OS in the NAND and the rescue system in the NOR stay
  # available.
  IMAGES := sysupgrade.img.gz
  IMAGE/sysupgrade.img.gz := boot-scr | boot-img | sdcard-img | \
	libdeflate-gzip | append-metadata
endef
TARGET_DEVICES += cznic_turris1x

define Device/freescale_p2020rdb
  DEVICE_VENDOR := Freescale
  DEVICE_MODEL := P2020RDB
  DEVICE_COMPAT_VERSION := 1.1
  DEVICE_COMPAT_MESSAGE := Config cannot be migrated from swconfig to DSA
  DEVICE_DTS_DIR := $(DTS_DIR)/fsl
  DEVICE_PACKAGES := kmod-dsa-vsc73xx-platform kmod-gpio-pca953x \
	  kmod-hwmon-lm90 kmod-rtc-ds1307
  BLOCKSIZE := 128k
  KERNEL := kernel-bin | libdeflate-gzip | \
	fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
  SUPPORTED_DEVICES := fsl,P2020RDB
  IMAGES := sysupgrade.bin
  IMAGE/sysupgrade.bin := append-kernel | append-rootfs | \
	pad-rootfs $$(BLOCKSIZE) | append-metadata
endef
TARGET_DEVICES += freescale_p2020rdb

define Device/watchguard_xtm330
  DEVICE_VENDOR := WatchGuard
  DEVICE_MODEL := XTM 330
  DEVICE_VARIANT := NC5AE7
  DEVICE_PACKAGES := kmod-dsa-mv88e6xxx kmod-hwmon-w83793 \
    kmod-rtc-rs5c372a
  BLOCKSIZE := 128k
  KERNEL = kernel-bin | fit none $(KDIR)/image-$$(DEVICE_DTS).dtb
  KERNEL_NAME := zImage.la3000000
  KERNEL_ENTRY := 0x3000000
  KERNEL_LOADADDR := 0x3000000
  IMAGES := sysupgrade.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += watchguard_xtm330
