#!/usr/bin/env bash

# Variables for build from Ubuntu/Debian repo
#
#example_ext=""
#example_config_dir="/usr/share/doc/lizardfs-master/examples"
#etc_config_dir="/etc/lizardfs"
#var_lib_dir="/var/lib/lizardfs"

# Variables for custom/manual build

example_ext=".dist"
example_config_dir="/etc/mfs"
etc_config_dir="/etc/mfs"
var_lib_dir="/var/lib/mfs"

# Install LizardFS master and CGI

apt-get update
apt-get install -y lizardfs-master lizardfs-cgi lizardfs-cgiserv

# Copy empty metadata.mfs

cp "${var_lib_dir}/metadata.mfs.empty" "${var_lib_dir}/metadata.mfs"

# Copy sample configuration

cp "${example_config_dir}/mfsexports.cfg${example_ext}" "${etc_config_dir}/mfsexports.cfg"
cp "${example_config_dir}/mfsmaster.cfg${example_ext}" "${etc_config_dir}/mfsmaster.cfg"
echo "MASTER_HOST=lizardfs-master" >> "${etc_config_dir}/mfsmaster.cfg"
echo "PERSONALITY=shadow" >> "${etc_config_dir}/mfsmaster.cfg"

# Ubuntu/Debian specific

sed -i "s/fals/tru/g" /etc/default/lizardfs-cgiserv
sed -i "s/fals/tru/g" /etc/default/lizardfs-master

service lizardfs-cgiserv start
service lizardfs-master start

/bin/bash
