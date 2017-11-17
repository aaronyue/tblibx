FROM centos:6.6

#依赖包的安装
COPY epel-6.repo /etc/yum.repos.d/epel.repo
RUN yum clean all && \
 yum install -y gcc.x86_64 gcc-c++.x86_64 make.x86_64 automake.noarch libtool.x86_64 readline-devel.x86_64 zlib-devel.x86_64 libuuid-devel.x86_64 gperftools-devel.x86_64 jemalloc-devel.x86_64 mysql-devel.x86_64 ncurses-devel.x86_64 boost-devel.x86_64 json-c-devel.x86_64 curl.x86_64 libcurl-devel.x86_64 snappy-devel.x86_64 subversion.x86_64 unzip.x86_64

#设置环境变量
ENV TBLIB_ROOT /opt/tb-common-utils
ENV TAIR_ROOT /opt/tair


RUN \
  mkdir -p ${TBLIB_ROOT} && \
  mkdir -p /opt/taobao && \
  cd /opt/taobao && \
  svn export -r 22 http://code.taobao.org/svn/tb-common-utils/trunk tb-common-utils && \
  sh tb-common-utils/build.sh && \
  rm -rf tb-common-utils && \
  cd /opt/taobao && \
  curl -L -O https://github.com/google/protobuf/releases/download/v3.5.0/protobuf-cpp-3.5.0.zip && unzip protobuf-cpp-3.5.0.zip && \
  rm -rf protobuf-cpp-3.5.0.zip && cd protobuf-3.5.0 && ./configure && make && make install && \
  rm -rf /opt/taobao/protobuf-3.5.0 && \
  cd /opt/taobao && \
  curl -L https://github.com/DengzhiLiu/tair/archive/master.zip >tair.zip && unzip tair.zip && \
  rm -rf tair.zip && cd /opt/taobao/tair-master && \
  sh bootstrap.sh && ./configure --prefix=${TAIR_ROOT} --with-release=yes && \
  make && make install && \
  cd /opt/taobao && rm -rf /opt/taobao/tair-master && \
  curl https://codeload.github.com/yinzhigang/tfs/zip/master > tfs.zip && \
  unzip tfs.zip && rm -rf tfs.zip && \
  cd /opt/taobao/tfs-master && \
  sh build.sh init && ./configure --prefix=/opt/tfs --with-tair-root=${TAIR_ROOT} --with-release=yes && \
  make && make install && \
  rm -rf /opt/taobao/tfs-master && \ 
  cd /