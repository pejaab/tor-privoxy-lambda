FROM amazonlinux:latest
RUN yum update -y && yum install -y automake gcc glibc-static gzip libtool make pkgconfig
COPY build-tor.sh /
RUN chmod u+x build-tor.sh
