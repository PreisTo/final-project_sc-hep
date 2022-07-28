#!/bin/bash

[[ -d $1 ]] || return 1;
[[ ! -f "AnalysisResults.root" ]] || { rm "AnalysisResults.root"; echo "Removing old Analysis file"; }
root -l -b -q createHistos.C\(\"AnalysisResults.root\"\)

numberOfProcesses=$(nproc)

for (( i = 0; i < 10; i++ )); do ## TODO change run number!!!
  echo "Analysing output of Run ${i}";
  if [[ $numberOfProcesses -gt 1 ]]; then
	  ( root -l -b -q readDataFromTTree.C\(\"${1}${i}/HIJING_LBF_test_small.root\"\); )
	  (( numberOfProcesses-- ))
	else
	  ( root -l -b -q readDataFromTTree.C\(\"${1}${i}/HIJING_LBF_test_small.root\"\); )
	  wait
	  numberOfProcesses=$(nproc)
	fi
done
wait

mkdir -p figures
root -l -b -q exportHistos.C\(\"AnalysisResults.root\"\)
echo "Everything saved in directory \"figures\""
return 0;
