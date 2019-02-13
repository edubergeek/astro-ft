#!/bin/bash

N=`wc -l <manifest`
echo $N files in manifest
threads=${1:-8}
echo $threads threads
n=`expr $N / $threads`
echo $n files per thread

for((t=0;t<$threads;t++))
do
  start=`expr $n \* $t + $n`
  head -$start manifest | tail -$n >manifest_$t
done
