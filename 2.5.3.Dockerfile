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
ENV VER 2.5.3
#ADD ./common/install-caf ${WD}/common/install-caf
#RUN ${WD}/common/install-caf 0.14.4
ADD ./common/buildbro ${WD}/common/buildbro
RUN ${WD}/common/buildbro ${VER} http://www.bro.org/downloads/bro-${VER}.tar.gz

# get geoip data

FROM debian:stretch as geogetter
RUN apt-get update && apt-get -y install wget ca-certificates --no-install-recommends
ADD ./common/getgeo.sh /usr/local/bin/getgeo.sh
RUN /usr/local/bin/getgeo.sh


# Make final image
FROM debian:stretch
ENV VER 2.5.3
#install runtime dependencies
RUN apt-get update \
    && apt-get -y install --no-install-recommends libpcap0.8 libssl1.0.2 libgeoip1 python2.7-minimal \
    && apt-get clean

COPY --from=builder /usr/local/bro-${VER} /usr/local/bro-${VER}
COPY --from=geogetter /usr/share/GeoIP/* /usr/share/GeoIP/
RUN ln -s /usr/local/bro-${VER} /bro
ADD ./common/bro_profile.sh /etc/profile.d/bro.sh

env PATH /bro/bin/:$PATH
CMD /bin/bash -l
