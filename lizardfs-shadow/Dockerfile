ARG code_version=19.04
FROM ubuntu:${code_version}
LABEL maintainer="patryk.beza@lizardfs.com"

# Without below line sample LizardFS configuration is not installed
# TODO temporarily not needed since LizardFS is installed by CMD (not RUN)
#
#RUN rm /etc/dpkg/dpkg.cfg.d/excludes

# Install dependencies

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y iputils-ping wget vim apt-utils net-tools

# Expose ports without publishing them to the host machine - they’ll only be
# accessible to linked services
#
# See: https://docs.docker.com/compose/compose-file/#expose

EXPOSE 9420 9421 9422 9423 9424 9425

# Add root user with mypasswd

RUN echo "root:mypasswd" | chpasswd

# Add local repo for development purposes; comment it out if you want to
# install LizardFS from official repository

COPY lizardfs-dev.list /etc/apt/sources.list.d

# Install LizardFS master and CGI and start their services.
#
# Note that installing LizardFS is not done with RUN (container build time) but
# CMD (container run time) because of .deb packages are located in host's local
# repository which is on the /share volume. Volumes are not visible during
# build time.

COPY start.sh /home/start.sh
RUN chown root:root /home/start.sh
RUN chmod 700 /home/start.sh

CMD ["/home/start.sh"]
