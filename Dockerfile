FROM centos:latest
MAINTAINER Administator email: czijonny@gmail.com

RUN yum install -y git make gcc

RUN git clone https://github.com/Mirkic7/mdcct.git
WORKDIR /mdcct
RUN make

WORKDIR /
COPY plot /
RUN chmod +x plot

ENTRYPOINT /bin/bash plot