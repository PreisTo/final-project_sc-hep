#!/bin/bash

# check if first input is a directory
[[ -d $1 ]] || return 1;

# Remove old Analysis file if exists
[[ ! -f "AnalysisResults.root" ]] || { rm "AnalysisResults.root"; echo "Removing old Analysis file"; } 2>> log 1>> log

# create the histograms
root -l -b -q createHistos.C\(\"AnalysisResults.root\"\) 2>> log 1>> log

numberOfProcesses=$(nproc)

# run the root script which reads the data into the ttree

for (( Run = 0; Run < 10; Run++ )); do
  echo "Analysing output of Run ${Run}";
  if [[ $numberOfProcesses -gt 1 ]]; then
	  ( root -l -b -q readDataFromTTree.C\(\"${1}${Run}/HIJING_LBF_test_small.root\"\); )
	  (( numberOfProcesses-- ))
	else
	  ( root -l -b -q readDataFromTTree.C\(\"${1}${Run}/HIJING_LBF_test_small.root\"\); )
	  wait
	  numberOfProcesses=$(nproc)
	fi
done 2>> log 1>> log
wait

# create a directory for the figures and export them
mkdir -p figures
root -l -b -q exportHistos.C\(\"AnalysisResults.root\"\) 2>> log 1>> log
echo "All figures saved in directory \"figures\""

# Print out the mean values
root -l -b -q printOutMean.C\(\"AnalysisResults.root\"\)

# Ask if created log file should be removed
read -p "A log file for the transfer and analysis was created. Do you want to delete $PWD/log? [y/n] " yn;
if [[ ${yn^^} == "YES" || ${yn^^} == "Y" ]]; then
  rm log
fi

return 0;
