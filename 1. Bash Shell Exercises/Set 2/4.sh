#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "ERROR: Provide a number and at least one C source file."
    exit 1
fi

if ! echo "$1" | grep -Eq '^[1-9][0-9]*$'; then
    echo "ERROR: Invalid number given as first argument."
    exit 1
fi

n="$1"
shift 1

libs=""
for file in "$@"
do
    echo "${file}:"
    while read -r line
    do
        if echo "$line" | grep -Eq '^#include'; then
            echo "$line"
            libs="${libs}${line}"$'\n'
        fi
    done < "$file"
done

result=$(echo "$libs" | head -n -1 | sort | uniq -c | sort -n -r -k 1,1 | head -n "$n")
echo $'\n'"Top $n libraries:"$'\n'"$result"

