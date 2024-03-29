FROM centos:7.6.1810

ENV CODER_VERSION 1.1140-vsc1.33.1

# install lib
RUN yum groupinstall -y -q "Development Tools" \
 && yum install -y -q kernel-devel \
        kernel-headers \
        gmp-devel \
        mpfr-devel \
        libmpc-devel \
        glibc-devel.i686 \
        bzip2 \
        wget \
        openssl \
 && wget -qL http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-8.3.0/gcc-8.3.0.tar.gz -O - | tar zxf - -C /tmp/ --strip=1 \
 && cd /tmp/ \
 && ./contrib/download_prerequisites \
 && mkdir build/ && cd build/ \
 && ../configure --enable-languages=c,c++ --prefix=/usr/local --disable-bootstrap --disable-multilib --silent \
 && make > /dev/null 2>&1 && make install > /dev/null 2>&1 && cd / && rm -rf /tmp/** \
 && echo /usr/local/lib64 >> /etc/ld.so.conf.d/usr_local_lib64.conf \
 && mv /usr/local/lib64/libstdc++.so.6.0.25-gdb.py  /usr/local/lib64/back_libstdc++.so.6.0.25-gdb.py \
 && ldconfig 

# install coder.
RUN mkdir -p /coder/project /coder/bin/ ~/.code-server/User/workspaceStorage
WORKDIR /coder
RUN wget -qL https://github.com/cdr/code-server/releases/download/${CODER_VERSION}/code-server${CODER_VERSION}-linux-x64.tar.gz -O - | tar zxvf - -C bin/ --strip=1 

WORKDIR /coder/project
EXPOSE 8443

ENTRYPOINT ["dumb-init", "/coder/bin/code-server"]
