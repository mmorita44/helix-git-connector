FROM ubuntu:xenial
MAINTAINER Masato Morita <m.morita44@hotmail.com>

# Add the perforce public key
ADD https://package.perforce.com/perforce.pubkey /tmp/perforce.pubkey

# Define valiables
ARG HELIX_VERSION=2017.1-1512253~xenial

# Set environment variables
ENV P4PORT perforce:1666
ENV P4USER p4admin
ENV P4PASSWD p4admin@123
ENV GCUSERP4PASSW gconn-user
ENV GRAPHDEPOT git 

# Add the perforce apt key
RUN apt-key add /tmp/perforce.pubkey && \
    echo "deb http://package.perforce.com/apt/ubuntu $(sed -n 's/^DISTRIB_CODENAME=\(.*\)$/\1/p' /etc/lsb-release) release" > /etc/apt/sources.list.d/perforce.list && \
    rm /tmp/*

# Install git connector and openssh-server
RUN apt-get update && \
    apt-get install -y helix-git-connector=${HELIX_VERSION}

# Expose default HTTPS port
EXPOSE 443

# Add a startup file
ADD ./run.sh /

# Run the file
CMD ["/run.sh"]
