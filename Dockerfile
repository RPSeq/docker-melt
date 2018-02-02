###################################################
# Dockerfile for MELT
###################################################

# Based on... (ubuntu v14 and above have JRE 8 package)
FROM ubuntu:16.04

# File Author / Maintainer
MAINTAINER Ryan Smith <ryan.smith.p@gmail.com>

# Install dependencies
RUN apt-get update && \
    apt-get -y install \
    libnss-sss \
    openjdk-8-jre \
    unzip \
    --no-install-recommends && \
    apt-get clean all

# Add melt and bowtie (ADD unarchives tarball but not .zip)
ADD MELTv2.1.4.tar.gz /opt/
ADD bowtie2-2.3.4-linux-x86_64.zip /opt/

# Unzip bowtie and rm unnecessary data included with MELT
RUN cd /opt/ && \
    unzip bowtie2-2.3.4-linux-x86_64.zip && \
    rm bowtie2-2.3.4-linux-x86_64.zip && \
    rm -r MELTv2.1.4/add_bed_files && \
    rm -r MELTv2.1.4/me_refs && \
    rm -r MELTv2.1.4/prior_files

# add tools to path
ENV PATH "/opt/bowtie2-2.3.4-linux-x86_64:${PATH}"

# Interactive bash by default
CMD ["/bin/bash"]