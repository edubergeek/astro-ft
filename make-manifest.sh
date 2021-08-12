#!/bin/bash
# Curt Dodds
# October 9, 2020

URL=$1
if test -z "$URL"
then
  echo "You must specific a URL to download from. Exiting."
  exit 1
fi
SERVER=`expr $URL : 'http[s]*://\([^/]*\)'`
URLPATH=`expr $URL : '.*:[0-9]*\(\/.*[/]\)$'`

ipp_pattern() {
#  grep "href=\"$SERVER"
#</th></tr><tr><td><a href="./B03481753  ">B03481753  </a></td><td>2018-02-01T05:08:54Z</td><td>IPP_PSPS</td><td>
   egrep "href=\"\.\/[A-Z0-9 ]*\""
}

dtn_pattern() {
#  grep "href=\"$SERVER"
   egrep "href=\"[A-Z0-9a-z].*\""
}

default_pattern() {
#  grep "href=\"$SERVER"
#  grep href= | egrep '.csv|.zg|.tgz|.gz|.fits|.txt|.dat|.bak'
   egrep "href=\"[^\"]*\.[A-Za-z][A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?\""
}

match_pattern() {
  case $URL in
#  http://archive.stsci.edu/*)
#    mast_pattern
#    ;;
  http://128.171.123.254:22282/*)
    ipp_pattern
    ;;
  http://dtn-itc.ifa.hawaii.edu/*)
    dtn_pattern
    ;;
  *)
    default_pattern
    ;;
  esac
}

strip_server() {
  sed -e "s/^http[s]*:\/\/$SERVER//"
  echo $?
}

#<title>Index of /ps1/wise-photo-z</title>

# create an empty manifest file
cp /dev/null manifest

# generate a list of files in the web directory
#curl $URL 2>/dev/null | awk '{print $5}' | match_pattern >href-list
curl -o html-list $URL
match_pattern <html-list >href-list
sed -e 's/.*href="\([htps]*[^"]*\)".*$/\1/' <href-list | strip_server >mani-list

# strip URL down to just the web root URL
# the rest of the URL is in each row in mani-list
# only do this if the href-list contains http:
#grep 'http[s]*://' html-list >/dev/null 2>&1 && URL=`expr $URL : '\(http[s]*://[^/]*\)'`
URL=`expr $URL : '\(http[s]*://[^/]*\)'`
#grep 'http[s]*://' html-list >/dev/null 2>&1 && URLPATH=`expr $URLPATH : "$URL"'\(.*\)'`
URLPATH=`expr $1 : "$URL"'\(.*\)'`

echo SERVER $SERVER
echo URL  $URL
echo URLPATH  $URLPATH


cat mani-list | while read f
do
  case $URL in
  http://128.171.123.254:22282)
    fsize=`curl -s -L $URL/$URLPATH/$f | grep 'tr.*href=' | sed -e 's/.*>\([0-9][0-9]*\)<.*$/\1/g'`
    ;;
  *)
    fsize=`curl -L -I $URL/$URLPATH/$f 2>/dev/null | grep Content-Length | awk '{print $2}'`
    ;;
  esac
  echo $URL/$URLPATH $f $fsize | tr -d "\r"
done | awk '{if(NF==3) print ;}' >manifest
#rm -f mani-list href-list html-list
exit 0
