# bro
#
# VERSION               0.1

FROM debian:jessie
MAINTAINER Justin Azoff <justin.azoff@gmail.com>

ENV WD /scratch

RUN mkdir ${WD}
WORKDIR /scratch

RUN dpkg -l | awk '{print $2}' | sort > old.txt

RUN apt-get update && apt-get upgrade -y && echo 2016-05-13
RUN apt-get -y install build-essential git bison flex gawk cmake swig libssl-dev libgeoip-dev libpcap-dev python-dev libcurl4-openssl-dev wget libncurses5-dev ca-certificates --no-install-recommends

#Checkout bro

# Build bro
RUN git clone --recursive git://git.bro.org/bro
ADD ./common/install-caf ${WD}/common/install-caf
ADD ./common/gitbro ${WD}/common/gitbro
RUN ${WD}/common/install-caf 0.14.4
RUN ${WD}/common/gitbro 49ca47895db45e03b9ab918292af6d525c42f94e
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

env PATH /bro/bin/:$PATH

CMD /bin/bash -l
