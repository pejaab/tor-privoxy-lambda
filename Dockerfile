FROM alpine:latest
RUN apk update && apk add autoconf automake bash g++ libtool linux-headers make openssl-dev
COPY build-tor.sh /
RUN chmod u+x build-tor.sh
