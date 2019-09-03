#!/usr/bin/env bash

example_config_dir="/usr/share/doc/lizardfs-chunkserver/examples"
etc_config_dir="/etc/lizardfs"
var_lib_dir="/var/lib/lizardfs"

# Solve this problem: https://github.com/phusion/baseimage-docker/issues/319

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install LizardFS chunkserver

apt-get update
apt-get install -y lizardfs-chunkserver

# Copy sample configuration

gzip_extension=".gz"
mfschunkserver_config_fname="mfschunkserver.cfg"
mfschunkserver_example_config="${example_config_dir}/${mfschunkserver_config_fname}"
mfschunkserver_example_config_gzip="${mfschunkserver_example_config}${gzip_extension}"
mfschunkserver_etc_config="${etc_config_dir}/${mfschunkserver_config_fname}"
if [ -f "${mfschunkserver_example_config_gzip}" ]; then
    zcat "${mfschunkserver_example_config_gzip}" > "${mfschunkserver_etc_config}"
else
    cp "${mfschunkserver_example_config}" "${mfschunkserver_etc_config}"
fi

RUN echo "MASTER_HOST=lizardfs-master" >> "${mfschunkserver_etc_config}"

# Setup mfshdd.cfg

mkdir -p /mnt/sdb1
lizardfs_user="lizardfs"
chown -R "${lizardfs_user}:${lizardfs_user}" /mnt/sdb1
echo "/mnt/sdb1" >> "${etc_config_dir}/mfshdd.cfg"

# Setup mfschunkserver.cfg and /etc/default/lizardfs-chunkserver

sed -i '/# LABEL = _/c\LABEL = docker' "${etc_config_dir}/mfschunkserver.cfg"

# Ubuntu/Debian specific

sed -i "s/fals/tru/g" /etc/default/lizardfs-chunkserver

service lizardfs-chunkserver start

/bin/bash
