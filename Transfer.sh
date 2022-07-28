#!/bin/bash

function Transfer2TTree {

  local CurrentWorkingDir=$PWD

  cd $1   # change into run directory to save the .root file into it

  local Files=$(find -name "event_*.dat")

  for File in $Files; do

    root -l -b -q ${CurrentWorkingDir}/importASCIIfileIntoTTree.C\(\"${File}\"\)

  done

  cd $CurrentWorkingDir;

  return 0;
}

function DirectorySweeper {

  find $1 -type f -not -name "HIJING_LBF_test_small.*" -exec rm {} \;

  return 0;
}

function Transfering {

  local numberOfProcesses=$(nproc)
  local i;

  for (( i = 0; i < 10; i++ )); do
    : <<'HERE-DOC'
    if [[ $numberOfProcesses -gt 1 ]]; then

      (
      Dir=$1$i/
      Transfer2TTree $Dir 1> /dev/null 2> /dev/null
      )

      (( numberOfProcesses--))

    else

      (
      Dir=$1$i/
      Transfer2TTree $Dir 1> /dev/null 2> /dev/null
      )

      wait
      numberOfProcesses=$(nproc)

    fi;
HERE-DOC

    Dir=$1$i/
    Transfer2TTree $Dir 1> /dev/null 2> /dev/null
  done;

  return 0;
}

[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory
Transfering $1 #&& DirectorySweeper $1 || return 2;
