#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "ERROR: Provide at least one group."
    exit 1
fi

result=""
for group in "$@"
do
    members=$(grep -E "^${group}" /etc/group)
    if [ -z "$members" ]; then
        result="${result}-1 ${group}"$'\n'
        continue
    fi
    
    num=0
    for member in $(echo "$members" | awk -F ':' '{print $4}' | sed -E 's/,/\n/')
    do
        ((num++))
    done
    result="${result}${num} ${group}"$'\n'
done

result=$(echo "$result" | head -n -1 | sort -n -r -k 1,1)
echo "$result"

