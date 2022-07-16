#!/bin/bash

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

for run in {0..9..1}; do {
    numberOfProcesses=$(nproc)
    path="$PWD/$1${run}"
    file="HIJING_LBF_test_small.out"
    pwd_original=$PWD;
    event_counter=0
    cd $path
    while read eventFile; do {
        
        cp $eventFile backup_${event_counter}.dat
        ((event_counter++))
    }; done < <(find $path -type f -name "event_*.dat")
    cd $pwd_original
}; done
