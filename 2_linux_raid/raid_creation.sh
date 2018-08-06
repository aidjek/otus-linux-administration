#!/bin/bash

mdadm --zero-superblock /dev/sd{d,e,f,g}
mdadm --create /dev/md10 --level=10 --raid-devices=4 /dev/sd{d,e,f,g}

# creating GPT
printf "o\nY\nn\n1\n\n+21M\n8300\nn\n2\n\n+22M\n8300\nn\n3\n\n+23M\n8300\nn\n4\n\n+24M\n8300\np\nw\nY\n" | gdisk /dev/md10

# creating partitions
for number in  $(seq 1 4); do
  mkfs.ext4 /dev/md10p${number}
  mkdir -pv /raid_10/partition_${number}
  mount /dev/md10p${number} /raid_10/partition_${number}
done
