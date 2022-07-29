#!/bin/bash
rm $PWD/$1event_{0..9999..1}.dat 2> /dev/null
rm $PWD/$1backup_{0..9999..1}.dat 2> /dev/null
for dir in {0..9..1}; do {
    rm $PWD/$1$dir/log
    for file in {0..9..1}; do {
        rm $PWD/$1$dir/event_${file}.dat
        remove_backups=$(ls $PWD/$1$dir/ | grep -E 'backup_..dat')
        rm $PWD/$1$dir/$remove_backups

    }; done 2> /dev/null
    rm $PWD/$1$dir/HIJING_LBF_test_small.root
}; done
rm AnalysisResults.root
rm -r figures/
