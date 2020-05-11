#!/usr/bin/env bash

pushd /opt/src/libevent
./autogen.sh
./configure
make
make -j8 install
popd

pushd /opt/src/openssl
./config
make -j8
popd

pushd /opt/src/zlib
./configure
make -j8
popd

pushd /opt/src/tor
./autogen.sh
./configure \
  --enable-static-tor \
  --enable-static-libevent --with-libevent-dir=/usr/local/lib \
  --enable-static-openssl --with-openssl-dir=/opt/src/openssl
  --enable-static-zlib --with-zlib-dir=/usr/local/lib
make -j8
rm -rf /opt/output/bin
mkdir -p /opt/output/bin
cp src/app/tor /opt/output/bin
popd

pushd /opt/src
wget https://www.privoxy.org/sf-download-mirror/Sources/3.0.28%20%28stable%29/privoxy-3.0.28-stable-src.tar.gz -O privoxy.tar.gz
mkdir privoxy
tar xzfv privoxy.tar.gz -C privoxy --strip-components 1
popd

pushd /opt/src/privoxy
autoheader
autoconf
./configure
make
make install
cp /usr/local/sbin/privoxy /opt/output/bin
cp /usr/local/etc/privoxy /opt/output/
popd

exit 0
