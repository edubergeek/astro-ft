#!/bin/bash
# Curt Dodds
# October 9, 2020

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

# split the manifest into per thread manifest files
# for fetching from a proxy server it would be helpful to have prior knowledge
# which files are cached on which servers i
# e.g. the PSPS slice servers proxied through web02
for((t=0;t<$threads;t++))
do
  start=`expr $n \* $t + $n`
  head -$start manifest | tail -$n >manifest_$t
done
