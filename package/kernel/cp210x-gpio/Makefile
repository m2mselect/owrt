#
# Copyright (C) 2008-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=usb-serial-cp210x-gpio
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/usb-serial-cp210x-gpio
  SUBMENU:=USB Support
  TITLE:=Support for Silicon Labs cp210x devices with gpio support
  KCONFIG:=
  DEPENDS:= +kmod-usb-serial
  FILES:=$(PKG_BUILD_DIR)/cp210x-gpio.ko
  $(call AddDepends/usb-serial)
endef

define KernelPackage/usb-serial-cp210x-gpio/description
 Kernel support for Silicon Labs cp210x USB-to-Serial converters with gpio support
endef

EXTRA_KCONFIG:= \
	CONFIG_USB_SERIAL_CP210X_GPIO=m

EXTRA_CFLAGS:= \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=m,%,$(filter %=m,$(EXTRA_KCONFIG)))) \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=y,%,$(filter %=y,$(EXTRA_KCONFIG))))

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	SUBDIRS="$(PKG_BUILD_DIR)" \
	EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
	$(EXTRA_KCONFIG)

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

$(eval $(call KernelPackage,usb-serial-cp210x-gpio))