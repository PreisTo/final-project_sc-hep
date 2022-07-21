#!/bin/bash



function Transfer2TTree {
  [[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

}



#[[ -d $1 ]] || { echo "Not a directory, exiting"; return 1; }   # check if first input is a directory

NumberOfProcesses=$(nproc)

for (( i = 0; i < 10; i++ )); do {
  Dir=$PWD/$1$i/
  if [[ NumberOfProcesses -gt 1 ]]; then {
    (Transfer2TTree $Dir)
    (( NumberOfProcesses-- ))
  }
  else {
    (Transfer2TTree $Dir)
    wait && echo "Waiting"
    NumberOfProcesses=$(nproc)
  }; fi
}; done

