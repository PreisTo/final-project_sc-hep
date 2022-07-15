#!/bin/bash

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }

for run in {0..9..1}; do {
    numberOfProcesses=$(nproc)
    path="$PWD/$1${run}"
    file="HIJING_LBF_test_small.out"
    lineNrs=( $(grep -n BEGINNINGOFEVENT "${path}/${file}" | awk 'BEGIN {FS=": "} {print $1}') )
    restEvents=$((${#lineNrs[*]}%${numberOfProcesses}))
    
    for (( event=0; event<=$((${#lineNrs[*]}-${restEvents})); event++ )); do {
        (start=$((${lineNrs[${event}]}+1))
        end=$((${lineNrs[$((${event}+1))]}-1))
        sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat)
    }; done
    wait
    for (( event=0; event<=$((${restEvents}-1)); event++ )); do {
        (start=$((${lineNrs[${event}]}+1))
        end=$((${lineNrs[$((${event}+1))]}-1))
        sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat)
    }; done
    wait
    sed -n ${lineNrs[-1]},$(sed -n '$=' ${path}/${file})p ${path}/${file} > ${path}/event_$((${#lineNrs[*]}-1)).dat
}; done
