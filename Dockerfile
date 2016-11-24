FROM centos:centos7

ENV LMOD_VER 7.0.5
MAINTAINER Robert Schmidt <rjeschmi@gmail.com>

RUN yum -y install git tar which bzip2 xz \
            epel-release make automake gcc gcc-c++ patch \
            python-keyring zlib-devel openssl-devel unzip iproute
RUN mkdir -p /build
WORKDIR /build
RUN curl -LO http://github.com/TACC/Lmod/archive/${LMOD_VER}.tar.gz
RUN mv /build/${LMOD_VER}.tar.gz /build/Lmod-${LMOD_VER}.tar.gz
RUN tar xvf Lmod-${LMOD_VER}.tar.gz

WORKDIR /build/Lmod-${LMOD_VER}

RUN yum -y install lua lua-devel lua-posix lua-filesystem tcl iproute

RUN ./configure --prefix=/easybuild/Lmod
RUN make install
RUN ln -s /easybuild/Lmod/lmod/lmod/init/profile /etc/profile.d/modules.sh
RUN ln -s /easybuild/Lmod/lmod/lmod/init/cshrc /etc/profile.d/modules.csh

CMD /bin/bash

