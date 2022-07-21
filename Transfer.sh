#!/bin/bash

function Transfer2TTree {
  [[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory
  local CurrentWorkingDir=$PWD
  cd $1
  local Files=$(find -name "event_*.dat")
  for File in $Files; do {
    root -l -b -q ${CurrentWorkingDir}/importASCIIfileIntoTTree.C\(\"${File}\"\)
  }; done
  cd $CurrentWorkingDir;

  return 0;
}

function

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

NumberOfProcesses=$(nproc)

for (( i = 0; i < 10; i++ )); do {
  Dir=$1$i/
  if [[ NumberOfProcesses -gt 1 ]]; then {
    (Transfer2TTree $Dir) 1> /dev/null
    (( NumberOfProcesses-- ))
  }
  else {
    (Transfer2TTree $Dir)
    wait && echo "Waiting"
    NumberOfProcesses=$(nproc)
  }; fi
}; done

