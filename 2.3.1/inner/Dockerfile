# bro
#
# VERSION               0.1
FROM google/debian:wheezy

ENV VER 2.3.1

MAINTAINER Justin Azoff <justin.azoff@gmail.com>

WORKDIR /workspace

ADD bro-${VER} /usr/local/bro-${VER}
RUN ln -s /usr/local/bro-${VER} /bro

ADD ./common/bro_profile.sh /etc/profile.d/bro.sh

RUN apt-get update && \
    apt-get -y install wget libgeoip1 libpcap0.8 libcurl3 && \
    rm -r /var/lib/apt/lists/* /var/cache/apt/archives/*

ADD ./common/getgeo.sh /usr/local/bin/getgeo.sh
RUN /usr/local/bin/getgeo.sh

CMD /bin/bash -l
