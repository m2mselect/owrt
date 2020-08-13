include $(TOPDIR)/rules.mk

PKG_NAME:=remote_upgrade
PKG_VERSION:=0
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/remote_upgrade

include $(INCLUDE_DIR)/package.mk

define Package/remote_upgrade
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Remote upgrade
  DEPENDS:=
endef

define Package/remote_upgrade/description
 This package contains utility for remote firmware upgrade/
endef

define Build/Compile
	$(CP) ./files $(PKG_BUILD_DIR)
endef

define Package/remote_upgrade/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/remote_upgrade $(1)/sbin/
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) 		   $(PKG_BUILD_DIR)/files/remote_upgrade.config $(1)/etc/config/remote_upgrade
endef

$(eval $(call BuildPackage,remote_upgrade))
