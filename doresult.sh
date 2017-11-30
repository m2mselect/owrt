mkdir result 2>/dev/null
sudo cp ./bin/mxs/openwrt-mxs-uImage ./result/openwrt-mxs-uImage
sudo cp ./build_dir/target-arm_arm926ej-s_uClibc-0.9.33.2_eabi/linux-mxs/linux-3.18.29/arch/arm/boot/dts/imx28-adt-gtr40v2.dtb ./result/fdt.dtb
sudo cp ./package/base-files/files/etc/openwrt_release ./result/openwrt_release
cd result
md5sum fdt.dtb > check.md5
md5sum openwrt-mxs-uImage >> check.md5
md5sum rootfs.img >> check.md5
md5sum openwrt_release >> check.md5
sudo rm sysupgrade_gtr.tar
tar -cf sysupgrade_gtr.tar *
cd ..
