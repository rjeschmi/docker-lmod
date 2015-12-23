FROM fedora:23

ENV LIBREPO_DEBUG 1 
ENV LMOD_VER 6.0.24
MAINTAINER Robert Schmidt <rjeschmi@gmail.com>
#RUN sed "s/enabled.*$/enabled=0/" -i /etc/yum/pluginconf.d/fastestmirror.conf
#RUN sed "/^mirrorlist/s/^/#/" -i /etc/yum.repos.d/CentOS-Base.repo
#RUN sed "/^#baseurl/s/^#//" -i /etc/yum.repos.d/CentOS-Base.repo
RUN dnf makecache
RUN dnf --setopt=deltarpm=false -y install -v git tar which bzip2 xz \
            make automake gcc gcc-c++ patch \
            python-keyring zlib-devel openssl-devel unzip procps
RUN mkdir -p /build
WORKDIR /build
RUN curl -LO http://github.com/TACC/Lmod/archive/${LMOD_VER}.tar.gz
RUN mv /build/${LMOD_VER}.tar.gz /build/Lmod-${LMOD_VER}.tar.gz
RUN tar xvf Lmod-${LMOD_VER}.tar.gz

WORKDIR /build/Lmod-${LMOD_VER}

RUN dnf --setopt=deltarpm=false -y install lua lua-devel lua-posix lua-filesystem tcl

RUN ./configure --prefix=/software/Lmod
RUN make install
RUN ln -s /software/Lmod/lmod/lmod/init/profile /etc/profile.d/modules.sh
RUN ln -s /software/Lmod/lmod/lmod/init/cshrc /etc/profile.d/modules.csh

CMD /bin/bash

