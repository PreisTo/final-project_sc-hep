#!/bin/bash

function Transfer2TTree {

  [[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

  local CurrentWorkingDir=$PWD

  cd $1   # change into run directory to save the .root file into it

  local Files=$(find -name "event_*.dat")

  for File in $Files; do {

    root -l -b -q ${CurrentWorkingDir}/importASCIIfileIntoTTree.C\(\"${File}\"\)

  }; done

  cd $CurrentWorkingDir;

  return 0;
}

function DirectorySweeper {

  [[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

  find $1 -type f -not -name "HIJING_LBF_test_small.*" -exec rm {} \;

  return 0;
}

function ExceTransfer {
: <<HERE-Document
  NumberOfProcesses=$(nproc)

  for (( i = 0; i < 10; i++ )); do {

    Dir=$1$i/

    if [[ NumberOfProcesses -gt 1 ]]; then {

      (Transfer2TTree $Dir) 1> /dev/null 2> /dev/null

      (( NumberOfProcesses-- ))

    }

    else {

      (Transfer2TTree $Dir) 1> /dev/null 2> /dev/null

      wait && echo "Waiting"

      NumberOfProcesses=$(nproc)

    }; fi

  }; done
HERE-Document
  for (( i = 0; i < 10; i++ )); do {

    Dir=$1$i/


      Transfer2TTree $Dir 1> /dev/null 2> /dev/null

    }; done
  return 0;
}

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

ExceTransfer $1 && DirectorySweeper $1 || return 1;
