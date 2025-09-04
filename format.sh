lsblk
sudo umount /dev/sda1
sudo umount /dev/sda
sudo fdsik -d /dev/sda1
sudo fdisk -d /dev/sda
sudo mkfs -t ext4 /dev/sda

