#!/bin/env

echo "THIS HAS NOT BEEN TESTED YET"
exit 1

REMOTE_SOURCE="https://s3.amazonaws.com/pelias-data.nextzen.org/placeholder/store.sqlite3.gz"
LOCAL_SOURCE=`basename ${SOURCE}`
FNAME="${LOCAL_SOURCE}"

LAST_ETAG="${FNAME}.etag"

if [ -f ${LOCAL_SOURCE} ]
then
    
    if [ -f ${LAST_ETAG} ]
    then
	LAST_ETAG_VALUE=`cat ${LAST_ETAG}`
	CURRENT_ETAG_VALUE=`curl -s -I ${SOURCE} | grep ETag`

	if [ "${LAST_ETAG_VALUE}" = "${CURRENT_ETAG_VALUE}" ]
	then
	    echo "No changes to the data"
	    exit 0
	fi
    fi
fi

curl -s -I ${SOURCE} | grep ETag > ${LAST_ETAG}

wget ${REMOTE_SOURCE}
gunzip ${FNAME}
