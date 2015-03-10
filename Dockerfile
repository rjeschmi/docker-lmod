FROM centos:centos6

MAINTAINER Robert Schmidt <rjeschmi@gmail.com>
RUN sed "s/enabled.*$/enabled=0/" -i /etc/yum/pluginconf.d/fastestmirror.conf
RUN sed "/^mirrorlist/s/^/#/" -i /etc/yum.repos.d/CentOS-Base.repo
RUN sed "/^#baseurl/s/^#//" -i /etc/yum.repos.d/CentOS-Base.repo
RUN useradd -m build

RUN yum -y install git tar which bzip2 xz \
            epel-release make automake gcc gcc-c++ patch
RUN mkdir -p /build
WORKDIR /build
RUN curl -LO http://github.com/TACC/Lmod/archive/5.8.tar.gz
RUN mv /build/5.8.tar.gz /build/Lmod-5.8.tar.gz
RUN tar xvf Lmod-5.8.tar.gz

WORKDIR /build/Lmod-5.8

RUN yum -y install lua lua-devel lua-posix lua-filesystem tcl

RUN ./configure --prefix=/software/Lmod
RUN make install
RUN ln -s /software/Lmod/lmod/lmod/init/profile /etc/profile.d/modules.sh
RUN ln -s /software/Lmod/lmod/lmod/init/cshrc /etc/profile.d/modules.csh



