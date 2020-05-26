#!/usr/bin/env bash

docker build . -t build-tor
docker run \
  -v `pwd`/tor:/opt/src/tor \
  -v `pwd`/libevent:/opt/src/libevent \
  -v `pwd`/openssl:/opt/src/openssl \
  -v `pwd`/zlib:/opt/src/zlib \
  -v `pwd`/output:/opt/output \
  -it build-tor /build-tor.sh
