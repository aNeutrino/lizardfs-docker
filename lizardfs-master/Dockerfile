ARG code_version=19.04
FROM ubuntu:${code_version}
LABEL maintainer="patryk.beza@lizardfs.com"

# Variables for build from Ubuntu/Debian repo

ARG example_ext=""
ARG example_config_dir="/usr/share/doc/lizardfs-master/examples"
ARG etc_config_dir="/etc/lizardfs"
ARG var_lib_dir="/var/lib/lizardfs"

# Variables for custom/manual build
#
#ARG example_ext=".dist"
#ARG example_config_dir="/etc/mfs"
#ARG etc_config_dir="/etc/mfs"
#ARG var_lib_dir="/var/lib/mfs"

# Install dependencies

RUN rm /etc/dpkg/dpkg.cfg.d/excludes
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y iputils-ping wget vim apt-utils net-tools openssh-server

# Add repository
#
#RUN echo "deb [trusted=yes] file:/home/patryk/Documents/lizardfs-all/lizardfs-repo-local/ /" > /etc/apt/sources.list.d/lizardfs.list

# Install LizardFS master and CGI

RUN apt-get update && apt-get install -y lizardfs-master lizardfs-cgi lizardfs-cgiserv

# Expose ports without publishing them to the host machine - they’ll only be
# accessible to linked services
#
# See: https://docs.docker.com/compose/compose-file/#expose

EXPOSE 9420 9421 9422 9423 9424 9425 22

# Copy empty metadata.mfs

RUN cp "${var_lib_dir}/metadata.mfs.empty" "${var_lib_dir}/metadata.mfs"

# Copy sample configuration

RUN cp "${example_config_dir}/mfsexports.cfg${example_ext}" "${etc_config_dir}/mfsexports.cfg"
RUN cp "${example_config_dir}/mfsmaster.cfg${example_ext}" "${etc_config_dir}/mfsmaster.cfg"
RUN echo "MASTER_HOST=lizardfs-master" >> "${etc_config_dir}/mfsmaster.cfg"

#RUN sed -i "s/fals/tru/g" /etc/default/lizardfs-cgiserv
#RUN sed -i "s/fals/tru/g" /etc/default/lizardfs-master
RUN echo "root:mypasswd" | chpasswd

# Allow password based login for root

RUN mkdir -p /var/run/sshd
RUN sed -i 's/#\{0,\}PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Pass ENV variables to Dockerized SSHD service
#
# See: https://stackoverflow.com/questions/36292317/why-set-visible-now-in-etc-profile

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD service lizardfs-cgiserv start && service lizardfs-master start && /usr/sbin/sshd -D
