#!/bin/bash

### TODOs ###
# add total number of lines + 1 to array to reduce lines of code needed
#############

function Splitting {
    local lineNrs=( $(grep -n BEGINNINGOFEVENT "${1}${2}/${3}" | awk 'BEGIN {FS=": "} {print $1}') )    # get the line numbers of the beggining of events
    local lineNrs[${#lineNrs[@]}]=$(sed -n '$=' ${1}${2}/${3})
    local numberOfProcesses=$(nproc)
    local eventNumber;
    local start;
    local end;
    for (( eventNumber=0; eventNumber < ((${#lineNrs[*]}-1)); eventNumber++ )); do {
      if [[ $numberOfProcesses -gt 1 ]]; then {
        ( start=$((${lineNrs[${eventNumber}]}+1))
        end=$((${lineNrs[$((${eventNumber}+1))]}-1))
        sed -n ${start},${end}p ${1}${2}/${3} > ${1}${2}/event_${eventNumber}.dat )
        (( numberOfProcesses--))

      }
      else {
        ( start=$((${lineNrs[${eventNumber}]}+1))
        end=$((${lineNrs[$((${eventNumber}+1))]}-1))
        sed -n ${start},${end}p ${1}${2}/${3} > ${1}${2}/event_${eventNumber}.dat )
        wait
        numberOfProcesses=$(nproc)
      }; fi
    }; done
    wait

}

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

###
# Check input syntax
###

fileName="HIJING_LBF_test_small.out"
path="$PWD/$1"
for run in {0..9..1}; do {
    Splitting ${path} ${run} ${fileName}

}; done
