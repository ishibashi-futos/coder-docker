FROM centos:7.6.1810

ENV CODER_VARSION 1.1140-vsc1.33.1

# install lib
RUN yum groupinstall -y "Development Tools" \
 && yum install -y kernel-devel \
        kernel-headers \
        gmp-devel \
        mpfr-devel \
        libmpc-devel \
        glibc-devel.i686 \
        bzip2 \
 && wget -qL http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-8.3.0/gcc-8.3.0.tar.gz -O - | tar zxvf - -C /tmp/ --strip=1 \
 && cd /tmp/ \
 && ./contrib/download_prerequisites \
 && mkdir build/ && cd build \
 && ../configure --enable-languages=c,c++ --prefix=/usr/local --disable-bootstrap --disable-multilib \
 && make && make install && cd / && rm -rf /tmp/**

# install coder.
WORKDIR /coder/
RUN mkdir bin/ \
 && wget -qL https://github.com/cdr/code-server/releases/download/${CODER_VERSION}/code-server${CODER_VERSION}-linux-x64.tar.gz -O - | tar zxvf - -C bin/ --strip=1
