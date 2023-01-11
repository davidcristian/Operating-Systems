#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "ERROR: Provide exactly one directory argument."
    exit 1
fi

for file in $(find "$1" -type f -name '*.log')
do
    sort "$file" -o "$file"
done

echo "INFO: Done."

