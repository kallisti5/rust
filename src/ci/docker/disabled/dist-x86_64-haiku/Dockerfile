FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  g++ \
  make \
  file \
  curl \
  ca-certificates \
  python2.7 \
  git \
  cmake \
  sudo \
  bzip2 \
  xz-utils \
  wget \
  libssl-dev \
  pkg-config

# Install Haiku host-tools (Extract hpkg's, etc)
RUN wget http://download.haiku-os.org/host-tools/haiku_host_tools-02202017-linux-x86_64.tar.xz -O /tmp/host-tools.tar.xz
WORKDIR /usr/local
RUN tar xvf /tmp/host-tools.tar.xz
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/local-lib.conf
RUN ldconfig

# Build Haiku cross-compiler toolchain.
WORKDIR /tmp
COPY dist-x86_64-haiku/build-toolchain.sh /tmp/
RUN /tmp/build-toolchain.sh x86_64

COPY scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

ENV \
    AR_x86_64_unknown_haiku=x86_64-unknown-haiku-ar \
    CC_x86_64_unknown_haiku=x86_64-unknown-haiku-gcc \
    CXX_x86_64_unknown_haiku=x86_64-unknown-haiku-g++

ENV HOSTS=x86_64-unknown-haiku

ENV RUST_CONFIGURE_ARGS --host=$HOSTS --enable-extended
ENV SCRIPT python2.7 ../x.py dist --host $HOSTS --target $HOSTS
