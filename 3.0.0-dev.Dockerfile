# bro
#
# VERSION               0.1

FROM debian:stretch as builder
MAINTAINER Justin Azoff <justin.azoff@gmail.com>

ENV WD /scratch

RUN mkdir ${WD}
WORKDIR /scratch

RUN apt-get update && apt-get upgrade -y && echo 2018-03-02
RUN apt-get -y install build-essential git bison flex gawk cmake swig libssl1.0-dev libmaxminddb-dev libpcap-dev python-dev libcurl4-openssl-dev wget libncurses5-dev ca-certificates zlib1g-dev --no-install-recommends

#Checkout bro

# Build bro
ENV VER 3.0.0
ADD ./common/buildbro ${WD}/common/buildbro
RUN ${WD}/common/buildbro zeek ${VER} Debug

# get geoip data

FROM debian:stretch as geogetter
RUN apt-get update && apt-get -y install wget ca-certificates --no-install-recommends
ADD ./common/getmmdb.sh /usr/local/bin/getmmdb.sh
RUN /usr/local/bin/getmmdb.sh


# Make final image
FROM debian:stretch
ENV VER 3.0.0
ENV PATH /zeek/bin/:$PATH
#install runtime dependencies
RUN apt-get update \
    && apt-get -y install --no-install-recommends libpcap0.8 libssl1.0.2 libmaxminddb0 \
    python2.7-minimal python-pip python-setuptools python-wheel git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/zeek-${VER} /usr/src/zeek-${VER}
COPY --from=builder /usr/local/zeek-${VER} /usr/local/zeek-${VER}
COPY --from=geogetter /usr/share/GeoIP/* /usr/share/GeoIP/
RUN ln -s /usr/local/zeek-${VER} /bro
RUN ln -s /usr/local/zeek-${VER} /zeek
ADD ./common/bro_profile.sh /etc/profile.d/zeek.sh

#install bro-pkg
RUN pip install bro-pkg
RUN bro-pkg autoconfig

CMD /bin/bash -l
