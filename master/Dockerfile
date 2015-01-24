# bro
#
# VERSION               0.1

FROM google/debian:wheezy
MAINTAINER Justin Azoff <justin.azoff@gmail.com>

ENV VER 2.3.1
ENV WD /scratch

RUN mkdir ${WD}
WORKDIR /scratch

RUN dpkg -l | awk '{print $2}' | sort > old.txt

RUN apt-get update && echo 2015-01-23
RUN apt-get -y install build-essential git bison flex gawk cmake swig libssl-dev libgeoip-dev libpcap-dev python-dev libcurl4-openssl-dev wget libncurses5-dev ca-certificates --no-install-recommends

#Checkout bro

# Build bro
RUN git clone --recursive git://git.bro.org/bro
ADD ./common/gitbro ${WD}/common/gitbro
RUN ${WD}/common/gitbro 4d0a09a0379206f0cacd0c8a8053c0d1070ca62b
RUN ln -s /usr/local/bro-master /bro

# Final setup stuff

ADD ./common/getgeo.sh /usr/local/bin/getgeo.sh
RUN /usr/local/bin/getgeo.sh

ADD ./common/bro_profile.sh /etc/profile.d/bro.sh

# Cleanup, so docker-squash can do it's thing

RUN dpkg -l | awk '{print $2}' | sort > new.txt
RUN apt-get -y remove --purge $(comm -13 old.txt  new.txt|grep -- -dev)
RUN apt-get -y remove --purge $(comm -13 old.txt  new.txt|grep -v lib|grep -v ca-certificates|grep -v wget)
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /scratch/*

CMD /bin/bash -l
