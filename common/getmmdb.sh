#!/bin/sh -e 
echo "2018-09-21"

get_geoip_db () {
    # Fetches specified EDITION_ID db from maxmind using
    # active LICENSE_KEY.
    # 
    # This gets the latest version of the db. To get db corresponding to a
    # particular date, add the following URL paramater:
    #
    #   date=YYYYMMDD (e.g. 20200107)
    #
    # As described in [2] below, this requires an active user account
    # and an associated LICENSE_KEY (free).
    #
    # References:
    #
    # [1] https://dev.maxmind.com/geoip/geoipupdate/#Direct_Downloads
    # [2] https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/

    EDITION_ID=$1
    SUFFIX=$2
    LICENSE_KEY=$3

    BASE_URL="https://download.maxmind.com/app/geoip_download"
    wget "$BASE_URL?edition_id=$EDITION_ID&license_key=$LICENSE_KEY&suffix=$SUFFIX" \
        -O $EDITION_ID.$SUFFIX
}


main () {
    # Entry point for the script.
    #
    # Relies on build time environment variable: MAXMIND_LICENSE_KEY
    # to be set.

    LICENSE_KEY=$1

    MD5_FILE=checksums.md5
    rm -f $MD5_FILE
    for DB in GeoLite2-ASN GeoLite2-City
    do
        get_geoip_db $DB tar.gz  $LICENSE_KEY
        get_geoip_db $DB tar.gz.md5  $LICENSE_KEY

        # Create MD5 sum file for cehcking
        cat $DB.tar.gz.md5 >> $MD5_FILE
        echo " $DB.tar.gz" >> $MD5_FILE
    done

    md5sum -c $MD5_FILE

    for DB in GeoLite2-ASN GeoLite2-City
    do
        tar xvzf $DB.tar.gz
        rm $DB.tar.gz
        mv */*.mmdb /usr/share/GeoIP
    done
}

# First argument to this script is the MAXMIND_LICENSE_KEY, otherwise
# do nothing.
if [ -z "$1" ]
    then
        echo "MAXMIND_LICENSE_KEY not supplied. Skipping DB download."
    exit 0
fi

main $1
