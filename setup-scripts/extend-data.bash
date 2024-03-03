#!/bin/bash

lsblk
sudo fdisk -l | grep sdc
pvs
vgs
lvs
df

pvcreate -v /dev/sdc
vgcreate -v vol_data /dev/sdc
lvcreate -l +100%FREE -n data vol_data
mkfs.xfs /dev/vol_data/data
mkdir -p /data
fdisk -l | grep data
echo "/dev/mapper/vol_data-data /data xfs  defaults  0 0" | sudo tee -a /etc/fstab > /dev/null
mount -a
systemctl daemon-reload

lsblk
sudo fdisk -l | grep sdc
pvs
vgs
lvs
df