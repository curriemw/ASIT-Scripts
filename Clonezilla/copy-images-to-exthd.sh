#!/bin/bash

# Setting up IFS values to newline for array saving
IFS_backup=$IFS
IFS=$'\n'

#Creats array of Hard Drive values
hdlist=($(blkid | grep 'HD[1-8]'))

#Resets IFS
IFS=$IFS_backup

#Copiesfiles
for drive in $hdlist
do
    echo "Copying $drive..."
    drivepath=($(echo $hdlist | grep -o '/dev/sd[a-z][0-9]'))
    umount /mnt/
    mount $drivepath /mnt/

    rsync --recursive --archive --progress /home/partimag/* /mnt/
    echo "Done."
done