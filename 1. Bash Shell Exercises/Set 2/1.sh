#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "ERROR: Provide at least one directory argument."
    exit 1
fi

count=0
for dir in "$@"
do
    count=$(($count + $(find "$dir" -type f -name "*.c" | wc -l)))
done

echo "Found $count C source files."

