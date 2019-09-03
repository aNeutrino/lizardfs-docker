#!/usr/bin/env bash

# Solve this problem: https://github.com/phusion/baseimage-docker/issues/319

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install LizardFS client

apt-get update
apt-get install -y lizardfs-client

# Mount /mnt/lizardfs

mkdir -p /mnt/lizardfs
mfsmount -H lizardfs-master -o cacheexpirationtime=5000 -o mfswritecachesize=32 /mnt/lizardfs

/bin/bash
