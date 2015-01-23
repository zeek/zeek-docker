# bro
#
# VERSION               0.1
FROM bro:build

ENV VER = 2.3.1

MAINTAINER Justin Azoff <justin.azoff@gmail.com>

ADD ../common/buildbro ./buildbro
RUN ./buildbro ${VER} http://www.bro.org/downloads/release/bro-${VER}.tar.gz
RUN ln -s /usr/local/bro-${VER} /bro
ADD ../common/bro_profile.sh /etc/profile.d/bro.sh

ADD getgeo.sh /getgeo.sh
RUN /getgeo.sh

ADD ./inner
CMD docker build -t bro:2.3.1 inner/
