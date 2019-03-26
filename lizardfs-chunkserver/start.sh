#!/usr/bin/env bash

# Variables for build from Ubuntu/Debian repo
#
#example_chunkserver_config_ext=".gz"
#example_config_dir="/usr/share/doc/lizardfs-chunkserver/examples"
#etc_config_dir="/etc/lizardfs"
#var_lib_dir="/var/lib/lizardfs"
#lizardfs_user="lizardfs"

# Variables for custom/manual build

example_chunkserver_config_ext=".dist"
example_config_dir="/etc/mfs"
etc_config_dir="/etc/mfs"
var_lib_dir="/var/lib/mfs"
lizardfs_user="mfs"

# Install LizardFS chunkserver

apt-get update
apt-get install -y lizardfs-chunkserver

# Copy sample mfschunkserver.cfg.dist configuration file and customize it

cp "${example_config_dir}/mfschunkserver.cfg${example_chunkserver_config_ext}" "${etc_config_dir}/mfschunkserver.cfg"

# Needed only if installed from official Ubuntu/Debian repo
#
#zcat "${etc_config_dir}/mfschunkserver.cfg" > "${etc_config_dir}/mfschunkserver.cfg.unzipped"

# Appending to gzipped config? Why? TODO FIXME
#RUN echo "MASTER_HOST=lizardfs-master" >> "${etc_config_dir}/mfschunkserver.cfg"

# Setup mfshdd.cfg

mkdir -p /mnt/sdb1
chown -R "${lizardfs_user}:${lizardfs_user}" /mnt/sdb1
echo "/mnt/sdb1" >> "${etc_config_dir}/mfshdd.cfg"

# Setup mfschunkserver.cfg and /etc/default/lizardfs-chunkserver

sed -i '/# LABEL = _/c\LABEL = docker' "${etc_config_dir}/mfschunkserver.cfg"

# Ubuntu/Debian specific

sed -i "s/fals/tru/g" /etc/default/lizardfs-chunkserver

service lizardfs-chunkserver start

/bin/bash
