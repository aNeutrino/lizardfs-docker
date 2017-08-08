# This is experimental/unstable Dockerfile
#
# TODO
#  - replace copy-paste with something sane
#  - add support for both Debian and Ubuntu

FROM ubuntu:19.04

# Install dependencies

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y wget apt-utils net-tools openssh-server

# Add repository
#
#RUN echo "deb [trusted=yes] file:/home/patryk/Documents/lizardfs-all/lizardfs-repo-local/ /" > /etc/apt/sources.list.d/lizardfs.list 

# Define mfsmaster in /etc/hosts

RUN echo "172.20.0.2 mfsmaster" >> /etc/hosts

# Install LizardFS client

RUN apt-get update && apt-get install -y lizardfs-client

# Allow password based login for root

RUN mkdir -p /var/run/sshd
RUN echo "root:mypasswd" | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Pass ENV variables to Dockerized SSHD service
#
# See: https://stackoverflow.com/questions/36292317/why-set-visible-now-in-etc-profile

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose ports without publishing them to the host machine - they’ll only be
# accessible to linked services
#
# See: https://docs.docker.com/compose/compose-file/#expose

EXPOSE 22

CMD mkdir -p /mnt/lizardfs && mfsmount -H lizardfs-master -o cacheexpirationtime=5000 -o mfswritecachesize=32 /mnt/lizardfs && /usr/sbin/sshd -D
