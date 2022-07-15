#!/bin/bash

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }

for run in {0..9..1}; do {
    numberOfProcesses=$(nproc)
    path="$PWD/$1${run}"
    file="HIJING_LBF_test_small.out"
    lineNrs=( $(grep -n BEGINNINGOFEVENT "${path}/${file}" | awk 'BEGIN {FS=": "} {print $1}') )
    
    if [[ ${#lineNrs[*]} -ge ${numberOfProcesses} ]]; then {
        restEvents=$((${#lineNrs[*]}%${numberOfProcesses}));
    }
    else {
        restEvents=0
    }; fi
    
    if [[ restEvents -eq 0 ]]; then {
        for (( event=0; event<$((${#lineNrs[*]}-1)); event++ )); do {
            (start=$((${lineNrs[${event}]}+1))
            end=$((${lineNrs[$((${event}+1))]}-1))
            
            sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat)
        }; done
        wait
        
        sed -n $((${lineNrs[-1]}+1)),$(sed -n '$=' ${path}/${file})p ${path}/${file} > ${path}/event_$((${#lineNrs[*]}-1)).dat
    }
    else {
        for (( event=0; event<$((${#lineNrs[*]}-${restEvents})); event++ )); do {
            (start=$((${lineNrs[${event}]}+1))
            end=$((${lineNrs[$((${event}+1))]}-1))
            
            sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat)
        }; done
        wait
        startEvent=$((${#lineNrs[*]}-${restEvents}))
        for (( event=${startEvent}; event<$((${#lineNrs[*]}-2)); event++ )); do {
            (start=$((${lineNrs[${event}]}+1))
            end=$((${lineNrs[$((${event}+1))]}-1))
            
            sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat)
        }; done
        wait
        
        sed -n $((${lineNrs[-1]}+1)),$(sed -n '$=' ${path}/${file})p ${path}/${file} > ${path}/event_$((${#lineNrs[*]}-1)).dat
    }; fi
}; done
