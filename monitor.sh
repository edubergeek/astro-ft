#!/bin/bash
# Curt Dodds
# October 9, 2020

# get thread count by counting manifest files
THREADS=`ls manifest_* | wc -l`

# get the final download stats from the log and feed to diskthru
egrep '100%' wget*.log| wc -l
