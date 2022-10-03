#!/bin/bash
# Curt Dodds
# 2020-10-09 the OG
# 2021-12-07 spider version developed for PS1 MDS

URL=$1
if test -z "$URL"
then
  echo "You must specific a URL to download from. Exiting."
  exit 1
fi
PROTO=`expr $URL : '^\(http[s]*\):.*'`
SERVER=`expr $URL : 'http[s]*://\([^/]*\)'`
URLPATH=`expr $URL : '.*:[0-9]*\(\/.*[/]\)$'`
URLPATH=`echo $URLPATH | sed -e 's:/$::' -e "s;//$SERVER;;"`
#URLPATH=`echo $URLPATH | sed -e 's:/$::'`

strip_server() {
  sed -e "s/^http[s]*:\/\/$SERVER//"
  echo $?
}

# create an empty manifest file
cp /dev/null manifest

# recursivley list web directories until non directories are discovered

echo Proto  $PROTO
echo Server $SERVER
echo Path   $URLPATH
echo URL    $URL

file_type() {
  case "$1" in
  *.tgz) echo tarball;;
  *.gz)  echo gzip;;
  *.bak) echo mssql;;
  *.sh) echo shell;;
  *.fits) echo fits;;
  *.cdf) echo cdf;;
  *.psf) echo psf;;
  *.mdc) echo mdc;;
  esac
}

filesize() {
  fsize=`curl -L -I $1/$2 2>/dev/null | grep Content-Length | awk '{print $2}'`
  if test -z "$ftyp"
  then
    echo "0"
  else
    echo $fsize | tr -d "\r"
  fi
}


#href="./B03047939  "
#href="Hot_PS1_PV3_17_001_42.bak"
download() {
curl --silent ${PROTO}://${1}$2/$3 | egrep -v 'Parent Directory|index.txt' | egrep '^.*href="[A-Z0-9a-z./_]* *">' | sed -e 's:^.*href="\([A-Z0-9a-z./_]*\) *">.*$:\1:'  | while read f
do
  f=`basename $f`
  case $f in
  '..') ;;
  *.*)
    ftyp=`file_type $f`
    if test -z "$ftyp"
    then
      download $1 $2/$f ""
    else
      echo $PROTO "$1" "$2" "$f" `filesize "${1}${2}" "$f"` "$ftyp" >>manifest
    fi
    ;;
  *)
    download $1 $2/$f ""
    ;;
  esac
done
}

download $SERVER $URLPATH ""
