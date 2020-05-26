#!/usr/bin/env bash

pushd /opt/src/openssl
./config no-shared --prefix=/opt/openssl --openssldir=/opt/openssl
make -j8
make install
popd

# https://github.com/openssl/openssl/issues/3993

#echo "/opt/openssl/lib" > /etc/ld.so.conf
#ldconfig

pushd /opt/src/libevent
export PKG_CONFIG_PATH=/opt/openssl/lib/pkgconfig
export LDFLAGS='-ldl'
./autogen.sh
./configure --prefix=/opt/libevent
make -j8
make install
popd

pushd /opt/src/zlib
./configure
make -j8
popd

# https://gitlab.torproject.org/ahf-admin/legacy-20/issues/27802
pushd /opt/src/tor
./autogen.sh
./configure \
  --enable-static-libevent --with-libevent-dir=/opt/libevent \
  --enable-static-openssl --with-openssl-dir=/opt/openssl \
  --enable-static-zlib --with-zlib-dir=/opt/src/zlib \
  --disable-asciidoc
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
