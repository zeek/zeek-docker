# bro
#
# VERSION               0.1

# Checkout and build Zeek
FROM debian:bullseye as builder
MAINTAINER Justin Azoff <justin.azoff@gmail.com>

ENV WD /scratch

RUN mkdir ${WD}
WORKDIR /scratch

RUN apt-get update && apt-get upgrade -y && echo 2021-03-01
RUN apt-get -y install build-essential git bison flex gawk cmake swig libssl-dev libmaxminddb-dev libpcap-dev python3.9-dev libcurl4-openssl-dev wget libncurses5-dev ca-certificates zlib1g-dev --no-install-recommends

ARG ZEEK_VER=4.2.0
ARG BUILD_TYPE=Release
ENV VER ${ZEEK_VER}
ADD ./common/buildbro ${WD}/common/buildbro
RUN ${WD}/common/buildbro zeek ${VER} ${BUILD_TYPE}

# For testing
ADD ./common/getmmdb.sh /usr/local/getmmdb.sh
ADD ./common/bro_profile.sh /usr/local/bro_profile.sh

# Get geoip data
FROM debian:bullseye as geogetter
ARG MAXMIND_LICENSE_KEY
RUN apt-get update && apt-get -y install wget ca-certificates --no-install-recommends

# For testing
#ADD ./common/getmmdb.sh /usr/local/bin/getmmdb.sh
COPY --from=builder /usr/local/getmmdb.sh /usr/local/bin/getmmdb.sh
RUN mkdir -p /usr/share/GeoIP
RUN /usr/local/bin/getmmdb.sh ${MAXMIND_LICENSE_KEY}
# This is a workaround for the case where getmmdb.sh does not create any files.
RUN touch /usr/share/GeoIP/.notempty

# Make final image
FROM debian:bullseye
ARG ZEEK_VER=4.2.0
ENV VER ${ZEEK_VER}
#install runtime dependencies
RUN apt-get update \
    && apt-get -y install --no-install-recommends libpcap0.8 libssl1.1 libmaxminddb0 python3.9-minimal \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/zeek-${VER} /usr/local/zeek-${VER}
COPY --from=geogetter /usr/share/GeoIP/* /usr/share/GeoIP/
RUN rm -f /usr/share/GeoIP/.notempty
RUN ln -s /usr/local/zeek-${VER} /bro
RUN ln -s /usr/local/zeek-${VER} /zeek

# For testing
#ADD ./common/bro_profile.sh /etc/profile.d/zeek.sh
COPY --from=builder /usr/local/bro_profile.sh /etc/profile.d/zeek.sh

env PATH /zeek/bin/:$PATH
CMD /bin/bash -l
