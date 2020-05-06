FROM centos:centos6

ENV LMOD_VER 8.3.9
MAINTAINER Robert Schmidt <rjeschmi@gmail.com>
RUN sed "s/enabled.*$/enabled=0/" -i /etc/yum/pluginconf.d/fastestmirror.conf
RUN sed "/^mirrorlist/s/^/#/" -i /etc/yum.repos.d/CentOS-Base.repo
RUN sed "/^#baseurl/s/^#//" -i /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y install git tar which bzip2 xz \
            epel-release make automake gcc gcc-c++ patch \
            python-keyring zlib-devel openssl-devel unzip 
RUN mkdir -p /build
WORKDIR /build
RUN curl -LO https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
RUN tar xvf lua-5.1.4.9.tar.bz2
WORKDIR /build/lua-5.1.4.9
RUN ./configure --prefix=/software/lua --with-static=yes && make install

ENV PATH="/software/lua/bin:${PATH}"

WORKDIR /build
RUN curl -LO https://luarocks.org/releases/luarocks-3.3.1.tar.gz
RUN tar xvf luarocks-3.3.1.tar.gz
WORKDIR /build/luarocks-3.3.1
RUN ./configure --prefix=/software/luarocks && make && make install
ENV PATH="/software/luarocks/bin:${PATH}"
ENV LUA_PATH='/software/luarocks/share/lua/5.1/?.lua;./?.lua;/software/lua/share/lua/5.1/?.lua;/software/lua/share/lua/5.1/?/init.lua;/software/lua/lib/lua/5.1/?.lua;/software/lua/lib/lua/5.1/?/init.lua;/software/luarocks/share/lua/5.1/?/init.lua'
ENV LUA_CPATH='./?.so;/software/lua/lib/lua/5.1/?.so;/software/lua/lib/lua/5.1/loadall.so;/software/luarocks/lib/lua/5.1/?.so'

WORKDIR /build
RUN curl -LO https://sourceforge.net/projects/tcl/files/Tcl/8.6.10/tcl8.6.10-src.tar.gz
RUN tar xvf tcl8.6.10-src.tar.gz
WORKDIR /build/tcl8.6.10/unix

RUN ./configure --prefix=/software/tcl && make install && ln -s /software/tcl/bin/tclsh8.6 /software/tcl/bin/tclsh

WORKDIR /build
RUN curl -LO http://github.com/TACC/Lmod/archive/${LMOD_VER}.tar.gz
RUN mv /build/${LMOD_VER}.tar.gz /build/Lmod-${LMOD_VER}.tar.gz
RUN tar xvf Lmod-${LMOD_VER}.tar.gz

WORKDIR /build/Lmod-${LMOD_VER}
ENV CPATH=/software/tcl/include
ENV LIBRARY_PATH=/software/tcl/lib
ENV PATH="/software/tcl/bin:${PATH}"
RUN ./configure --prefix=/software
RUN make -C pkgs/tcl2lua LUA_INC=/software/lua/include DIR=/software/tcl/include LIBS="-L/software/tcl/lib -Wl,-rpath,/software/tcl/lib -ltcl8.6"
RUN make install
RUN ln -s /software/Lmod/lmod/lmod/init/profile /etc/profile.d/modules.sh
RUN ln -s /software/Lmod/lmod/lmod/init/cshrc /etc/profile.d/modules.csh



