#!/bin/bash

DATE=$(date +%Y%m%d)

rm /transfer -rf || /bin/true
mkdir /transfer

for index in airrow airrow-trajectories airrow-points airrow-ratings airrow-capabilities
do
elasticdump \
  --input=http://es:9200/$index \
  --output=/transfer/$index.analyzer.json \
  --type=analyzer
elasticdump \
  --input=http://es:9200/$index \
  --output=/transfer/$index.mapping.json \
  --type=mapping
elasticdump \
  --input=http://es:9200/$index \
  --output=/transfer/$index.data.json \
  --type=data
done

tar cfz - /transfer/ | curl -k -T - -u "${SHARE_KEY}:" -H 'X-Requested-With: XMLHttpRequest' "https://cloud.geodiscovery.xn--rro-pla.de/public.php/webdav/airrow-${DATE}-esdump.tar.gz"
tar cfz - /data/ | curl -k -T - -u "${SHARE_KEY}:" -H 'X-Requested-With: XMLHttpRequest' "https://cloud.geodiscovery.xn--rro-pla.de/public.php/webdav/airrow-${DATE}-filedump.tar.gz"
