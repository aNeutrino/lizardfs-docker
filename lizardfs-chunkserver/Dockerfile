ARG code_version=19.04
FROM ubuntu:${code_version}
LABEL maintainer="patryk.beza@lizardfs.com"

# Variables for build from Ubuntu/Debian repo

ARG example_chunkserver_config_ext=".gz"
ARG example_config_dir="/usr/share/doc/lizardfs-chunkserver/examples"
ARG etc_config_dir="/etc/lizardfs"
ARG var_lib_dir="/var/lib/lizardfs"
ARG lizardfs_user="lizardfs"

# Variables for custom/manual build
#
#ARG example_chunkserver_config_ext=".dist"
#ARG example_config_dir="/etc/mfs"
#ARG etc_config_dir="/etc/mfs"
#ARG var_lib_dir="/var/lib/mfs"
#ARG lizardfs_user="mfs"

# Install dependencies

RUN rm /etc/dpkg/dpkg.cfg.d/excludes
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y iputils-ping wget vim apt-utils net-tools openssh-server

# Add repository
#
#RUN echo "deb [trusted=yes] file:/home/patryk/Documents/lizardfs-all/lizardfs-repo-local/ /" > /etc/apt/sources.list.d/lizardfs.list

# Install LizardFS chunkserver

RUN apt-get update && apt-get install -y lizardfs-chunkserver

# Expose ports without publishing them to the host machine - they’ll only be
# accessible to linked services
#
# See: https://docs.docker.com/compose/compose-file/#expose

EXPOSE 9419 9420 9422 22

# Copy sample mfschunkserver.cfg.dist configuration file and customize it

RUN cp "${example_config_dir}/mfschunkserver.cfg${example_chunkserver_config_ext}" "${etc_config_dir}/mfschunkserver.cfg"
RUN zcat "${etc_config_dir}/mfschunkserver.cfg" > "${etc_config_dir}/mfschunkserver.cfg.unzipped"
# Appending to gzipped config? Why? TODO FIXME
#RUN echo "MASTER_HOST=lizardfs-master" >> "${etc_config_dir}/mfschunkserver.cfg"

# Setup mfshdd.cfg

RUN mkdir -p /mnt/sdb1
RUN chown -R "${lizardfs_user}:${lizardfs_user}" /mnt/sdb1
RUN echo "/mnt/sdb1" >> "${etc_config_dir}/mfshdd.cfg"

# Setup mfschunkserver.cfg and /etc/default/lizardfs-chunkserver

RUN sed -i '/# LABEL = _/c\LABEL = docker' "${etc_config_dir}/mfschunkserver.cfg"
#RUN sed -i "s/fals/tru/g" /etc/default/lizardfs-chunkserver
RUN echo "root:mypasswd" | chpasswd

# Allow password based login for root

RUN mkdir -p /var/run/sshd
RUN sed -i 's/#\{0,\}PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Start lizardfs-chunkserver service

CMD service lizardfs-chunkserver start && /usr/sbin/sshd -D
