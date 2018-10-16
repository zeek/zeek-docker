# bro
#
# VERSION               0.1

FROM debian:stretch as builder
MAINTAINER Justin Azoff <justin.azoff@gmail.com>

ENV WD /scratch

RUN mkdir ${WD}
WORKDIR /scratch

RUN apt-get update && apt-get upgrade -y && echo 2019-09-21
RUN apt-get -y install build-essential git bison flex gawk cmake swig libssl1.0-dev libmaxminddb-dev libpcap-dev python-dev libcurl4-openssl-dev wget libncurses5-dev ca-certificates zlib1g-dev --no-install-recommends

#Checkout bro

# Build bro
RUN git clone --recursive git://git.bro.org/bro
ADD ./common/gitbro ${WD}/common/gitbro
RUN ${WD}/common/gitbro f7da111d1cab58dd1ad7ee421d321a5e7f0eb9ab
RUN ln -s /usr/local/bro-master /bro


# get geoip data

FROM debian:stretch as geogetter
RUN apt-get update && apt-get -y install wget ca-certificates --no-install-recommends
ADD ./common/getmmdb.sh /usr/local/bin/getmmdb.sh
RUN /usr/local/bin/getmmdb.sh


# Make final image
FROM debian:stretch
ENV VER master
#install runtime dependencies
RUN apt-get update \
    && apt-get -y install --no-install-recommends libpcap0.8 libssl1.0.2 libmaxminddb0 python2.7-minimal \
    python2.7-minimal python-pip python-setuptools python-wheel git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bro-${VER} /usr/local/bro-master
COPY --from=geogetter /usr/share/GeoIP/* /usr/share/GeoIP/
RUN ln -s /usr/local/bro-${VER} /bro
ADD ./common/bro_profile.sh /etc/profile.d/bro.sh

env PATH /bro/bin/:$PATH

#install bro-pkg
RUN pip install bro-pkg
RUN bro-pkg autoconfig

CMD /bin/bash -l
