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

default_pattern() {
#  grep "href=\"$SERVER"
  grep href= | egrep '.csv|.zg|.tgz|.gz|.fits|.txt|.dat|.bak'
}

match_pattern() {
  case $URL in
#  http://archive.stsci.edu/*)
#    mast_pattern
#    ;;
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
grep 'http[s]*://' html-list >/dev/null 2>&1 && URL=`expr $URL : '\(http[s]*://[^/]*\)'`

cat mani-list | while read f
do
  fsize=`curl -L -I $URL/$f 2>/dev/null | grep Content-Length | awk '{print $2}'`
  echo $URL $f $fsize | tr -d "\r"
done | awk '{if(NF==3) print ;}' >manifest
rm -f mani-list href-list html-list
exit 0
