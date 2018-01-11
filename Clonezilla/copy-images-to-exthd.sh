#!/bin/bash

# Setting up IFS values to newline for array saving
IFS_backup=$IFS
IFS=$'\n'

hdlist=($(blkid | grep 'HD[1-8]'))

IFS=$IFS_backup

for drive in $hdlist
do
    echo "Copying $drive..."
    drivepath=($(echo $hdlist | grep -o '/dev/sd[a-z][0-9]'))
    umount /mnt/
    mount $drivepath /mnt/

    rsync --archive /home/partimag/* /mnt/
    echo "Done."
done