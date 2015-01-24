#!/bin/sh -e 
echo "2015-01-23"

mkdir -p /usr/share/GeoIP/

wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
zcat GeoLiteCity.dat.gz > GeoIP.dat.new
mv GeoIP.dat.new /usr/share/GeoIP/GeoIPCity.dat
rm GeoLiteCity.dat.gz

wget -N http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
zcat GeoLiteCityv6.dat.gz > GeoIPCityv6.dat
mv GeoIPCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat
rm GeoLiteCityv6.dat.gz

#wget -N http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
#zcat GeoIPASNum.dat.gz > GeoIPASNum.dat
#mv GeoIPASNum.dat /usr/share/GeoIP/GeoIPASNum.dat
