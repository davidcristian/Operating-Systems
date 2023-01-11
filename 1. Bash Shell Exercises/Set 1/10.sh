#!/bin/bash

result=""
for user in $(last | awk '{print $1}' | sort | uniq)
do
    count=$(last | grep -Ec "^${user}")
    name=$(cat /etc/passwd | grep -E "^${user}:" | awk -F ':' '{print $5}')

    result="$result$count $name"$'\n'
done

result=$(echo "$result" | sort -n -r -k 1,1)
echo "$result"

