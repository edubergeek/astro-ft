#!/bin/bash
# Curt Dodds
# October 9, 2020

# auto build diskthru
test -e diskthru || make diskthru
if test ! -e diskthru
then
  echo Could not build diskthru ... exiting
  exit 1
fi

# get thread count by counting manifest files
THREADS=`ls manifest_* | wc -l`

# get the final download stats from the log and feed to diskthru
grep size wget.log|./diskthru $THREADS

echo Using $THREADS threads
