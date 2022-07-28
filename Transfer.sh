#!/bin/bash

function Transfer2TTree {
  # Transfer the acutal files to the TTree

  local numberOfProcesses=$(nproc)
  local CurrentWorkingDir=$PWD  # save the current working dir for changing to it back later

  cd $1   # change into run directory to save the .root file into it

  local Files=$(find -name "event_*.dat") # locate all the event files and store them in an array

  for File in $Files; do  # iterate over the File array
    root -l -b -q ${CurrentWorkingDir}/importASCIIfileIntoTTree.C\(\"${File}\"\); # execute the root file transfering
  done

  cd $CurrentWorkingDir;  # change back to the primary working directory

  return 0;
}

function Transfering {

  local numberOfProcesses=$(nproc)
  local run;

  for (( run = 0; run < 10; run++ )); do

    if [[ $numberOfProcesses -gt 1 ]]; then # run the Transfer2TTree function for the first nproc number of runs

      (
      Dir=$1$run/
      Transfer2TTree $Dir 1> /dev/null 2> /dev/null
      )

      (( numberOfProcesses--))

    else  # and if the number of processes run out this will reset the process counter

      (
      Dir=$1$run/
      Transfer2TTree $Dir 1> /dev/null 2> /dev/null
      )

      wait
      numberOfProcesses=$(nproc)

    fi;

  done;

  return 0;
}


# Execute the actual script
[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory
Transfering $1 && find $1 -type f -not -name "HIJING_LBF_test_small.*" -exec rm {} \;  || return 2;
