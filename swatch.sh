#!/bin/bash

##
# Displays the current Swatch Internet Time
# 
# -shaun kerr.
##

set -e

function usage {
   cat <<EOF
Usage: $0 [-s -h]

Displays the current Swatch Internet Time

-s |   Do not display fractions
-h |   Show help
EOF
}

while getopts "sh" o; do
   case $o in
      s) fmt="@%03d\n" ;;
      h) usage; exit 0 ;;
      *) usage; exit 1 ;;
   esac
done

seconds=$(date -u +"%-S")
minutes=$(date -u +"%-M")
hours=$((($(date -u +"%-H")+1)%24))
if [ -z $fmt ]; then fmt="@%07.3f\n"; fi

awk -v b="$((seconds + minutes*60 + hours*3600 ))" \
    -v fmt="$fmt" \
    'BEGIN { printf(fmt,b/86.4); }'
