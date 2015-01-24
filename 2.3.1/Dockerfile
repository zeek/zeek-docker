# bro
#
# VERSION               0.1
FROM bro:build

ENV VER 2.3.1
ENV WD /workspace

MAINTAINER Justin Azoff <justin.azoff@gmail.com>

RUN mkdir ${WD}

WORKDIR /workspace

ADD ./common/buildbro ${WD}/common/buildbro
RUN ${WD}/common/buildbro ${VER} http://www.bro.org/downloads/release/bro-${VER}.tar.gz

ADD ./inner ${WD}/inner
ADD ./common ${WD}/inner/common

RUN mv /usr/local/bro-${VER} ${WD}/inner/
CMD docker build -t bro:2.3.1 /workspace/inner/
