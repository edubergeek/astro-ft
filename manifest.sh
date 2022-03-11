#!/bin/bash
# Curt Dodds
# 2020-10-09 Initial version
# 2021-12-06 First cut at spider mode

# wipe any prior mannifest files but keep the master manifest
rm -f manifest_*

# How many files are we downloading?
N=`wc -l <manifest`
echo $N files in manifest

# Get the threads argument or default to 8
threads=${1:-8}
echo $threads threads
n=`expr $N / $threads`
echo $n files per thread
x=`expr $N - $threads \* $n`
echo with $x files remaining

# split the manifest into per thread manifest files
# for fetching from a proxy server it would be helpful to have prior knowledge
# which files are cached on which servers i
# e.g. the PSPS slice servers proxied through web02
y=0
for((t=0;t<$threads;t++))
do
  if test $y -lt $x
  then
    y=`expr $y + 1`
    m=`expr $n + 1`
  else
    m=$n
  fi
  start=`expr $n \* $t + $n + $y`
  head -$start manifest | tail -$m >manifest_$t
done
