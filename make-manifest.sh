#!/bin/bash

URL=http://dtn-itc.ifa.hawaii.edu//ps1/wise-photo-z/
#URL=$1

#<title>Index of /ps1/wise-photo-z</title>

# create an empty manifest file
cp /dev/null manifest

# generate a list of files in the web directory
curl $URL 2>/dev/null | awk '{print $5}' | grep '^href' | tail -n +3 | sed -e 's/^href.*"\(.*\)".*$/\1/' >mani-list
cat mani-list | while read f
do
  fsize=`curl -L -I $URL/$f 2>/dev/null | grep Content-Length | awk '{print $2}'`
  echo $URL $f $fsize | tr -d "\r" >>manifest
done
rm -f mani-list
exit 0
