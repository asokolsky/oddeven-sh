#!/bin/bash

log_name=$1
#echo "$log_name"
# replace the trailing '-' with 0 | then adds up the sum of the last column and divides it by the number of rows, giving the average
awk '{gsub(/-$/, "0")}1' "$log_name" | awk '{ sum += $NF } END { print sum/NR }'
# here, we find the numbers in the second to last column that are unique and count them up
awk '{print $(NF-1)}' "$log_name" | sort | uniq | wc -l | tr -d ' '
