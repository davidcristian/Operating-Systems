#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "ERROR: Provide exactly one file argument."
    exit 1
fi

final=""
while IFS= read -r line
do
    current=$(echo $line | sed -E 's/^(.+)$/\1@gmail.com/')
    final="$final,$current"
done < "$1"

final=$(echo "$final" | sed -E 's/^.//')
echo "$final"

