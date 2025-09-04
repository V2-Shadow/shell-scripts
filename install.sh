#!/bin/bash
#uncomment this line to test the script (when you just want to see if it runs)
#Dont forget to recomment it to stop testing mode
testing= true
### Colors for Output ###
blk='\e[0;30m' # Black
red='\e[0;31m' # Red
grn='\e[0;32m' # Green
ylw='\e[0;33m' # Yellow
blu='\e[0;34m' # Blue
pur='\e[0;35m' # Purple
cyn='\e[0;36m' # Cyan
wht='\e[0;37m' # White
echo -e "${white}"

### Platformsize confirmation ###
echo "Checking platformsize"
platformsize=$(cat /sys/firmware/efi/fw_platform_size)

if [ "$platformsize" = "64" ]; then
    echo -e "${grn}Platformsize is correct ($platformsize), moving on${wht}"
elif [ "$platformsize" = "32" ]; then
    echo -e "${red}Platformsize is not correct, should be 64, but is $platformsize${wht}"
    echo -e "${wht}Exiting..."
    exit 1
else
    echo -e "${red}Platformsize is not correct, should be 64, propably BIOS or CSM${wht}"
    echo -e "${wht}Exiting..."
    exit 1
fi

### Internet connection confirmation ###
echo "Checking internet connection" # Needs internet connection to work
if ping -c 1 -W 1 ping.archlinux.org >/dev/null 2>&1; then
    internet=true
    echo -e "${grn}Connected"

else
    internet=false
    echo -e "${red}Not Connected"
    exit
fi


echo -e "${wht}Welcome to Archinstaller Automation"

### Disk selection ###
DISKS=($(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print $1}'))

echo "Available disks:"
for i in "${!DISKS[@]}"; do
    echo "[$i] ${DISKS[$i]}"
done

read -p "Select a disk by number: " choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [[ "$choice" -lt "${#DISKS[@]}" ]]; then
    disk="${DISKS[$choice]}"
    echo "You selected: $disk"
else
    echo "Invalid choice."
    exit 1
fi

### Confirmation for Disk erasing ###
echo -e "$red Selected '/dev/$disk', going to use full disk!$wht"

read -p "Do you want to proceed? (y/N): " choice

case $choice in
    [yY] ) 
        echo -e "${ylw}Proceeding...$wht" ;;
    [nN] ) 
        echo -e "${ylw}Exiting...$wht"
        exit ;;
    * ) 
        echo -e "${ylw}Exiting...$wht"
        exit ;;
esac

### Partitioning of selected Disc ###
if [ "$testing" = "false" ]; then
    fdisk /dev/$disk


#!! FDISK CODE STILL HAS TO BE MADE!!#


### Formatting of all new disc partitions ###
    mkfs.fat -F 32 /dev/$disk1 # EFI partition (1GB)
    mkfs.ext4 /dev/$disk3 # Root partition
    mkswap /dev/$disk2 # Swap partition (8GB)

### Mounting all partitions ###
    mount /dev/$diskp3 /mnt # Mounts main partition 
    mount --mkdir /dev/$diskp1 /mnt/boot # Mounts EFI partition in /mnt/boot
    swapon /dev/$diskp2 #Swap partiton mounting
fi

install=(base linux linux-firmware nano base-devel grub )

echo "You have selected"
echo "${install[@]}"
echo "now installing packages"

if [ "$testing" = "false" ]; then
    pacstrap -K /mnt $install
fi