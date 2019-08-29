#!/bin/env

REMOTE_SOURCE="https://s3.amazonaws.com/pelias-data.nextzen.org/placeholder/store.sqlite3.gz"

LOCAL_SOURCE=`basename ${REMOTE_SOURCE}`
LOCAL_SOURCE_UNCOMPRESSED=`echo ${LOCAL_SOURCE} | sed -e 's/.gz//'`

FNAME="${LOCAL_SOURCE}"

LAST_ETAG="${FNAME}.etag"

if [ -f ${LOCAL_SOURCE} ] || [ -f ${LOCAL_SOURCE_UNCOMPRESSED} ]
then

    if [ -f ${LAST_ETAG} ]
    then
	LAST_ETAG_VALUE=`cat ${LAST_ETAG}`
	CURRENT_ETAG_VALUE=`curl -s -I ${REMOTE_SOURCE} | grep ETag`

	if [ "${LAST_ETAG_VALUE}" = "${CURRENT_ETAG_VALUE}" ]
	then
	    echo "No changes to the data. Nothing to fetch."
	    exit 0
	fi
    fi
fi

if [ -f ${LAST_ETAG} ]
then
    mv ${LAST_ETAG} ${LAST_ETAG}.last
fi

curl -s -I ${REMOTE_SOURCE} | grep ETag > ${LAST_ETAG}

wget ${REMOTE_SOURCE}
gunzip ${FNAME}
