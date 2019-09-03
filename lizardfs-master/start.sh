#!/usr/bin/env bash

example_config_dir="/usr/share/doc/lizardfs-master/examples"
etc_config_dir="/etc/lizardfs"
var_lib_dir="/var/lib/lizardfs"

# Solve this problem: https://github.com/phusion/baseimage-docker/issues/319

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install LizardFS master and CGI

apt-get update
apt-get install -y lizardfs-master lizardfs-cgi lizardfs-cgiserv

# Copy empty metadata.mfs

cp "${var_lib_dir}/metadata.mfs.empty" "${var_lib_dir}/metadata.mfs"

# Copy sample configuration
#
# Note: By default, dh_compress compresses files that Debian policy mandates
# should be compressed, namely all files in usr/share/info, usr/share/man,
# files in usr/share/doc that are larger than 4k in size (...)
# (Source: https://manpages.debian.org/jessie/debhelper/dh_compress.1.en.html)

gzip_extension=".gz"
mfsexports_config_fname="mfsexports.cfg"
mfsexports_example_config="${example_config_dir}/${mfsexports_config_fname}"
mfsexports_example_config_gzip="${mfsexports_example_config}${gzip_extension}"
mfsexports_etc_config="${etc_config_dir}/${mfsexports_config_fname}"
if [ -f "${mfsexports_example_config_gzip}" ]; then
    zcat "${mfsexports_example_config_gzip}" > "${mfsexports_etc_config}"
else
    cp "${mfsexports_example_config}" "${mfsexports_etc_config}"
fi

mfsmaster_config_fname="mfsmaster.cfg"
mfsmaster_example_config="${example_config_dir}/${mfsmaster_config_fname}"
mfsmaster_example_config_gzip="${mfsmaster_example_config}${gzip_extension}"
mfsmaster_etc_config="${etc_config_dir}/${mfsmaster_config_fname}"
if [ -f "${mfsmaster_example_config_gzip}" ]; then
    zcat "${mfsmaster_example_config_gzip}" > "${mfsmaster_example_config}"
else
    cp "${mfsmaster_example_config}" "${mfsmaster_etc_config}"
fi

echo "MASTER_HOST=lizardfs-master" >> "${mfsmaster_etc_config}"

# Ubuntu/Debian specific

sed -i "s/fals/tru/g" /etc/default/lizardfs-cgiserv
sed -i "s/fals/tru/g" /etc/default/lizardfs-master

service lizardfs-cgiserv start
service lizardfs-master start

/bin/bash
