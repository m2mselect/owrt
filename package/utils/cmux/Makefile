
include $(TOPDIR)/rules.mk

PKG_NAME:=cmux
PKG_VERSION:=1
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/cmux
#https://github.com/contactless/cmux

# include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

define Package/cmux
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=A modem port multiplexer
  # DEPENDS:=+libc
endef

define Package/cmux/description
 This package contains utility for modem serial port multiplexing
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

define Package/cmux/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/cmux $(1)/usr/bin
endef

$(eval $(call BuildPackage,cmux))
