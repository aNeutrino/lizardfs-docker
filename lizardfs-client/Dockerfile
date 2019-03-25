ARG code_version=19.04
FROM ubuntu:${code_version}
LABEL maintainer="patryk.beza@lizardfs.com"

# Install dependencies

RUN rm /etc/dpkg/dpkg.cfg.d/excludes
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y iputils-ping wget vim apt-utils net-tools openssh-server

# Add repository
#
#RUN echo "deb [trusted=yes] file:/home/patryk/Documents/lizardfs-all/lizardfs-repo-local/ /" > /etc/apt/sources.list.d/lizardfs.list 

# Install LizardFS client

RUN apt-get update && apt-get install -y lizardfs-client

# Allow password based login for root

RUN mkdir -p /var/run/sshd
RUN echo "root:mypasswd" | chpasswd
RUN sed -i 's/#\{0,\}PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Expose ports without publishing them to the host machine - they’ll only be
# accessible to linked services
#
# See: https://docs.docker.com/compose/compose-file/#expose

EXPOSE 22

# Mount /mnt/lizardfs

CMD mkdir -p /mnt/lizardfs && mfsmount -H lizardfs-master -o cacheexpirationtime=5000 -o mfswritecachesize=32 /mnt/lizardfs && /usr/sbin/sshd -D
