# bro
#
# VERSION               0.1

FROM debian:stretch as builder
MAINTAINER Justin Azoff <justin.azoff@gmail.com>

ENV WD /scratch

RUN mkdir ${WD}
WORKDIR /scratch

RUN apt-get update && apt-get upgrade -y && echo 2018-03-02
RUN apt-get -y install build-essential git bison flex gawk cmake swig libssl1.0-dev libgeoip-dev libpcap-dev python-dev libcurl4-openssl-dev wget libncurses5-dev ca-certificates zlib1g-dev --no-install-recommends

#Checkout bro

# Build bro
RUN git clone --recursive git://git.bro.org/bro
#ADD ./common/install-caf ${WD}/common/install-caf
ADD ./common/gitbro ${WD}/common/gitbro
#RUN ${WD}/common/install-caf 0.14.4
RUN ${WD}/common/gitbro 01a96239e11ce478b2b58e4d1a51fc0a0f3ee1b7
RUN ln -s /usr/local/bro-master /bro


# get geoip data

FROM debian:stretch as geogetter
RUN apt-get update && apt-get -y install wget ca-certificates --no-install-recommends
ADD ./common/getgeo.sh /usr/local/bin/getgeo.sh
RUN /usr/local/bin/getgeo.sh


# Make final image
FROM debian:stretch
ENV VER master
#install runtime dependencies
RUN apt-get update \
    && apt-get -y install --no-install-recommends libpcap0.8 libssl1.0.2 libgeoip1 python2.7-minimal \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bro-${VER} /usr/local/bro-master
COPY --from=geogetter /usr/share/GeoIP/* /usr/share/GeoIP/
RUN ln -s /usr/local/bro-${VER} /bro
ADD ./common/bro_profile.sh /etc/profile.d/bro.sh

env PATH /bro/bin/:$PATH
CMD /bin/bash -l
