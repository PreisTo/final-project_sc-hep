#!/bin/bash

### TODOs ###
# add total number of lines + 1 to array to reduce lines of code needed
#############

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

###
# Check input syntax
##


numberOfProcesses=$(nproc)

for run in {0..9..1}; do

    path="$PWD/$1${run}"
    file="HIJING_LBF_test_small.out"
    lineNrs=( $(grep -n BEGINNINGOFEVENT "${path}/${file}" | awk 'BEGIN {FS=": "} {print $1}') )    # get the line numbers of the beggining of events
    lineNrs[${#lineNrs[*]}]=$(sed -n '$=' "${path}/${file}")
    if [[ $numberOfProcesses -gt 1 ]]; then
      (
      for (( event=0; event<((${#lineNrs[*]}-1)); event++ )); do
        start="$((${lineNrs[${event}]}+1))";
        end="$((${lineNrs[$((${event}+1))]}-1))"
        sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat;
      done;
      )
      (( numberOfProcesses-- ))
    else
      (
      for (( event=0; event<((${#lineNrs[*]}-1)); event++ )); do
        start=$((${lineNrs[${event}]}+1));
        end=$((${lineNrs[$((${event}+1))]}-1));
        sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat;
      done;
      )
      wait
      numberOfProcesses=$(nproc)
    fi
done
