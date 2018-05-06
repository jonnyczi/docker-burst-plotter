FROM centos:latest
MAINTAINER Administator email: czijonny@gmail.com

COPY plot /

RUN yum install -y git make gcc \
    && git clone https://github.com/Mirkic7/mdcct.git \
    && cd /mdcct \
    && make \
    && yum erase -y git make gcc \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && cd / \
    && chmod +x plot

ENTRYPOINT /bin/bash plot