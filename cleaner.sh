#!/bin/bash

for dir in {0..9..1}; do {
    for file in {0..9..1}; do {
        rm $PWD/$1/$dir/event_${file}.dat
    }; done
}; done