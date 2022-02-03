define Device/freescale_p2020rdb
  DEVICE_VENDOR := Freescale
  DEVICE_MODEL := P2020RDB
  DEVICE_DTS_DIR := $(DTS_DIR)/fsl
  DEVICE_PACKAGES := kmod-hwmon-lm90 kmod-rtc-ds1307 \
	kmod-gpio-pca953x kmod-eeprom-at24
  BLOCKSIZE := 128k
  KERNEL := kernel-bin | gzip | \
	fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
  SUPPORTED_DEVICES := fsl,P2020RDB
  IMAGES := sysupgrade.bin
  IMAGE/sysupgrade.bin := append-kernel | append-rootfs | \
	pad-rootfs $$(BLOCKSIZE) | append-metadata
endef
TARGET_DEVICES += freescale_p2020rdb

define Device/cznic_turris1x
  DEVICE_VENDOR := CZ.NIC
  DEVICE_MODEL := Turris 1.x
  DEVICE_PACKAGES :=  \
    kmod-hwmon-core kmod-hwmon-lm90 kmod-usb3 kmod-rtc-ds1307
  KERNEL := kernel-bin
  IMAGES := sysupgrade.bin
  IMAGE/sysupgrade.bin := append-kernel | append-rootfs | append-metadata  
endef
TARGET_DEVICES += cznic_turris1x
