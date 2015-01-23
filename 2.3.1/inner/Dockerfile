# bro
#
# VERSION               0.1
FROM google/debian:wheezy

ENV VER = 2.3.1

MAINTAINER Justin Azoff <justin.azoff@gmail.com>

ADD /usr/local/bro-${VER} /usr/local/bro-${VER}
RUN ln -s /usr/local/bro-${VER} /bro
ADD /etc/profile.c/bro.sh /etc/profile.d/bro.sh
ADD /usr/share/GeoIP /usr/share/GeoIP
