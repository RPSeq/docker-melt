###################################################
# Dockerfile for MELT
###################################################

# Based on...
FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER Ryan Smith <ryan.smith.p@gmail.com>

# bootstrap dependencies
# Concatentating these command together will create only 1 docker image layer
# fewer image layers are better / smaller
# NOTE: ccdg stuff installs to /opt/
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https && \
    echo "deb [trusted=yes] https://gitlab.com/indraniel/ccdg-apt-repo/raw/master ccdg main" | tee -a /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get -y install \
    libnss-sss \
    ccdg-oracle-jdk-8u111 \
    unzip \
    git \
    --no-install-recommends && \
    apt-get clean all

# Add local melt and bowtie2 packages
COPY MELTv2.1.4.tar.gz /tmp/
COPY bowtie2-2.3.4-linux-x86_64.zip /tmp/

# Unpack and move to /opt/, clean up, make MELTER executable
RUN cd /tmp/ && \
    tar -xvf MELTv2.1.4.tar.gz && \
    mv MELTv2.1.4 /opt/ && \
    unzip bowtie2-2.3.4-linux-x86_64.zip && \
    mv bowtie2-2.3.4-linux-x86_64 /opt/ && \
    git clone https://github.com/RPSeq/MELTER && \
    mv MELTER/MELTER /opt/ && \
    rm -r /tmp/* && \
    chmod 755 /opt/MELTER

# Entrypoint is bash
ENTRYPOINT ["/bin/bash"]