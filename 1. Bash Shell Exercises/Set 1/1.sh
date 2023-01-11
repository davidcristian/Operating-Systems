#!/bin/bash

for user in $(who | awk '{print $1}')
do
    proc=$(ps -Af | grep -Ec "^${user}")
    name=$(cat /etc/passwd | grep -E "^${user}:" | awk -F ':' '{print $5}')

    echo "$proc $name"
done

