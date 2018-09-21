#!/bin/sh -e 
echo "2018-09-21"

mkdir -p /usr/share/GeoIP/
wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
tar xvzf GeoLite2-City.tar.gz
rm GeoLite2-City.tar.gz

wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz
tar xvzf GeoLite2-ASN.tar.gz
rm GeoLite2-ASN.tar.gz

mv */*.mmdb /usr/share/GeoIP
