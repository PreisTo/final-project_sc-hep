#!/bin/bash

[[ -d $1 ]] || return 1;

for (( Run = 0; Run < 1; Run++ )); do ## TODO change run number!!!

    root -l -b -q readDataFromTTree.C\(\"${1}HIJING_LBF_test_small.root\"\)

done
