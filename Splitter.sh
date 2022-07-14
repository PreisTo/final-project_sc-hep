#!/bin/bash

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }

for run in {0..9..1}; do {
    path="$PWD/$1${run}"
    file="HIJING_LBF_test_small.out"
    line_nrs=( $(grep -n BEGINNINGOFEVENT "${path}/${file}" | awk 'BEGIN {FS=": "} {print $1}') )
    for event in {0..8..1}; do {
        start=$((${line_nrs[${event}]}+1))
        end=$((${line_nrs[$((${event}+1))]}-1))
        sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat
    }; done
    #sed -n '(( ${line_nrs[9]}+1 )),$p' > event_9.dat

}; done
