#!/bin/bash

#!/bin/bash

[[ ! -d $1 ]] && echo "Not a valid directory!" && return 6

time source Splitter.sh $1 && echo "Done with Splitter.sh" || return 5
time source Filter.sh $1 && echo "Done with Filter.sh" || return 4
time source Transfer.sh $1 && echo "Done with Transfer.sh" || return 3
time source Analysis.sh $1 && echo "Done with Analysis.sh" || return 2

return 0;
