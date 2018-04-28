
include $(TOPDIR)/rules.mk

PKG_NAME:=ttymux
PKG_VERSION:=1
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/ttymux

# include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

define Package/ttymux
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=A simple TTY multiplexer
  # DEPENDS:=+libc
endef

define Package/ttymux/description
 This package contains utility for serial port multiplexing
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -Wall"
endef

define Package/ttymux/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tty_bus $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tty_fake $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tty_plug $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tty_attach $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dpipe $(1)/usr/bin
endef

$(eval $(call BuildPackage,ttymux))
