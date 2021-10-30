#!/bin/bash
inputfile="test.txt"
declare -a sids
#sids=()
while IFS= read -r line
do
 sid=${line%,*}
 sids=("${sids[@]}" "$sid")
 echo $sid
 echo $sids
done < "$inputfile"
#echo $sids
