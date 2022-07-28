#!/bin/bash

### TODOs ###
# add total number of lines + 1 to array to reduce lines of code needed
#############



[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

###
# Check input syntax
###
numberOfProcesses=$(nproc)

for run in {0..9..1}; do {

    path="$PWD/$1${run}"
    file="HIJING_LBF_test_small.out"
    lineNrs=( $(grep -n BEGINNINGOFEVENT "${path}/${file}" | awk 'BEGIN {FS=": "} {print $1}') )    # get the line numbers of the beggining of events
    lineNrs[${#lineNrs[*]}]=$(sed -n '$=' "${path}/${file}")
    if [[ ${#lineNrs[*]} -ge ${numberOfProcesses} ]]; then {    # check if the amount of events is bigger than nproc
        restEvents=$((${#lineNrs[*]}%${numberOfProcesses}));    # get modulo of amount of events % nproc
    }
    else {
        restEvents=0    # if amount of events is smaller or equal set rest to 0 to prevent double event running
    }; fi
    
    if [[ restEvents -eq 0 ]]; then {
        for (( event=0; event<$((${#lineNrs[*]}-1)); event++ )); do {   # run extracting for all events except the last one
            (
            start=$((${lineNrs[${event}]}+1))
            end=$((${lineNrs[$((${event}+1))]}-1))
            sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat
            )
        }; done

    }
    else {
        for (( event=0; event<$((${#lineNrs[*]}-${restEvents})); event++ )); do {   # same as before for the first nproc number of events
            (
            start=$((${lineNrs[${event}]}+1))
            end=$((${lineNrs[$((${event}+1))]}-1))
            sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat
            )
        }; done
        wait
        startEvent=$((${#lineNrs[*]}-${restEvents}))    # set next event to the next one to prevent double extracting
        for (( event=${startEvent}; event<$((${#lineNrs[*]}-1)); event++ )); do {   # and for the rest of the events except the last one
            (
            start=$((${lineNrs[${event}]}+1))
            end=$((${lineNrs[$((${event}+1))]}-1))
            sed -n ${start},${end}p ${path}/${file} > ${path}/event_${event}.dat
            )
        }; done
    }; fi
}; done
