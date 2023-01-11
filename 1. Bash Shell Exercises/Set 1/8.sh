#!/bin/bash

drives=$(df --block-size=M | tail -n +2)
while IFS= read -r line
do
    blocks=$(echo "$line" | awk '{print $2}' | sed -E 's/.$//')
    used=$(echo "$line" | awk '{print $5}' | sed -E 's/.$//')
    drive=$(echo "$line" | awk '{print $6}')

    if [ "$blocks" -lt 1000 ] || [ "$used" -gt 80 ]; then
        echo "$drive"
    fi
done <<< "$drives"

