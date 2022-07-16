#!/bin/bash

for dir in {0..9..1}; do {
    for file in {0..9..1}; do {
        rm $PWD/$1$dir/event_${file}.dat
        remove_backups=$(ls $PWD/$1$dir/ | grep -E 'backup_..dat')
        rm $PWD/$1$dir/$remove_backups
    }; done
}; done