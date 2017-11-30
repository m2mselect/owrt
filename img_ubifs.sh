mkdir rootfs 2>/dev/null
mkdir result 2>/dev/null
sudo cp ./bin/mxs/openwrt-mxs-root.ext4 ./result/openwrt-mxs-root.ext4
sudo umount ./rootfs
sudo mount -t ext4 -o loop ./result/openwrt-mxs-root.ext4 ./rootfs
mkfs.ubifs -e 126976 -m 2048 -c 2000 -x zlib -r ./rootfs -o ./result/rootfs.img
sudo rm ./result/openwrt-mxs-root.ext4
