#!/bin/bash

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

function ActualFiltering {
    local path="$PWD/$1$2"
    local file="HIJING_LBF_test_small.out"
    local pwd_original=$PWD;
    local event_counter=0
    cd $path
    while read eventFile; do {
        cp $eventFile backup_${event_counter}.dat
        awk '{if ($3 == 0) print $0}' < backup_${event_counter}.dat 1>event_${event_counter}.dat
        CheckFilteringAndRemove ${event_counter}
        ((event_counter++))
    }; done < <(find $path -type f -name "event_*.dat")
    cd $pwd_original
}

function Filtering {
    local numberOfProcesses=$(nproc)
    for run in {0..9..1}; do {
        ( ActualFiltering $1 ${run} )
    }; done
    wait
}

function CheckFilteringAndRemove {
    local testBool=0
    local line
    while read line; do {
        awk '{if ($3 != 0) testBool=1}'
    if [[ testBool -eq 0 ]]; then {
        rm backup_$1.dat
    }
    else {
        echo "Warning: Filtering failed for event $1!"
    }; fi
    }; done < event_$1.dat
    }

Filtering $1