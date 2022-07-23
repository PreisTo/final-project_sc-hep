#!/bin/bash

function ExceAnalyser {
    local Dir=$1;
    local Run=$2;
    echo "Analysing output of Run ${Run}"
    root -l -b -q readDataFromTTree.C\(\"${Dir}${Run}/HIJING_LBF_test_small.root\"\)
    return 0;
}


[[ -d $1 ]] || return 1;
[[ ! -f "AnalysisResults.root" ]] || { rm "AnalysisResults.root"; echo "Removing old Analysis file"; }
root -l -b -q createHistos.C\(\"AnalysisResults.root\"\)

NumberOfProcesses=$(nproc)

for (( Run = 0; Run < 10; Run++ )); do ## TODO change run number!!!
{
    ExceAnalyser $1 ${Run}
}; done
wait;
mkdir -p figures
root -l -b -q exportHistos.C\(\"AnalysisResults.root\"\)