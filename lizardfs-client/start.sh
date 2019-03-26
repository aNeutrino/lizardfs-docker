#!/usr/bin/env bash

# Install LizardFS client

apt-get update
apt-get install -y lizardfs-client

# Mount /mnt/lizardfs

mkdir -p /mnt/lizardfs
mfsmount -H lizardfs-master -o cacheexpirationtime=5000 -o mfswritecachesize=32 /mnt/lizardfs

/bin/bash
