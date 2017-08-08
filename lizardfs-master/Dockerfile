# This is experimental/unstable Dockerfile
#
# TODO
#  - replace copy-paste with something sane
#  - add support for both Debian and Ubuntu

FROM ubuntu:19.04

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

ENV DEBIAN_FRONTEND noninteractive
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends wget apt-utils net-tools openssh-server

# Add repository
#
#RUN echo "deb [trusted=yes] file:/home/patryk/Documents/lizardfs-all/lizardfs-repo-local/ /" > /etc/apt/sources.list.d/lizardfs.list

# Install LizardFS master and CGI

RUN apt-get update && apt-get install -y lizardfs-master lizardfs-cgi*

# Expose ports without publishing them to the host machine - they’ll only be
# accessible to linked services
#
# See: https://docs.docker.com/compose/compose-file/#expose

EXPOSE 9420 9421 9422 9423 9424 9425 22

# Copy empty metadata.mfs

# TODO replace with COPY?
RUN cp "${var_lib_dir}/metadata.mfs.empty" "${var_lib_dir}/metadata.mfs"

# Copy sample configuration

RUN echo "****************** DEBUG ******************"
RUN dpkg -L lizardfs-master
RUN file "/usr/sbin/mfsmaster"
RUN file "/usr/sbin/mfsmetarestore"
RUN ls -la "${etc_config_dir}"
RUN file "/usr/share/doc/lizardfs-master/examples/mfsexports.cfg"
RUN echo "********************************************"
RUN cp "${example_config_dir}/mfsexports.cfg${example_ext}" "${etc_config_dir}/mfsexports.cfg"
RUN cp "${example_config_dir}/mfsmaster.cfg${example_ext}" "${etc_config_dir}/mfsmaster.cfg"
RUN echo "MASTER_HOST=lizardfs-master" >> "${etc_config_dir}/mfsmaster.cfg"

RUN sed -i "s/fals/tru/g" /etc/default/lizardfs-cgiserv
RUN sed -i "s/fals/tru/g" /etc/default/lizardfs-master
RUN echo "root:mypasswd" | chpasswd

# Allow password based login for root

RUN mkdir -p /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Pass ENV variables to Dockerized SSHD service
#
# See: https://stackoverflow.com/questions/36292317/why-set-visible-now-in-etc-profile

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD service lizardfs-cgiserv start && service lizardfs-master start && /usr/sbin/sshd -D
